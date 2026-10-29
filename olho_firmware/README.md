# Olho — firmware do Uno

Compilado e verificado com arduino-cli (Uno, 32 % da flash). Funciona sozinho,
sem celular: vagueia e reage ao ultrassom. O celular é extra.

## Gravar (Windows)

1. Instala o Arduino IDE 2 (arduino.cc/en/software).
2. Abre `olho_firmware.ino`.
3. Tools → Board → Arduino Uno. Tools → Port → a COM que aparecer com o Uno plugado.
4. Botão de seta (Upload). Pronto.

A biblioteca Servo já vem no IDE. Não precisa instalar nada.

## Ligações

Energia (duas fontes, GND comum):
- Pilha 9 V → clipe com plugue → entrada redonda do Uno.
- Suporte 4×AA (6 V) → fio vermelho na linha **+** da protoboard, fio preto na linha **−**.
- Jumper da linha **−** da protoboard até um pino **GND** do Uno (ESSENCIAL).
- Nunca ligue o fio vermelho das AA no 5V do Uno.

Servos do pan-tilt (fio marrom = GND, vermelho = +, laranja = sinal):
- Marrom → linha − ; vermelho → linha + ; laranja do servo de BAIXO (pan) → **D9**.
- Idem servo de CIMA (tilt), laranja → **D10**.

Sensores HC-SR04 (VCC, TRIG, ECHO, GND):
- Os dois: VCC → linha + ; GND → linha −.
- Esquerdo: TRIG → **D4**, ECHO → **D5**.
- Direito:  TRIG → **D6**, ECHO → **D7**.
- "Esquerdo" é o lado esquerdo de quem usa a gaiola (seu lado esquerdo).

HM-10 (BLE), 4 pinos VCC / GND / TXD / RXD:
- VCC → **5V do Uno** (a placa DSD TECH aceita 5 V) ; GND → GND do Uno.
- TXD → **D2** ; RXD → **D3**.

Se o olho "reto" ficar torto, mude `PAN_CENTER` / `TILT_CENTER`.
Se esquerda e direita saírem trocadas, mude `PAN_INVERT` para `true`.

## Testar sem nada montado

Plugue só o Uno no USB, abra Tools → Serial Monitor (9600, "Newline") e digite:

- `Z` → mostra `D<esq>,<dir>,<modo>` (999 = sensor sem eco ou não ligado).
- `P120,T85` → manda os servos pra esse ângulo (modo remoto).
- `C` → centro. `A` → volta ao automático. `R0` → desliga a reação ao ultrassom.

## Comportamento

- **Vagar:** sacadas aleatórias com pausas de 0,5 a 3 s; às vezes micro-ajustes; de vez em
  quando encara o centro por 3 a 4 s.
- **Alguém a < 65 cm:** vira pro lado onde a pessoa está, encara 2 a 4 s, desvia o olhar por
  0,7 s, encara de novo. Só troca de lado se a diferença passar de 15 cm por meio segundo.
  Solta quando a pessoa passa de 90 cm.
- **Celular mandando ângulos:** obedece. 1,5 s sem mensagem, volta a vagar.
