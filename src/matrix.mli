(*
 * matrix.mli
 * -----------
 * Copyright : (c) 2025 - 2026, smaji.org
 * Copyright : (c) 2025 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


(** This is not a generic module. This module contains only some auxiliary functions to help handling some two-dimensiona vectors *)

type column = { r1 : Point.cell; r2 : Point.cell }

type t = { c1 : column; c2 : column }
(** The type for matrix values. *)

val apply : t -> Point.t -> Point.t
(** Apply the matrix to the vector. *)

val ( * ) : t -> t -> t
(** Matrix multiplication *)

val clockwise : radian:float -> t
(** [clockwise ~radian] is a matrix, which will rotate a vector clockwisely ~radian angle *)

val anticlock : radian:float -> t
(** [anticlock ~radian] is a matrix, which will rotate a vector anticlockly ~radian angle *)

val clockwise_90 : t
val anticlock_90 : t
val clockwise_180 : t
val anticlock_180 : t

