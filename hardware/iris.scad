// ÍRIS: disco de 41,6 mm x 1 mm com pupila vazada de 15 mm. Imprime em cor escura (azul/verde)
// e cola no rebaixo da frente; o vazio da pupila mostra o fundo branco: pinta de preto ou cola um disco preto.
$fn = 120;
difference() { cylinder(d=41.6, h=1); translate([0,0,-1]) cylinder(d=15, h=3); }
// raios finos da íris (textura), 0,4 mm de relevo
for (a=[0:15:359]) rotate([0,0,a]) translate([9,-0.4,1]) cube([11, 0.8, 0.4]);
