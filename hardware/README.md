# Peças impressas da Lanterna do Olho

Desenhadas em OpenSCAD (`*.scad`), exportadas em `*.stl`. Bambu, PLA, 0,2 mm, 3 paredes, 15 % infill, sem suporte.

| Peça | Arquivo | Como imprimir | Tempo (Bambu) |
|---|---|---|---|
| Corpo da caixa (com alças) | body.stl | em pé, boca pra cima, como está, sem suporte | ~3,3 h |
| (o berço do celular fica 9 cm abaixo da caixa: o celular pendura na frente, com o topo na altura da tampa) | | | |
| Tampa | lid.stl | gravação "OLHO" pra cima | ~40 min |
| Suporte do olho | eye_mount.stl | disco no prato, pinos pra cima | ~15 min |
| Berço do celular | phone_cradle.stl | chapa de trás no prato (deitado); **ajuste as medidas em phone_cradle.scad antes** | ~25 min |

Medidas a conferir antes de imprimir: `dowel_d` (cabo) em params.scad; `pt_x`/`pt_y` (furos da base do pan-tilt) em lid.scad; `ph_w`/`ph_t` (celular com case) em phone_cradle.scad.

## Olho impresso (alternativa ao isopor)

| Peça | Arquivo | Como imprimir | Tempo (Bambu) |
|---|---|---|---|
| Olho, metade de trás (com base pra o pan-tilt) | eye_back.stl | corte pra baixo, cúpula pra cima, sem suporte | ~1,5 h |
| Olho, metade da frente (rebaixo da íris) | eye_front.stl | corte pra baixo, cúpula pra cima, sem suporte | ~1,5 h |
| Íris | iris.stl | deitada; cor escura (azul/verde) se tiver | ~8 min |

Com o olho impresso, `eye_mount.stl` não é necessário: a metade de trás já tem a base plana com rasgos pra prender direto na plataforma do pan-tilt.

| Trava do celular (×2) | phone_clip.stl | deitada; imprime 2 | ~5 min |
