include <params.scad>
// CORPO v2: caixa aberta em cima, DUAS ALÇAS laterais (paredes menores, x = ±L/2),
// pad liso na frente pra parafusar o berço do celular. Sem bastão.
// Imprime em pé, boca pra cima, sem suporte: as alças têm reforço a 45° por baixo.
hb = 13;        // espessura da barra da alça
hoff = 26;      // distância da barra até a parede (espaço pros dedos)
hlen = 70;      // comprimento da barra (ao longo de y)
hz = H - 16;    // altura do topo da barra
module handle(side) {
  // barra
  translate([side*(L/2 + hoff + hb/2), 0, hz - hb/2]) rotate([90,0,0]) hull() { for (y=[-hlen/2+hb/2, hlen/2-hb/2]) translate([0,0,y]) cylinder(d=hb, h=0.01, center=true); }
  // ponte superior entre parede e barra, nas duas pontas
  for (y=[-hlen/2+hb/2, hlen/2-hb/2]) translate([side*(L/2 + (hoff+hb)/2), y, hz - hb/2]) cube([hoff+hb, hb, hb], center=true);
  // reforço a 45° por baixo de cada ponte (pra imprimir sem suporte)
  for (y=[-hlen/2+hb/2, hlen/2-hb/2]) hull() {
    translate([side*(L/2+0.01), y, hz - hb - (hoff+hb)]) cube([0.02, hb, 0.02], center=true);
    translate([side*(L/2 + (hoff+hb)/2), y, hz - hb]) cube([hoff+hb, hb, 0.02], center=true);
  }
}
module body_base() {
difference() {
  union() {
    rbox(L, W, H, rc);
    translate([-L/2+10, -W/2-3, 0]) cube([L-20, 3, H]);   // pad frontal 3 mm
    handle(1); handle(-1);
  }
  translate([0,0,floor_t]) rbox(L-2*wall, W-2*wall, H, rc-wall);           // cavidade
  // (recorte traseiro removido: power bank sem botão; carga pelo furo da frente. A traseira recebe a decoração.)
  for (x=[-40,0,40], z=[20,55]) translate([x, -W/2-4, z]) rotate([-90,0,0]) cylinder(d=3.2, h=10); // furos M3 do berço
  for (s=[-1,1]) translate([s*(L/2-12), 0, -1]) cylinder(d=6, h=floor_t+2);  // 2 furos no fundo pra fita/alça de pescoço
  translate([-6, -W/2-4, floor_t+4]) cube([12, wall+6, 9]);                   // passagem do cabo de carga do celular (frente, embaixo)
}
for (y=[-20, 20]) translate([-30, y-1, floor_t]) cube([60, 2, 2]);   // nervuras no fundo (protoboard não escorrega)
}
body_base();
