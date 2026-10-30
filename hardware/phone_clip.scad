// TRAVA DO CELULAR: barrinha que encaixa por pressão nas cabeças dos 2 pinos do berço (mesma altura),
// passando por cima da traseira do celular. Imprime deitada. Precisa de 2 (uma por par de pinos: z=45 e z=90).
ph_w = 80; rail = 4; slot_w = ph_w + 0.6;
span = slot_w + 2*rail + 2*5 + 6;    // de pino a pino, mais sobra
t = 2.4; w = 16;
$fn = 48;
difference() {
  hull() { for (s=[-1,1]) translate([s*(span/2-w/2), 0, 0]) cylinder(d=w, h=t); }
  // furos de fechadura: entrada larga (passa a cabeça de 6 mm) + rasgo estreito (prende no pino de 3,5 mm)
  for (s=[-1,1]) {
    translate([s*(slot_w/2+rail+5), 0, -1]) cylinder(d=6.6, h=t+2);                 // onde a cabeça passa
    hull() { translate([s*(slot_w/2+rail+5), 0, -1]) cylinder(d=3.9, h=t+2); translate([s*(slot_w/2+rail+5), -4, -1]) cylinder(d=3.9, h=t+2); } // desliza pra travar
  }
}
