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

type progress = float
(**
  The progress of the curve.
  It's a value that ranges from 0 to 1 inclusively. *)

(** One-degree, a.k.a. linear curve. *)
val lerp1 :
  point -> point ->
  progress ->
  point

(** Two-degree, a.k.a. quadratic curve. *)
val lerp2 :
  point -> point -> point ->
  progress ->
  point

(** Three-degree, a.k.a. cubic curve. *)
val lerp3 :
  point -> point -> point -> point ->
  progress ->
  point

(** Any-degree curve. *)
val lerp :
  point list ->
  progress ->
  point

(** [plot2 ?s p0 p1 p2] plot an two-degree, a.k.a. quadratic curve, the total steps [?s] is default to the length of the path described by p0 p1 p2. *)
val plot2 :
  ?s:int ->
  point -> point -> point ->
  point list

(** Alias of plot2 *)
val plot_quadratic :
  ?s:int ->
  point -> point -> point ->
  point list

(** [plot3 ?s p0 p1 p2 p3] plot an three-degree, a.k.a. cubic curve, the total steps [?s] is default to the length of the path described by p0 p1 p2 p3 *)
val plot3 :
  ?s:int ->
  point -> point -> point -> point ->
  point list

(** Alias of plot3 *)
val plot_cubic :
  ?s:int ->
  point -> point -> point -> point ->
  point list

val plot :
  ?s:int ->
  point list ->
  point list
(** [plot ?s points] plot an any-degree curve described by [points], the total steps [?s] is default to the length of the path described by [points] *)

val best_fit_frame : point list -> point * point
(** [best_fit_frame points] is the best fit rectangle frame of the content described by [points] *)
