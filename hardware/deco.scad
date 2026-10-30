// DECORAÇÃO "ARGUS" — relevos e gravações aplicados sobre as peças base.
include <params.scad>
use <body.scad>
use <lid.scad>
PAINT = 0;            // 0 = como impresso (tudo preto); 1 = pintado (dourado nos relevos/gravações)
PART = 0;             // 0 = montado (render), 1 = só corpo (STL), 2 = só tampa (STL)
STYLE = 3;            // 0 = sóbrio, 1 = gótico, 2 = clássico (rosetas), 3 = louros (coroas com olhos, festões floridos, dentículos, pilastras)
NAME = "ARGUS";
MOTTO = "VIDEO ERGO SUM";
FONT = "Liberation Serif:style=Bold";
rel = 1.0;            // altura total dos relevos (0,3 embutidos na parede + 0,7 visíveis)
emb = 0.3;            // quanto cada relevo entra na parede (evita peças flutuando no STL)
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


// ---------- vocabulário clássico / barroco ----------
module rosette2d(r=5, n=8){ for(a=[0:360/n:359]) rotate(a) translate([r*0.55,0]) scale([1,0.42]) circle(r=r*0.5,$fn=24); circle(r=r*0.28,$fn=24); difference(){ circle(r=r*0.22,$fn=24); circle(r=r*0.12,$fn=16);} }
module rosette_grid(width, height, pitch=14, r=4.6){ nx=floor(width/pitch); nz=floor(height/pitch); for(i=[0:nx-1], j=[0:nz-1]) translate([-(nx-1)*pitch/2 + i*pitch, 0, 8 + j*pitch + pitch/2]) rotate([90,0,0]) linear_extrude(rel) rosette2d(r); }
module dentils(len, pitch=6, w=3, h=4){ for (i=[0:floor(len/pitch)-1]) translate([-len/2 + pitch/2 + i*pitch - w/2, 0, 0]) cube([w, 1.0, h]); }
module egg_dart(len, pitch=7){ for (i=[0:floor(len/pitch)-1]) translate([-len/2 + pitch/2 + i*pitch, 0, 0]) { rotate([90,0,0]) linear_extrude(rel) difference(){ scale([1,1.35]) circle(r=2.1,$fn=24); scale([1,1.35]) circle(r=1.3,$fn=24);} translate([pitch/2,0,-2.6]) rotate([90,0,0]) linear_extrude(rel) square([0.9,5.2],center=true); } }
module leaf2d(l=7, w=2.6){ scale([l/2, w/2]) circle(r=1,$fn=24); }
module laurel(r=23, n=16){ for (i=[0:n-1]) rotate([0,0,i*360/n]) translate([r+0.8,0,0]) rotate([0,0,62]) linear_extrude(rel) leaf2d(6.8,2.0); for (i=[0:n-1]) rotate([0,0,i*360/n+360/n/2]) translate([r-1.6,0,0]) rotate([0,0,118]) linear_extrude(rel) leaf2d(5.6,1.7); linear_extrude(rel) difference(){ circle(r=r-0.2,$fn=96); circle(r=r-1.0,$fn=96);} }
module scroll2d(turns=1.6, a=2.2, b=1.1){ // voluta (espiral de Arquimedes) como faixa
  pts=[for (t=[0:6:turns*360]) let(rr=a+b*t/360*2) [rr*cos(t), rr*sin(t)]];
  for (i=[0:len(pts)-2]) hull(){ translate(pts[i]) circle(r=0.7,$fn=10); translate(pts[i+1]) circle(r=0.7,$fn=10); }
  translate(pts[len(pts)-1]) circle(r=1.1,$fn=12);
}
module acanthus_corner(){ linear_extrude(rel) { scroll2d(); rotate(180) translate([-7,0]) scale(0.7) scroll2d(); } }
module pilaster(hgt){ translate([-3,-rel,0]) cube([6, rel, hgt-9]); translate([-4,-rel,hgt-9]) cube([8, rel+0.3, 3]); translate([-3.5,-rel,hgt-6]) cube([7, rel+0.6, 1.5]); }
module medallion(){ rotate([90,0,0]) linear_extrude(rel) { difference(){ scale([1,1.4]) circle(r=6,$fn=48); scale([1,1.4]) circle(r=5,$fn=48);} rosette2d(4,8); } }


// ---------- louros floridos ----------
module berry_pair(){ for (s=[-1,1]) translate([0,s*1.1]) circle(r=0.75,$fn=12); }
module flower5(r=1.7){ for(a=[0:72:359]) rotate(a) translate([r*0.55,0]) circle(r=r*0.5,$fn=12); circle(r=r*0.35,$fn=12); }
// guirlanda ao longo de um arco de circunferência (centro na origem), de ângulo a0 a a1, raio r; folhas tangentes ao arco
module garland_arc(r, a0, a1, n=14, leaf_l=6.2, leaf_w=2.0){
  for (i=[0:n-1]) { a = a0 + (a1-a0)*i/(n-1); side = (i%2==0)?1:-1;
    rotate([0,0,a]) translate([r + side*1.3, 0]) rotate([0,0,90 + side*35]) leaf2d(leaf_l, leaf_w);
    if (i%4==2) rotate([0,0,a + (a1-a0)/(n-1)/2]) translate([r,0]) berry_pair();
    if (i%7==3) rotate([0,0,a + (a1-a0)/(n-1)/2]) translate([r - 2.2*side,0]) flower5(1.9);
  }
  // haste
  difference(){ circle(r=r+0.45,$fn=96); circle(r=r-0.45,$fn=96); rotate([0,0,a1]) translate([-200,0]) square([400,400]); rotate([0,0,a0]) translate([-200,-400]) square([400,400]); }
}
module wreath2d(r=16, n=18){ for (i=[0:n-1]) { a=i*360/n; rotate([0,0,a]) translate([r+0.7,0]) rotate([0,0,62]) leaf2d(5.6,1.8); rotate([0,0,a+360/n/2]) translate([r-1.3,0]) rotate([0,0,118]) leaf2d(4.6,1.5); if (i%3==0) rotate([0,0,a+360/n/2]) translate([r+0.2,0]) berry_pair(); if (i%6==3) rotate([0,0,a]) translate([r-2.6,0]) flower5(1.8); } difference(){ circle(r=r-0.1,$fn=96); circle(r=r-0.9,$fn=96); } }
// coroa com olho fechado no centro, numa parede vertical (plano XZ): x, z = centro
module wreath_eye(x, z, r=17){ translate([x,0,z]) rotate([90,0,0]) { linear_extrude(rel) wreath2d(r, 18); translate([0,-r*0.05,0]) closed_eye(r*0.95, r*0.32); } }
// festão: arco de guirlanda pendurado entre dois pontos (x1,x2) na altura ztop, com flecha sag
module festoon(x1, x2, ztop, sag){ c=(x1+x2)/2; half=(x2-x1)/2; R=(half*half+sag*sag)/(2*sag); zc=ztop - sag + R; ang=asin(half/R);
  translate([c,0,zc]) rotate([90,0,0]) linear_extrude(rel) garland_arc(R, 270-ang, 270+ang, max(8,floor(2*ang*R/360*6.283/5.5)));
}

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
  } else if (STYLE==2) {
    // laterais: grade de rosetas sob as alças + moldura; cornija com dentículos; óvulos na base
    for (s=[-1,1]) translate([s*(L/2+rel/2), 0, 0]) rotate([0,0,s>0?90:-90]) {
      C(1) translate([0,-rel/2,0]) rosette_grid(84, 44, 14, 4.6);
      C(1) translate([0, -rel/2, 30]) rotate([90,0,0]) linear_extrude(rel) frame2d(92, 52, 1.4);
      C(1) translate([0, -1.0, H-6]) dentils(92, 6, 3, 4);
      C(1) translate([0, -rel/2, 6]) egg_dart(90, 7);
    }
    // traseira: rosetas + moldura + dentículos + óvulos
    C(1) translate([0, W/2+rel/2, 0]) rotate([0,0,180]) translate([0,-rel/2,0]) rosette_grid(130, 60, 14, 4.6);
    C(1) translate([0, W/2+rel/2-rel/2, 40]) rotate([90,0,0]) linear_extrude(rel) frame2d(140, 72, 1.4);
    C(1) translate([0, W/2+1.0, H-6]) rotate([0,0,180]) dentils(140, 6, 3, 4);
    C(1) translate([0, W/2+rel/2, 6]) rotate([0,0,180]) translate([0,-rel/2,0]) egg_dart(138, 7);
    // frente: dentículos no alto e medalhões ovais nas margens
    C(1) translate([0, -W/2-3-1.0, H-6]) dentils(140, 6, 3, 4);
    for (s=[-1,1]) C(1) translate([s*62, -W/2-3-rel/2, 40]) rotate([0,0,180]) medallion();
    // pilastras nas arestas
    for (sx=[-1,1], sy=[-1,1]) C(1) translate([sx*(L/2-rc), sy*(W/2-rc), 0]) rotate([0,0,atan2(sy,sx)+45]) translate([rc-0.5,0,0]) rotate([0,0,90]) pilaster(H);
  } else if (STYLE==3) {
    // laterais: coroa de louro com olho sob a alça + festões dos cantos; cornija de dentículos
    for (s=[-1,1]) translate([s*(L/2+rel/2), 0, 0]) rotate([0,0,s>0?90:-90]) {
      C(1) translate([0,rel/2+emb,0]) wreath_eye(0, 27, 17);
      // ramos verticais nas bordas (fora da sombra dos reforços das alças)
      for (s2=[-1,1]) C(1) translate([s2*42, rel/2+emb, 29]) rotate([90,0,0]) linear_extrude(rel) translate([-60,0]) garland_arc(60, -20, 20, 12, 5.0, 1.7);
      C(1) translate([0, -0.5+emb, H-6]) dentils(92, 6, 3, 4);
    }
    // traseira: três coroas com olhos + festões entre elas + dentículos
    C(1) translate([0, W/2+rel/2, 0]) rotate([0,0,180]) translate([0,rel/2+emb,0]) { wreath_eye(-44, 30, 16); wreath_eye(0, 30, 16); wreath_eye(44, 30, 16); festoon(-66, -22, 62, 10); festoon(-22, 22, 62, 10); festoon(22, 66, 62, 10); }
    C(1) translate([0, W/2+1.0-emb, H-6]) rotate([0,0,180]) dentils(140, 6, 3, 4);
    // frente (só sobre o pad de 3 mm, |x|<65): dentículos e ramos verticais nas margens
    C(1) translate([0, -W/2-3-1.0+emb, H-6]) dentils(126, 6, 3, 4);
    for (s=[-1,1]) C(1) translate([s*59, -W/2-3+emb, 36]) rotate([90,0,0]) linear_extrude(rel) translate([-60,0]) garland_arc(60, -22, 22, 12, 5.2, 1.8);
    // pilastras nas arestas
    for (sx=[-1,1], sy=[-1,1]) C(1) translate([sx*(L/2-rc), sy*(W/2-rc), 0]) rotate([0,0,atan2(sy,sx)+45]) translate([rc-0.5,0,0]) rotate([0,0,90]) pilaster(H);
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
  if (STYLE!=1) for (s=[-1,1], y=[-35+6.5, 35-6.5]) C(1) translate([s*(L/2+26+6.5), y, H-16-6.5]) rotate([0,90,0]) difference(){ cylinder(d=15,h=4,center=true,$fn=40); cylinder(d=9,h=6,center=true,$fn=40); }
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
  if (STYLE==3) {
    C(1) translate([0,18,lid_t]) linear_extrude(rel) wreath2d(22.5, 20);
    for (sx=[-1,1], sy=[-1,1]) C(1) translate([sx*(L/2-13), sy*(W/2-12), lid_t]) rotate([0,0,atan2(sy,sx)+180]) acanthus_corner();
  }
  if (STYLE==2) {
    C(1) translate([0,18,lid_t]) laurel(22.5, 22);
    for (sx=[-1,1], sy=[-1,1]) C(1) translate([sx*(L/2-13), sy*(W/2-12), lid_t]) rotate([0,0,atan2(sy,sx)+180]) acanthus_corner();
  }
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
