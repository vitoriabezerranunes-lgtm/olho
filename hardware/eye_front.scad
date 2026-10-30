include <params.scad>
// OLHO IMPRESSO — METADE DA FRENTE: casca oca, polo cortado plano com topo sólido e rebaixo
// de 2,2 mm pra íris (cabochão de vidro de 40 mm ou iris.stl). Imprime com o corte (equador) pra baixo, sem suporte.
D = 100; t = 1.6; iris_d = 41.8;
cut = 44;            // altura do corte do polo: topo plano de ~47 mm, borda de 2,6 mm em volta do rebaixo
cap = 4;             // topo sólido (o rebaixo tira 2,2; sobram 1,8 mm de fundo)
$fn = 120;
difference() {
  intersection() { sphere(d=D); translate([-D,-D,0]) cube([2*D,2*D,cut]); }
  intersection() { sphere(d=D-2*t); translate([-D,-D,-1]) cube([2*D,2*D,cut-cap+1]); }
  translate([0,0,cut-2.2]) cylinder(d=iris_d, h=4);          // rebaixo da íris
  translate([0,0,-1]) cylinder(d=6, h=D);                      // furinho central: sai ar/cola, e passa um fio se quiser LED
}
