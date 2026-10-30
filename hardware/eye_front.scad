include <params.scad>
// OLHO IMPRESSO — METADE DA FRENTE: casca oca com rebaixo de 1 mm pra íris (disco de 42 mm).
// Imprime com o corte pra baixo (cúpula pra cima).
D = 100; t = 1.6; iris_d = 42;
$fn = 120;
difference() {
  intersection() { sphere(d=D); translate([-D,-D,0]) cube([2*D,2*D,D]); }
  sphere(d=D-2*t);
  // rebaixo da íris no polo: cilindro raso
  translate([0,0,D/2-1]) cylinder(d=iris_d, h=3);
}
