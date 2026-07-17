(*
 * bezier.mli
 * -----------
 * Copyright : (c) 2025, smaji.org
 * Copyright : (c) 2025, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


module Point = Point.PointF

type point = Point.t

val lerp : Point.t -> Point.t -> Point.cell -> Point.t

val lerp2 :
  Point.t -> Point.t -> Point.t -> Point.cell -> Point.t

val lerp3 :
  Point.t ->
  Point.t ->
  Point.t ->
  Point.t ->
  Point.cell ->
  Point.t

val plot2 :
  ?s:int ->
  Point.t ->
  Point.t ->
  Point.t ->
  Point.t list

val plot_quadratic :
  ?s:int ->
  Point.t ->
  Point.t ->
  Point.t ->
  Point.t list

val plot3 :
  ?s:int ->
  Point.t ->
  Point.t ->
  Point.t ->
  Point.t ->
  Point.t list

val plot_cubic :
  ?s:int ->
  Point.t ->
  Point.t ->
  Point.t ->
  Point.t ->
  Point.t list

(*
val draw2 :
  ?s:int ->
  Point.t ->
  Point.t ->
  Point.t ->
  (Point.cell * Point.cell) list

val draw_quadratic :
  ?s:int ->
  Point.t ->
  Point.t ->
  Point.t ->
  (Point.cell * Point.cell) list

val draw3 :
  ?s:int ->
  Point.t ->
  Point.t ->
  Point.t ->
  Point.t ->
  (Point.cell * Point.cell) list

val draw_cubic :
  ?s:int ->
  Point.t ->
  Point.t ->
  Point.t ->
  Point.t ->
  (Point.cell * Point.cell) list
*)

(* val best_fit : (Float.t * Float.t) array -> point * point *)
