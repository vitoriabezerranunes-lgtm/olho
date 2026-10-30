include <params.scad>
// PEÇA DE TESTE (12 min): confere os encaixes antes das impressões longas.
// A) placa 60x60x3 com os 4 rasgos da tampa + alívio central  -> parafusa a base do pan-tilt nela
// B) disco 38 mm igual à base do olho, com os 2 rasgos          -> parafusa na placa vertical do pan-tilt
// C) pedaço de 35 mm do canal do celular (trilho fixo + chapa)  -> desliza a lateral do celular nele
pt = 23; ph_t = 9; slot_t = ph_t + 1.2;
// A
difference() {
  translate([-30,-30,0]) cube([60,60,3]);
  for (sx=[-1,1], sy=[-1,1]) hull() { translate([sx*(pt/2-2.5), sy*(pt/2), -1]) cylinder(d=3.2,h=5); translate([sx*(pt/2+2.5), sy*(pt/2), -1]) cylinder(d=3.2,h=5); }
  translate([0,0,-1]) cylinder(d=10,h=5);
  translate([-6, pt/2+8, -1]) cube([12,7,5]);
}
// B
translate([60,0,0]) difference() { cylinder(d=38,h=3); for (x=[-14.5,14.5]) hull(){ translate([x-5.5,0,-1]) cylinder(d=3.4,h=5); translate([x+5.5,0,-1]) cylinder(d=3.4,h=5);} }
// C: chapa + trilho + aba, 35 mm de altura, deitado (como o berço imprime)
translate([-30,-75,0]) { cube([50,2.5,35]); cube([4, 2.5+slot_t+3, 35]); hull(){ translate([4,2.5+slot_t,0]) cube([4,3,35]); translate([3.99,2.5+slot_t-4,0]) cube([0.01,7,35]); } }
