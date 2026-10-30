include <params.scad>
// OLHO IMPRESSO — METADE DE TRÁS: casca oca, base plana com 2 rasgos pra prender
// na plataforma do pan-tilt (parafuso ou abraçadeira). Imprime com o corte pra baixo.
D = 100; t = 1.6; flat = 32;   // diâmetro, parede, diâmetro da base plana
$fn = 120;
difference() {
  intersection() {
    sphere(d=D);
    translate([-D, -D, 0]) cube([2*D, 2*D, D]);            // só a metade de cima (z>0) = traseira
    translate([-D, -D, -1]) cube([2*D, 2*D, D/2 - 8 + 1]); // corta o polo: fica uma base plana
  }
  sphere(d=D-2*t);                                          // oca
  for (x=[-11, 11]) hull() { translate([x-4,0,D/2-20]) cylinder(d=3.4,h=30); translate([x+4,0,D/2-20]) cylinder(d=3.4,h=30); }
}
// disco interno de reforço na base plana (onde os parafusos pegam)
translate([0,0,D/2-8-3]) difference() { cylinder(d=flat, h=3); for (x=[-11,11]) hull(){ translate([x-4,0,-1]) cylinder(d=3.4,h=5); translate([x+4,0,-1]) cylinder(d=3.4,h=5);} }
// aba de encaixe (entra na metade da frente)
translate([0,0,-4]) difference() { cylinder(d=D-2*t-0.4, h=4.01); translate([0,0,-1]) cylinder(d=D-2*t-0.4-2*1.2, h=7); }
