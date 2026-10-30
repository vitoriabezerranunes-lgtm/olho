include <params.scad>
// TAMPA: placa com aba interna (encaixe por atrito), 4 rasgos pro pan-tilt
// (aceita bases de 24-34 x 20-30 mm), rasgo pros fios atrás do pan-tilt,
// 2 furos pra velcro/parafuso de segurança.
pt_x = 23; pt_y = 27;   // base medida 33 x 37 mm -> furos a ~23 x 27 mm centro a centro (5 mm da borda)
tol = 3.5;              // folga em cada sentido (rasgos em cruz): aceita 23x27 ou 27x23, e erro de ate ~2 mm
module lid_base() {
difference() {
  union() {
    rbox(L, W, lid_t, rc);
    translate([0,0,-lid_lip]) rbox(L-2*wall-0.6, W-2*wall-0.6, lid_lip+0.01, rc-wall);
  }
  // rasgos do pan-tilt: tolerância de ±5 mm em cada eixo
  // pan-tilt recuado 18 mm pra trás, pra o olho não ficar em cima da câmera do celular
  for (sx=[-1,1], sy=[-1,1]) {
    hull() { translate([sx*(pt_x/2)-tol, 18 + sy*(pt_y/2), -5]) cylinder(d=3.2, h=10); translate([sx*(pt_x/2)+tol, 18 + sy*(pt_y/2), -5]) cylinder(d=3.2, h=10); }
    hull() { translate([sx*(pt_x/2), 18 + sy*(pt_y/2)-tol, -5]) cylinder(d=3.2, h=10); translate([sx*(pt_x/2), 18 + sy*(pt_y/2)+tol, -5]) cylinder(d=3.2, h=10); }
  }
  // alívio pro parafuso central da base do pan-tilt
  translate([0, 18, -5]) cylinder(d=10, h=10);
  // passagem dos fios dos servos (atrás do pan-tilt)
  translate([-8, 18 + pt_y/2+8, -5]) cube([16, 7, 10]);
  // furos de segurança nos cantos (velcro ou parafuso)
  for (x=[-L/2+10, L/2-10]) translate([x, 0, -5]) cylinder(d=3.2, h=10);
}
}
lid_base();
