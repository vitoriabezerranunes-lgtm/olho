include <params.scad>
// SUPORTE DO OLHO: disco de 40 mm com 2 pinos pro isopor e 2 rasgos
// pra parafusar/abraçar na plataforma do pan-tilt.
difference() {
  cylinder(d=40, h=3);
  for (x=[-11, 11]) hull() { translate([x-4,0,-1]) cylinder(d=3.2,h=5); translate([x+4,0,-1]) cylinder(d=3.2,h=5); }
}
// pinos (ficam dentro do isopor)
for (y=[-10, 10]) translate([0, y, 3]) cylinder(d=3.4, h=22, $fn=24);
// cone na ponta pra entrar fácil
for (y=[-10, 10]) translate([0, y, 25]) cylinder(d1=3.4, d2=1.2, h=3, $fn=24);
