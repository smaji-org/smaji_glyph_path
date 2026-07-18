(*
 * bezier.mli
 * -----------
 * Copyright : (c) 2025 - 2026, smaji.org
 * Copyright : (c) 2025 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


type point = Point.t

val lerp : point -> point -> Point.cell -> point

val lerp2 :
  point -> point -> point -> Point.cell -> point

val lerp3 :
  point ->
  point ->
  point ->
  point ->
  Point.cell ->
  point

val plot2 :
  ?s:int ->
  point ->
  point ->
  point ->
  point list

val plot_quadratic :
  ?s:int ->
  point ->
  point ->
  point ->
  point list

val plot3 :
  ?s:int ->
  point ->
  point ->
  point ->
  point ->
  point list

val plot_cubic :
  ?s:int ->
  point ->
  point ->
  point ->
  point ->
  point list

val best_fit_frame : point list -> point * point
