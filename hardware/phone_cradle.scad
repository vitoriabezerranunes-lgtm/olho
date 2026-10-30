include <params.scad>
// BERÇO DO CELULAR v3 — trilho esquerdo fixo, trilho DIREITO AJUSTÁVEL (peça phone_rail), corneta acústica.
// Parafusa nos 6 furos da frente da caixa. Celular entra por cima; a borda de baixo entra na bolsa acústica.
// Ajuste: encosta o trilho móvel no celular e aperta 2 parafusos M3 (atarraxam direto no plástico).
// Imprime DEITADO: chapa de trás no prato. Sem suporte.
ph_t = 9;             // espessura do celular com case (mm)  <-- AJUSTE se precisar (folga de 0,8)
w_min = 70; w_max = 88;   // faixa de largura aceita
rail_h = 130; lip = 4; lip_top = 100; back_t = 2.5; rail = 4;
slot_t = ph_t + 0.8;
y_front = back_t + slot_t;
horn_depth = 26; horn_h_in = 12; horn_h_out = 30; pocket_h = 12;
x_left = -w_max/2 - rail;          // face externa do trilho fixo (esquerda)
x_right_plate = w_max/2 + rail + 22; // chapa vai além, pra receber o trilho móvel
plate_w = x_right_plate - x_left;
$fn = 48;
module body() {
  translate([x_left, 0, 0]) cube([plate_w, back_t, rail_h]);                               // chapa de trás
  translate([x_left, 0, 0]) cube([rail, y_front+3, rail_h]);                                 // trilho fixo (esq.)
  hull() { translate([x_left+rail, y_front, 0]) cube([lip, 3, lip_top]); translate([x_left+rail-0.01, y_front-lip, 0]) cube([0.01, lip+3, lip_top]); } // aba esq.
  translate([x_left, 0, 0]) cube([plate_w, y_front+3, pocket_h]);                            // bolsa acústica (largura toda)
  hull() {                                                                                    // corneta
    translate([x_left, y_front+3-0.01, 0]) cube([plate_w, 0.01, horn_h_in]);
    translate([x_left-4, y_front+3+horn_depth, 0]) cube([plate_w+8, 0.01, horn_h_out]);
  }
  // orelha esquerda com pino pra frente (trava)
  for (z=[45,90]) { translate([x_left-6, 0, z-5]) cube([6, y_front+3, 10]); translate([x_left-3, y_front+3, z]) rotate([-90,0,0]) { cylinder(d=3.5,h=6,$fn=24); translate([0,0,6]) cylinder(d1=6,d2=4,h=2.5,$fn=24); } }
}
module cavities() {
  translate([x_left+rail, back_t, pocket_h-6]) cube([plate_w-rail, slot_t, rail_h+10]);        // vão do celular (até a borda direita: o trilho móvel fecha)
  translate([x_left+rail+2, back_t, 2]) cube([plate_w-rail-4, slot_t, pocket_h]);              // câmara acústica
  hull() { translate([x_left+rail+2, y_front+2.9, 2]) cube([plate_w-rail-4, 0.01, horn_h_in-4]); translate([x_left-2, y_front+3+horn_depth+0.01, 2]) cube([plate_w+4, 0.01, horn_h_out-4]); }
  for (x=[-40,0,40], z=[20,55]) translate([x, -1, z+90]) rotate([-90,0,0]) cylinder(d=3.4, h=back_t+2);   // furos M3 da caixa (berço 90 mm mais baixo)
  translate([-8, y_front-slot_t-1, -1]) cube([16, slot_t+5, 6]);                                  // passagem da porta USB
  // furos onde o trilho móvel parafusa (M3 atarraxa no plástico): 2 colunas x 2 alturas, pra duas faixas de ajuste
  for (x=[w_min/2+rail+6, w_min/2+rail+16], z=[35,100]) translate([x, -1, z]) rotate([-90,0,0]) cylinder(d=2.6, h=back_t+2);
}
difference() { body(); cavities(); }
