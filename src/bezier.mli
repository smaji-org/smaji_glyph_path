(*
 * bezier.mli
 * -----------
 * Copyright : (c) 2025, smaji.org
 * Copyright : (c) 2025, ZAN DoYe <zandoye@gmail.com>
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

(*
val draw2 :
  ?s:int ->
  point ->
  point ->
  point ->
  (Point.cell * Point.cell) list

val draw_quadratic :
  ?s:int ->
  point ->
  point ->
  point ->
  (Point.cell * Point.cell) list

val draw3 :
  ?s:int ->
  point ->
  point ->
  point ->
  point ->
  (Point.cell * Point.cell) list

val draw_cubic :
  ?s:int ->
  point ->
  point ->
  point ->
  point ->
  (Point.cell * Point.cell) list
*)

(* val best_fit : (Float.t * Float.t) array -> point * point *)
