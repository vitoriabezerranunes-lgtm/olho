# Peças impressas da Lanterna do Olho

Desenhadas em OpenSCAD (`*.scad`), exportadas em `*.stl`. Bambu, PLA, 0,2 mm, 3 paredes, 15 % infill, sem suporte.

| Peça | Arquivo | Como imprimir | Tempo (Bambu) |
|---|---|---|---|
| Corpo da caixa | body.stl | em pé, boca pra cima, como está | ~3 h |
| Tampa | lid.stl | gravação "OLHO" pra cima | ~40 min |
| Suporte do olho | eye_mount.stl | disco no prato, pinos pra cima | ~15 min |
| Berço do celular | phone_cradle.stl | chapa de trás no prato (deitado); **ajuste as medidas em phone_cradle.scad antes** | ~25 min |

Medidas a conferir antes de imprimir: `dowel_d` (cabo) em params.scad; `pt_x`/`pt_y` (furos da base do pan-tilt) em lid.scad; `ph_w`/`ph_t` (celular com case) em phone_cradle.scad.
