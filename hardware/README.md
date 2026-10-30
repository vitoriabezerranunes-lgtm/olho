# Peças impressas da Lanterna do Olho

**Versões decoradas (ARGUS · VIDEO ERGO SUM):** sóbria `body_argus.stl` + `lid_argus.stl`; gótica (lancetas, quadrifólios, pináculos, contrafortes, soco) `body_argus_gothic.stl` + `lid_argus_gothic.stl`; clássica/barroca (rosetas, louros, acanto, dentículos, óvulos, pilastras) `body_argus_classic.stl` + `lid_argus_classic.stl`. Qualquer uma substituem `body.stl` e `lid.stl` (mesmas medidas, com relevos de 0,7 mm e gravações de 0,6 mm). Fonte: `deco.scad`. Depois de impressa em preto: pincel seco com acrílica dourada nos relevos e letras.

**Imprima primeiro `test_coupon.stl` (~12 min)**: placa com os rasgos da tampa (parafusa o pan-tilt), disco da base do olho (parafusa na placa vertical) e pedaço do canal do celular (desliza o celular). Se os três encaixarem, o resto está certo.

Desenhadas em OpenSCAD (`*.scad`), exportadas em `*.stl`. Bambu, PLA, 0,2 mm, 3 paredes, 15 % infill, sem suporte.

| Peça | Arquivo | Como imprimir | Tempo (Bambu) |
|---|---|---|---|
| Corpo da caixa (com alças) | body.stl | em pé, boca pra cima, como está, sem suporte | ~3,3 h |
| (o berço do celular fica 9 cm abaixo da caixa: o celular pendura na frente, com o topo na altura da tampa) | | | |
| Tampa | lid.stl | gravação "OLHO" pra cima | ~40 min |
| Suporte do olho | eye_mount.stl | disco no prato, pinos pra cima | ~15 min |
| Berço do celular | phone_cradle.stl | chapa de trás no prato (deitado); espessura do celular em `ph_t` (9 mm) | ~30 min |
| Trilho móvel do berço | phone_rail.stl | deitado (linguetas no prato); encosta no celular e trava com 2 parafusos M3 | ~10 min |

Medidas a conferir antes de imprimir: `dowel_d` (cabo) em params.scad; `pt_x`/`pt_y` (furos da base do pan-tilt) em lid.scad; `ph_w`/`ph_t` (celular com case) em phone_cradle.scad.

## Olho impresso (alternativa ao isopor)

| Peça | Arquivo | Como imprimir | Tempo (Bambu) |
|---|---|---|---|
| Olho, metade de trás (com base pra o pan-tilt) | eye_back.stl | corte pra baixo, cúpula pra cima, sem suporte | ~1,5 h |
| Olho, metade da frente (rebaixo da íris) | eye_front.stl | corte pra baixo, cúpula pra cima, sem suporte | ~1,5 h |
| Íris | iris.stl | deitada; cor escura (azul/verde) se tiver | ~8 min |

Com o olho impresso, `eye_mount.stl` não é necessário: a metade de trás já tem a base plana com rasgos pra prender direto na plataforma do pan-tilt.

| Trava do celular (×2) | phone_clip.stl | deitada; imprime 2; furo direito alongado acompanha o trilho móvel | ~5 min |


Parafusos: 6× M3×8 (berço na caixa, com porca ou atarraxando no pad), 2× M3×8 (trilho móvel), 2 ou 4× M3×10 com porca (pan-tilt na tampa). Tudo da gaveta da CEID.
