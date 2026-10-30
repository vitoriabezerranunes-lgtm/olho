// DECORAÇÃO "ARGUS" — relevos e gravações aplicados sobre as peças base.
include <params.scad>
use <body.scad>
use <lid.scad>
PAINT = 0;            // 0 = como impresso (tudo preto); 1 = pintado (dourado nos relevos/gravações)
PART = 0;             // 0 = montado (render), 1 = só corpo (STL), 2 = só tampa (STL)
NAME = "ARGUS";
MOTTO = "VIDEO ERGO SUM";
FONT = "Liberation Serif:style=Bold";
rel = 0.7;            // altura dos relevos
eng = 0.6;            // profundidade das gravações
gold = [0.83,0.68,0.32]; blk = [0.11,0.11,0.13];
module C(isGold){ color(PAINT && isGold ? gold : blk) children(); }

// --- olho fechado: pálpebra em arco (︵) com 3 cílios curtos, em relevo baixo
module closed_eye(w=7, h=2.2) {
  linear_extrude(rel) difference(){
    intersection(){ translate([0,-h*2.2]) circle(r=h*3.2, $fn=64); translate([-w/2,-h]) square([w,h*2]); }
    translate([0,-h*2.2-0.8]) circle(r=h*3.2, $fn=64);
  }
  for (a=[-1,0,1]) translate([a*w*0.3, -h*0.35 - abs(a)*0.4, 0]) rotate([0,0,a*22]) linear_extrude(rel) square([0.5, h*0.7], center=true);
}
// padrão em uma parede vertical: desenhamos no plano XY e levantamos pra parede
module eyes_panel(width, height, spacing=14) {
  for (r=[0:floor(height/ (spacing*0.75))-1]) for (c=[0:floor(width/spacing)]) {
    x = -width/2 + c*spacing + (r%2 ? spacing/2 : 0); z = 8 + r*spacing*0.75;
    if (abs(x) < width/2 - 5 && z < height - 6) translate([x, 0, z]) rotate([90,0,0]) closed_eye();
  }
}
// moldura fina em relevo numa face (retângulo vazado), desenhada no plano XY
module frame2d(w,h,bw=1.6){ difference(){ square([w,h],center=true); square([w-2*bw,h-2*bw],center=true);} }

module body_deco() {
  C(0) body_base();
  // laterais (x = ±L/2): padrão de olhos abaixo das alças + moldura
  for (s=[-1,1]) translate([s*(L/2+rel/2), 0, 0]) rotate([0,0,s>0?90:-90]) {
    // painel de olhos: ocupa y ∈ [-44,44], z ∈ [6,52] (as alças ficam acima de 55)
    C(1) eyes_panel(88, 52, 15);
    C(1) translate([0, -rel/2, 40]) rotate([90,0,0]) linear_extrude(rel) frame2d(92, 72);
  }
  // traseira: moldura
  C(1) translate([0, W/2+rel/2, 40]) rotate([90,0,0]) linear_extrude(rel) frame2d(140, 72);
  // frente: duas molduras finas nas margens laterais do pad (fora da área do berço, que cobre o meio)
  for (s=[-1,1]) C(1) translate([s*62, -W/2-3-rel/2, 40]) rotate([90,0,0]) linear_extrude(rel) frame2d(14, 72);
  // filetes dourados nas 4 arestas verticais
  for (sx=[-1,1], sy=[-1,1]) C(1) translate([sx*(L/2-rc), sy*(W/2-rc), 0]) rotate([0,0,atan2(sy,sx)]) translate([rc-0.2,0,0]) cylinder(d=1.2, h=H, $fn=12);
  // volutas nas pontas das alças (anéis pequenos)
  for (s=[-1,1], y=[-35+6.5, 35-6.5]) C(1) translate([s*(L/2+26+6.5), y, H-16-6.5]) rotate([0,90,0]) difference(){ cylinder(d=15,h=4,center=true,$fn=40); cylinder(d=9,h=6,center=true,$fn=40); }
}
module lid_deco() {
  difference() {
    C(0) lid_base();
    // anel de texto em volta do centro do pan-tilt (y=18), raio 29: ARGUS · VIDEO ERGO SUM ·
    translate([0,18,lid_t-eng]) ring_text(str(NAME, " · ", MOTTO, " · "), 29, 5.2);
    // moldura gravada a 5 mm da borda
    translate([0,0,lid_t-eng]) linear_extrude(eng+1) frame2d(L-10, W-10, 1.0);
  }
  // versão pintada: desenha o ouro dentro das gravações
  if (PAINT) {
    color(gold) translate([0,18,lid_t-eng+0.01]) ring_text_h(str(NAME, " · ", MOTTO, " · "), 29, 5.2, eng+0.02);
    color(gold) translate([0,0,lid_t-eng+0.01]) linear_extrude(eng+0.02) frame2d(L-10, W-10, 1.0);
  }
}
module ring_text(txt, r, size) { ring_text_h(txt, r, size, eng+1); }
module ring_text_h(txt, r, size, h) {
  n = len(txt);
  for (i=[0:n-1]) rotate([0,0, 90 - i*(360/n)]) translate([0, r, 0]) rotate([0,0,-90]) linear_extrude(h) text(txt[i], size=size, font=FONT, halign="center", valign="center");
}
module all() { body_deco(); translate([0,0,H]) lid_deco(); }
if (PART==0) all(); else if (PART==1) body_deco(); else lid_deco();
