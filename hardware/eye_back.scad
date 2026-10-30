include <params.scad>
// OLHO IMPRESSO — METADE DE TRÁS: casca oca, topo plano SÓLIDO (3 mm) com 2 rasgos pra prender
// na placa vertical do pan-tilt. Imprime com o corte (equador) pra baixo, sem suporte.
D = 100; t = 1.6; cut = D/2 - 8;   // diâmetro, parede, altura do corte do polo (topo plano ≈ 54 mm; rasgos cabem)
cap = 3;                            // espessura do topo sólido
lip_h = 4; lip_r = D/2 - t - 0.6;   // aba que entra na metade da frente (raio 47,8: folga radial ≥ 0,4 mm)
band = 2;                           // faixa de transição aba→parede (chanfro externo a 45°)
$fn = 120;
difference() {
  union() {
    intersection() { sphere(d=D); translate([-D,-D,band]) cube([2*D,2*D,cut-band]); }      // casca de z=2 até o topo
    // aba + faixa: perfil (r,z). Base chanfrada, sobe reto até z=0, abre a 45° até a parede em z=2.
    rotate_extrude() polygon([[lip_r-1.2,-lip_h],[lip_r-0.6,-lip_h],[lip_r,-lip_h+0.6],[lip_r,0],[D/2,band],[lip_r-1.2,band]]);
  }
  intersection() { sphere(d=D-2*t); translate([-D,-D,band-0.01]) cube([2*D,2*D,cut-cap-band+0.01]); }  // oco de z=2 até 3 mm abaixo do topo
  for (x=[-14.5, 14.5]) hull() { translate([x-5.5,0,cut-10]) cylinder(d=3.4,h=20); translate([x+5.5,0,cut-10]) cylinder(d=3.4,h=20); } // rasgos (fendas de 23 a 35 mm)
}
