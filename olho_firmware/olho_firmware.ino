/*
  OLHO — firmware do Arduino Uno (Halloween 2026) — v3
  ------------------------------------------------
  Um olho gigante num pan-tilt de 2 servos, com dois sensores
  ultrassônicos HC-SR04 e um módulo Bluetooth BLE HM-10.

  Modos:
    AUTO    : o olho vagueia sozinho (sacadas) e reage a quem chega perto
              (ultrassom esquerdo/direito).
    REMOTO  : um celular manda ângulos por BLE ("P120,T85"). Se ficar
              30 s sem receber nada, volta sozinho pro modo AUTO.

  Comandos (mesmos por USB Serial e por BLE, uma linha cada):
    P<pan>,T<tilt>   ex: P120,T85   -> vai pra esse ângulo (entra em REMOTO)
    C                -> centro
    A                -> força modo AUTO
    R0 / R1          -> reação ao ultrassom desligada / ligada
    Z                -> imprime status
  O Uno envia a cada 0,5 s (1 s em remoto):  D<esq_cm>,<dir_cm>,<modo>
  e eventos:                  E:perto  /  E:longe

  Ligações (ver também README.md na mesma pasta):
    Servo PAN   sinal -> D9     (laranja/amarelo)
    Servo TILT  sinal -> D10
    HC-SR04 ESQ  TRIG -> D4   ECHO -> D5
    HC-SR04 DIR  TRIG -> D6   ECHO -> D7
    HM-10  TXD -> D2 (RX do Uno)   RXD <- D3 (TX do Uno)
    Servos e sensores: VCC no 5 V das pilhas AA / GND comum.
    Uno: pilha 9 V no plugue. GND das pilhas AA ligado ao GND do Uno.
*/

#include <Servo.h>
#include <SoftwareSerial.h>

// ---------- AJUSTES QUE VOCÊ VAI MEXER ----------
const int PAN_CENTER  = 90;   // olhar reto. Ajuste se o olho "reto" ficar torto
const int TILT_CENTER = 90;
const int PAN_RANGE   = 35;   // graus pra cada lado no modo vagar
const int TILT_RANGE  = 20;
const int PAN_MIN  = 35,  PAN_MAX  = 145;  // limites físicos (não force o servo)
const int TILT_MIN = 55,  TILT_MAX = 125;
const bool PAN_INVERT  = false; // true se "esquerda" sair como direita
const bool TILT_INVERT = false;

const int  NEAR_CM        = 65;   // alguém a menos disso = chegou perto
const int  FAR_CM         = 90;   // só considera que saiu acima disso (histerese)
const int  SIDE_DIFF_CM   = 15;   // diferença esq/dir pra decidir o lado
const unsigned long SIDE_HOLD_MS   = 500;   // lado novo tem que durar isso
const unsigned long STARE_MIN_MS   = 2000;  // encara por 2 a 4 s
const unsigned long STARE_MAX_MS   = 4000;
const unsigned long GLANCE_MS      = 700;   // desvia o olhar rapidinho
const unsigned long REMOTE_TIMEOUT = 30000; // sem BLE por isso -> AUTO (30 s: só se o celular sumir de verdade)
// -------------------------------------------------

const int PIN_PAN = 9, PIN_TILT = 10;
const int TRIG_L = 4, ECHO_L = 5, TRIG_R = 6, ECHO_R = 7;
const int BLE_RX = 2, BLE_TX = 3;   // RX do Uno <- TXD do HM-10 ; TX do Uno -> RXD do HM-10

Servo panServo, tiltServo;
SoftwareSerial ble(BLE_RX, BLE_TX);

enum Mode { AUTO, REMOTE };
Mode mode = AUTO;
bool reactEnabled = true;

// posição atual e alvo (em graus de servo já com centro aplicado)
float curPan = 90, curTilt = 90;
float tgtPan = 90, tgtTilt = 90;
float speedDeg = 6.0;  // graus por passo de 10 ms (6 = sacada rápida)

// ultrassom
int distL = 999, distR = 999;      // cm, 999 = nada visto
bool personNear = false;
int  side = 0;                      // -1 esq, 0 centro, +1 dir
int  candSide = 0; unsigned long candSince = 0;

// temporizadores
unsigned long tStep = 0, tPing = 0, tReport = 0, tNextIdle = 0;
unsigned long tStareUntil = 0, tGlanceUntil = 0, lastRemote = 0;
bool pingLeft = true;
bool glancing = false;

// buffers de linha
char usbBuf[24]; byte usbLen = 0;
char bleBuf[24]; byte bleLen = 0;

// ---------- utilidades ----------
int clampi(int v, int lo, int hi) { return v < lo ? lo : (v > hi ? hi : v); }

void setTarget(int pan, int tilt, float spd) {
  if (PAN_INVERT)  pan  = 2 * PAN_CENTER  - pan;
  if (TILT_INVERT) tilt = 2 * TILT_CENTER - tilt;
  tgtPan  = clampi(pan,  PAN_MIN,  PAN_MAX);
  tgtTilt = clampi(tilt, TILT_MIN, TILT_MAX);
  speedDeg = spd;
}

// move um passo em direção ao alvo (chamado a cada 10 ms)
void stepServos() {
  float dp = tgtPan - curPan, dt = tgtTilt - curTilt;
  if (abs(dp) <= speedDeg) curPan = tgtPan; else curPan += (dp > 0 ? speedDeg : -speedDeg);
  if (abs(dt) <= speedDeg) curTilt = tgtTilt; else curTilt += (dt > 0 ? speedDeg : -speedDeg);
  panServo.write((int)(curPan + 0.5));
  tiltServo.write((int)(curTilt + 0.5));
}

bool arrived() { return abs(tgtPan - curPan) < 0.6 && abs(tgtTilt - curTilt) < 0.6; }

// leitura de um HC-SR04. Sem eco (roupa macia, nada na frente) = 999.
int readSonar(int trig, int echo) {
  digitalWrite(trig, LOW); delayMicroseconds(3);
  digitalWrite(trig, HIGH); delayMicroseconds(10);
  digitalWrite(trig, LOW);
  unsigned long us = pulseIn(echo, HIGH, 12000UL); // ~2 m máximo
  if (us == 0) return 999;
  int cm = (int)(us / 58UL);
  if (cm < 2) return 999;
  return cm;
}

// ---------- comportamento AUTO ----------
void idleWander() {
  // escolhe um novo ponto e para por um tempo. Olho de verdade pula, não desliza.
  int r = random(100);
  if (r < 12) {
    // encara reto por mais tempo, como se tivesse achado alguém
    setTarget(PAN_CENTER, TILT_CENTER, 6.0);
    tNextIdle = millis() + random(2500, 4500);
  } else if (r < 32) {
    // micro-ajuste: 2 ou 3 graus, como quem lê
    setTarget((int)curPan + random(-4, 5), (int)curTilt + random(-3, 4), 3.0);
    tNextIdle = millis() + random(250, 600);
  } else {
    setTarget(PAN_CENTER + random(-PAN_RANGE, PAN_RANGE + 1),
              TILT_CENTER + random(-TILT_RANGE, TILT_RANGE + 1), 6.0);
    tNextIdle = millis() + random(500, 3000);
  }
}

void updatePerson() {
  int nearest = min(distL, distR);
  unsigned long now = millis();

  // chegou / saiu, com histerese
  if (!personNear && nearest < NEAR_CM) {
    personNear = true;
    tStareUntil = now + random(STARE_MIN_MS, STARE_MAX_MS);
    glancing = false;
    sendEvent("E:perto");
  } else if (personNear && nearest > FAR_CM) {
    personNear = false;
    side = 0; candSide = 0;
    sendEvent("E:longe");
    tNextIdle = now + 400;
  }
  if (!personNear) return;

  // de que lado? só troca se a diferença for clara e durar SIDE_HOLD_MS
  int want = 0;
  if (distL < distR - SIDE_DIFF_CM) want = -1;
  else if (distR < distL - SIDE_DIFF_CM) want = +1;
  if (want != candSide) { candSide = want; candSince = now; }
  if (candSide != side && now - candSince >= SIDE_HOLD_MS) side = candSide;
}

void stareBehavior() {
  unsigned long now = millis();
  int panAim = PAN_CENTER + side * 28;     // 28 graus pro lado da pessoa
  int tiltAim = TILT_CENTER - 6;           // levemente pra cima: rosto fica acima da gaiola

  if (!glancing && now > tStareUntil) {
    // desvia o olhar por um instante, depois volta a encarar
    glancing = true;
    tGlanceUntil = now + GLANCE_MS;
    setTarget(panAim + random(-25, 26), tiltAim + random(-15, 16), 6.0);
    return;
  }
  if (glancing && now > tGlanceUntil) {
    glancing = false;
    tStareUntil = now + random(STARE_MIN_MS, STARE_MAX_MS);
  }
  if (!glancing) setTarget(panAim, tiltAim, 6.0);
}

// ---------- comunicação ----------
void sendBoth(const char* s) { Serial.println(s); ble.println(s); }
void sendEvent(const char* s) { sendBoth(s); }

void reportStatus() {
  char out[40];
  snprintf(out, sizeof(out), "D%d,%d,%c", distL, distR, mode == AUTO ? 'A' : 'R');
  sendBoth(out);
}

void handleLine(char* line) {
  if (line[0] == 0) return;
  switch (line[0]) {
    case 'P': case 'p': {
      int pan = atoi(line + 1);
      char* t = strchr(line, 'T'); if (!t) t = strchr(line, 't');
      int tilt = t ? atoi(t + 1) : TILT_CENTER;
      mode = REMOTE; lastRemote = millis();
      setTarget(pan, tilt, 2.5);           // mais suave que sacada: é rastreio
      break;
    }
    case 'C': case 'c': setTarget(PAN_CENTER, TILT_CENTER, 6.0); mode = REMOTE; lastRemote = millis(); break;
    case 'A': case 'a': mode = AUTO; tNextIdle = 0; break;
    case 'R': case 'r': reactEnabled = (line[1] != '0'); break;
    case 'Z': case 'z': reportStatus(); break;
    default: break;
  }
}

void pumpSerial(Stream& s, char* buf, byte& len) {
  while (s.available()) {
    char c = s.read();
    if (c == '\n' || c == '\r') { buf[len] = 0; handleLine(buf); len = 0; }
    else if (len < 22) buf[len++] = c;
  }
}

// ---------- setup / loop ----------
void setup() {
  Serial.begin(9600);
  ble.begin(9600);                 // HM-10 vem de fábrica em 9600
  pinMode(TRIG_L, OUTPUT); pinMode(ECHO_L, INPUT);
  pinMode(TRIG_R, OUTPUT); pinMode(ECHO_R, INPUT);
  randomSeed(analogRead(A0));
  panServo.attach(PIN_PAN);
  tiltServo.attach(PIN_TILT);
  curPan = tgtPan = PAN_CENTER; curTilt = tgtTilt = TILT_CENTER;
  panServo.write(PAN_CENTER); tiltServo.write(TILT_CENTER);
  delay(600);
  Serial.println(F("OLHO pronto. Comandos: P<pan>,T<tilt>  C  A  R0/R1  Z"));
}

void loop() {
  unsigned long now = millis();

  pumpSerial(Serial, usbBuf, usbLen);
  pumpSerial(ble, bleBuf, bleLen);

  // ultrassom: alterna esq/dir a cada 70 ms
  if (now - tPing >= 70) {
    tPing = now;
    if (pingLeft) distL = readSonar(TRIG_L, ECHO_L); else distR = readSonar(TRIG_R, ECHO_R);
    pingLeft = !pingLeft;
  }

  // REMOTO cai pra AUTO se o celular sumir
  if (mode == REMOTE && now - lastRemote > REMOTE_TIMEOUT) { mode = AUTO; tNextIdle = 0; }

  if (mode == AUTO) {
    if (reactEnabled) updatePerson(); else personNear = false;
    if (personNear) stareBehavior();
    else if (now >= tNextIdle && arrived()) idleWander();
  }

  if (now - tStep >= 10) { tStep = now; stepServos(); }

  // relatório menos frequente: a SoftwareSerial não ouve enquanto fala, então falar menos = perder menos comandos
  unsigned long reportEvery = (mode == REMOTE) ? 1000 : 500;
  if (now - tReport >= reportEvery) { tReport = now; reportStatus(); }
}
