include <params.scad>
// OLHO IMPRESSO — METADE DA FRENTE: casca oca com rebaixo de 1 mm pra íris (disco de 42 mm).
// Imprime com o corte pra baixo (cúpula pra cima).
D = 100; t = 1.6; iris_d = 41.8;   // rebaixo: serve pro cabochão de vidro de 40 mm (cola preenche) e pro iris.stl de 41,6
$fn = 120;
difference() {
  intersection() { sphere(d=D); translate([-D,-D,0]) cube([2*D,2*D,D]); }
  sphere(d=D-2*t);
  // rebaixo no polo: 2,2 mm de fundo pra papel (0,2) + borda do cabochão
  translate([0,0,D/2-2.2]) cylinder(d=iris_d, h=4);
}
