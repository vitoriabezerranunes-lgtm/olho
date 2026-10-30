include <params.scad>
// BERÇO DO CELULAR: encaixa no pad frontal. Celular entra por cima e apoia no fundo.
// AJUSTE AS MEDIDAS DO SEU CELULAR (com case):
ph_w = 76;    // largura
ph_t = 10;    // espessura com case
ph_h = 160;   // altura (só pra desenhar a janela da câmera)
cam_from_top = 15;  // centro da lente, do topo
cam_from_side = 15; // centro da lente, da lateral esquerda (olhando a traseira)
lip = 5;      // quanto a aba segura a frente do celular
rail_h = 120; // altura dos trilhos
back_t = 2.5; // chapa de trás (encosta no pad da caixa)
difference() {
  union() {
    // chapa de trás
    translate([-(ph_w+2*4)/2, 0, 0]) cube([ph_w+8, back_t, rail_h]);
    // trilhos laterais em L
    for (s=[-1,1]) translate([s*(ph_w/2+2) - 2, 0, 0]) cube([4, back_t+ph_t+1+3, rail_h]);
    for (s=[-1,1]) translate([s>0 ? ph_w/2-lip : -ph_w/2-2, back_t+ph_t+1, 0]) cube([lip+2, 3, rail_h]);
    // batente inferior
    translate([-(ph_w+8)/2, 0, 0]) cube([ph_w+8, back_t+ph_t+1+3, 4]);
  }
  // furos M3 pra parafusar no pad da caixa (coincidem com a grade do corpo: x = -40,0,40 ; z = 20,55)
  for (x=[-40,0,40], z=[20,55]) translate([x, -1, z]) rotate([-90,0,0]) cylinder(d=3.4, h=back_t+2);
  // janela pra não tapar o alto-falante/porta de baixo
  translate([-15, -1, -1]) cube([30, back_t+2, 5]);
}
