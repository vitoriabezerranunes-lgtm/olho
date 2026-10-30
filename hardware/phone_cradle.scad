include <params.scad>
// BERÇO DO CELULAR v2 — com abas flexíveis e corneta acústica. (Segurança extra: um elástico em volta da caixa inteira.)
// Parafusa nos 6 furos da frente da caixa. Celular entra por cima; a borda de baixo entra na bolsa acústica.
// Imprime DEITADO: chapa de trás no prato (como o STL sai). Sem suporte.
ph_w = 80;   // largura do celular com case (mm)  <-- AJUSTE
ph_t = 9;    // espessura com case (mm)           <-- AJUSTE
rail_h = 130;        // altura dos trilhos (celular tem ~170; o topo fica livre)
lip = 4;             // aba frontal que segura a borda
lip_top = 100;       // abas só até essa altura (nada cobre a câmera lá em cima)
back_t = 2.5;        // chapa de trás
slot_w = ph_w + 0.6; // folga lateral
slot_t = ph_t + 0.8; // folga de espessura
rail = 4;            // espessura do trilho lateral
horn_depth = 26; horn_h_in = 12; horn_h_out = 30; pocket_h = 12;
y_front = back_t + slot_t;  // plano da frente do celular
$fn = 48;
module body() {
  // chapa de trás
  translate([-(slot_w+2*rail)/2, 0, 0]) cube([slot_w+2*rail, back_t, rail_h]);
  // trilhos laterais
  for (s=[-1,1]) translate([s*(slot_w/2+rail/2) - rail/2, 0, 0]) cube([rail, y_front+3, rail_h]);
  // abas frontais (com chanfro a 45° por baixo pra imprimir deitado)
  for (s=[-1,1]) hull() {
    translate([s>0 ? slot_w/2-lip : -slot_w/2, y_front, 0]) cube([lip, 3, lip_top]);
    translate([s>0 ? slot_w/2 : -slot_w/2-0.01, y_front-lip, 0]) cube([0.01, lip+3, lip_top]);
  }
  // bolsa acústica: caixa fechada em volta da borda de baixo do celular
  translate([-(slot_w+2*rail)/2, 0, 0]) cube([slot_w+2*rail, y_front+3, pocket_h]);
  // corneta: se abre pra frente (+y) a partir da bolsa
  hull() {
    translate([-(slot_w+2*rail)/2, y_front+3-0.01, 0]) cube([slot_w+2*rail, 0.01, horn_h_in]);
    translate([-(slot_w+2*rail)/2-4, y_front+3+horn_depth, 0]) cube([slot_w+2*rail+8, 0.01, horn_h_out]);
  }
}
module cavities() {
  // vão do celular
  translate([-slot_w/2, back_t, pocket_h-6]) cube([slot_w, slot_t, rail_h+10]);
  // câmara acústica dentro da bolsa (espaço embaixo do celular, 5 mm) e saída pra corneta
  translate([-slot_w/2+2, back_t, 2]) cube([slot_w-4, slot_t, pocket_h]);
  hull() {
    translate([-slot_w/2+2, y_front+2.9, 2]) cube([slot_w-4, 0.01, horn_h_in-4]);
    translate([-(slot_w+2*rail)/2-4+2, y_front+3+horn_depth+0.01, 2]) cube([slot_w+2*rail+8-4, 0.01, horn_h_out-4]);
  }
  // furos M3 (grade da caixa: x = -40,0,40 ; z = 20,55)
  for (x=[-40,0,40], z=[20,55]) translate([x, -1, z]) rotate([-90,0,0]) cylinder(d=3.4, h=back_t+2);
  // abertura na frente da bolsa pra porta USB (passa o cabo de carga por baixo)
  translate([-8, y_front-slot_t-1, -1]) cube([16, slot_t+5, 6]);
}
difference() { body(); cavities(); }
// pinos com cabeça do lado de fora dos trilhos: enganchar elástico de cabelo por cima do celular (z=45 e z=90, longe da câmera)
for (s=[-1,1], z=[45, 90]) translate([s*(slot_w/2+rail), y_front-2, z]) rotate([0, s*90, 0]) {
  cylinder(d=3.5, h=5, $fn=24);
  translate([0,0,5]) cylinder(d1=6, d2=4, h=2.5, $fn=24);
}
// abas flexíveis: lâminas de 0,8 mm nos trilhos, apertam as laterais do celular (1,2 mm de interferência)
for (s=[-1,1], z=[25, 60, 95]) translate([s*(slot_w/2) - (s>0?0:0.6) , back_t+1, z]) hull() {
  translate([0,0,0]) cube([0.6, 1, 10]);
  translate([s>0 ? -0.9 : 0.9, slot_t/2-0.3, 2]) cube([0.6, 0.6, 6]);
}
