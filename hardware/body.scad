include <params.scad>
// CORPO: caixa aberta em cima, soquete do cabo no fundo (canto traseiro-esquerdo),
// pad liso na frente pra colar/parafusar o berço do celular.
difference() {
  union() {
    rbox(L, W, H, rc);
    // pad frontal 3 mm (face y = -W/2), pra fixação do berço do celular
    translate([-L/2+10, -W/2-3, 0]) cube([L-20, 3, H]);
  }
  // cavidade
  translate([0,0,floor_t]) rbox(L-2*wall, W-2*wall, H, rc-wall);
  // furo do cabo atravessando o fundo
  translate([-L/2+wall+16, W/2-wall-16, -1]) cylinder(d=dowel_d, h=floor_t+2);
  // recorte traseiro pra botão/cabo do power bank (40 x 14 mm, perto do fundo)
  translate([-20, W/2-wall-1, floor_t+6]) cube([40, wall+2, 14]);
  // furos de parafuso M3 no pad frontal (grade 2x3) pro berço do celular
  for (x=[-40,0,40], z=[20,55]) translate([x, -W/2-4, z]) rotate([-90,0,0]) cylinder(d=3.2, h=10);
}
// soquete do cabo (boss) com furo passante
translate([-L/2+wall+16, W/2-wall-16, 0]) difference() {
  cylinder(d=dowel_d+6, h=socket_h);
  translate([0,0,-1]) cylinder(d=dowel_d, h=socket_h+2);
}
// reforços do soquete nas paredes
translate([-L/2+wall, W/2-wall-16-(dowel_d+6)/2, 0]) cube([16, dowel_d+6, 6]);
// trilhos no fundo pra protoboard/velcro não escorregar (2 nervuras baixas)
for (y=[-20, 20]) translate([-30, y-1, floor_t]) cube([60, 2, 2]);
