// DECORAÇÃO "ARGUS" — relevos e gravações aplicados sobre as peças base.
include <params.scad>
use <body.scad>
use <lid.scad>
PAINT = 0;            // 0 = como impresso (tudo preto); 1 = pintado (dourado nos relevos/gravações)
PART = 0;             // 0 = montado (render), 1 = só corpo (STL), 2 = só tampa (STL)
STYLE = 1;            // 0 = sóbrio (molduras + olhos soltos), 1 = gótico (lancetas, quadrifólios, pináculos, contrafortes)
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


// ---------- vocabulário gótico ----------
module quatrefoil2d(r=2.6){ for(a=[0:90:270]) rotate(a) translate([r*0.62,0]) circle(r=r*0.62,$fn=32); square(r*0.9,center=true); }
module quatrefoil_band(len, pitch=9, r=2.6){ for (i=[0:floor(len/pitch)-1]) translate([-len/2 + pitch/2 + i*pitch, 0]) difference(){ quatrefoil2d(r); quatrefoil2d(r*0.55); } }
// arco ogival (lanceta) como moldura: largura w, altura h (até a ponta), espessura da moldura b
module lancet2d(w=14, h=26, b=1.1){
  R = w*0.75;  // raio dos arcos que formam a ogiva
  module solid(){ union(){ translate([-w/2, 0]) square([w, h - w*0.6]); intersection(){ translate([-w/2 + R, h - w*0.6]) circle(r=R,$fn=64); translate([ w/2 - R, h - w*0.6]) circle(r=R,$fn=64); translate([-w/2,0]) square([w,h+5]); } } }
  difference(){ solid(); offset(delta=-b) solid(); }
}
module arcade(width, z0=8, w=14, h=26, pitch=17){
  n = floor(width/pitch);
  x0 = -(n-1)*pitch/2;   // centraliza a arcada na parede
  for (i=[0:n-1]) translate([x0 + i*pitch, 0, z0]) rotate([90,0,0]) linear_extrude(rel) lancet2d(w,h);
  for (i=[0:n-1]) translate([x0 + i*pitch, 0, z0 + h*0.45]) rotate([90,0,0]) closed_eye(w*0.56, 1.9);
}
module pinnacle(h=9, b=5){ translate([0,0,0]) { cylinder(d1=b*1.4, d2=b, h=1.2, $fn=4); translate([0,0,1.2]) cylinder(d1=b, d2=0.8, h=h, $fn=4); } }
module buttress(hgt){ // perfil escalonado nas arestas verticais
  for (k=[0:2]) translate([-0.6 - k*0.5, -0.6 - k*0.5, 0]) cube([1.2 + k, 1.2 + k, hgt*(1 - k*0.28)]);
}
module plinth(l, w, hh=5, out=0.9){ difference(){ translate([0,0,hh/2]) cube([l+2*out, w+2*out, hh], center=true); translate([0,0,hh/2]) cube([l-1, w-1, hh+2], center=true); } }
module trefoil_crown(r=22, n=14){ for (i=[0:n-1]) rotate([0,0,i*360/n]) translate([r,0,0]) difference(){ circle(r=2.4,$fn=24); circle(r=1.4,$fn=24); } }

module body_deco() {
  C(0) body_base();
  if (STYLE==0) {
    for (s=[-1,1]) translate([s*(L/2+rel/2), 0, 0]) rotate([0,0,s>0?90:-90]) {
      C(1) eyes_panel(88, 52, 15);
      C(1) translate([0, -rel/2, 40]) rotate([90,0,0]) linear_extrude(rel) frame2d(92, 72);
    }
    C(1) translate([0, W/2+rel/2, 40]) rotate([90,0,0]) linear_extrude(rel) frame2d(140, 72);
    for (s=[-1,1]) C(1) translate([s*62, -W/2-3-rel/2, 40]) rotate([90,0,0]) linear_extrude(rel) frame2d(14, 72);
    for (sx=[-1,1], sy=[-1,1]) C(1) translate([sx*(L/2-rc), sy*(W/2-rc), 0]) rotate([0,0,atan2(sy,sx)]) translate([rc-0.2,0,0]) cylinder(d=1.2, h=H, $fn=12);
  } else {
    // laterais: arcada de lancetas com um olho fechado em cada nicho (abaixo das alças)
    for (s=[-1,1]) translate([s*(L/2+rel/2), 0, 0]) rotate([0,0,s>0?90:-90]) {
      C(1) translate([0,-rel/2,0]) arcade(90, 7, 13, 26, 17);
      C(1) translate([0, -rel/2, H-8]) rotate([90,0,0]) linear_extrude(rel) quatrefoil_band(92, 9, 2.4); // friso de quadrifólios no alto
    }
    // traseira: arcada + friso
    C(1) translate([0, W/2+rel/2, 0]) rotate([0,0,180]) translate([0,-rel/2,0]) arcade(132, 7, 13, 26, 17);
    C(1) translate([0, W/2+rel/2-rel/2, H-8]) rotate([90,0,0]) linear_extrude(rel) quatrefoil_band(140, 9, 2.4);
    // frente: friso no alto (visível acima do berço) e duas lancetas nas margens
    C(1) translate([0, -W/2-3-rel/2+rel/2, H-8]) rotate([-90,0,0]) linear_extrude(rel) quatrefoil_band(140, 9, 2.4);
    for (s=[-1,1]) C(1) translate([s*62, -W/2-3-rel/2, 10]) rotate([0,0,180]) translate([0,-rel/2,0]) rotate([90,0,0]) linear_extrude(rel) lancet2d(13, 40);
    // contrafortes nas 4 arestas
    for (sx=[-1,1], sy=[-1,1]) C(1) translate([sx*(L/2-rc), sy*(W/2-rc), 0]) rotate([0,0,atan2(sy,sx)+45]) translate([rc-0.4,0,0]) rotate([0,0,-45]) buttress(H-2);
    // soco (base moldurada)
    C(1) translate([0,0,0]) plinth(L, W, 5, 0.9);
  }
  // volutas nas pontas das alças (anéis pequenos)
  if (STYLE==0) for (s=[-1,1], y=[-35+6.5, 35-6.5]) C(1) translate([s*(L/2+26+6.5), y, H-16-6.5]) rotate([0,90,0]) difference(){ cylinder(d=15,h=4,center=true,$fn=40); cylinder(d=9,h=6,center=true,$fn=40); }
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
  if (STYLE==1) {
    C(1) translate([0,18,lid_t]) linear_extrude(rel) trefoil_crown(22.5, 14);
    for (sx=[-1,1], sy=[-1,1]) C(1) translate([sx*(L/2-9), sy*(W/2-9), lid_t]) pinnacle(9, 5);
  }
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
