// Lanterna do Olho — parâmetros comuns (mm)
L = 150;      // comprimento externo (x)
W = 100;      // largura externa (y)
H = 80;       // altura externa (z)
wall = 2.0;   // parede
floor_t = 2.4;
rc = 5;       // raio dos cantos
dowel_d = 20.6;   // furo do cabo (dowel de 20 mm + folga). Cabo de vassoura: mede e troca.
socket_h = 35;    // altura do soquete do cabo dentro da caixa
lid_lip = 1.6;    // aba interna da tampa
lid_t = 3;
$fn = 64;
module rbox(l, w, h, r) { hull() for (x=[-1,1], y=[-1,1]) translate([x*(l/2-r), y*(w/2-r), 0]) cylinder(r=r, h=h); }
