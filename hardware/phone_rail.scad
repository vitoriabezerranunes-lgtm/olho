// TRILHO MÓVEL DO BERÇO (direita): L com aba, duas linguetas com rasgos pra 2 parafusos M3 que atarraxam na chapa do berço.
// Desliza até encostar no celular; aperta. Imprime deitado (lingueta no prato). Faixa de ajuste: 10 mm por coluna de furos.
ph_t = 9; slot_t = ph_t + 0.8; back_t = 2.5; y_front = back_t + slot_t;
rail_h = 130; lip = 4; lip_top = 100; rail = 4; tab = 2.2;
$fn = 36;
difference() {
  union() {
    translate([0, back_t, 0]) cube([rail, y_front+3-back_t, rail_h]);                            // parede do trilho (apoia na chapa)
    hull() { translate([-lip, y_front, 0]) cube([lip, 3, lip_top]); translate([0, y_front-lip, 0]) cube([0.01, lip+3, lip_top]); } // aba que segura a frente do celular
    for (z=[35,100]) translate([rail, back_t, z-7]) cube([22, tab, 14]);                         // linguetas pra fora, encostadas na chapa
    for (z=[45,90]) { translate([rail, back_t, z-5]) cube([6, y_front+3-back_t, 10]); translate([rail+3, y_front+3, z]) rotate([-90,0,0]) { cylinder(d=3.5,h=6,$fn=24); translate([0,0,6]) cylinder(d1=6,d2=4,h=2.5,$fn=24); } } // orelha + pino da trava
  }
  for (z=[35,100]) hull() { translate([rail+5, back_t-1, z]) rotate([-90,0,0]) cylinder(d=3.4, h=tab+2); translate([rail+17, back_t-1, z]) rotate([-90,0,0]) cylinder(d=3.4, h=tab+2); } // rasgos
}
