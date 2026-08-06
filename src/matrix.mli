(*
 * matrix.mli
 * -----------
 * Copyright : (c) 2025 - 2026, smaji.org
 * Copyright : (c) 2025 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


(** This is not a generic module. This module only contains some auxiliary functions to help handling some two-dimensiona vectors *)

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

val clockwise_d : degree:float -> t
(** [clockwise_d degree] is a matrix, which will rotate a vector clockwisely [degree] angle *)

val anticlock_d : degree:float -> t
(** [anticlock_d degree] is a matrix, which will rotate a vector anticlockly [degree] angle *)

val clockwise_90 : t
(** Return [clockwise_d ~degree:90.0] *)

val anticlock_90 : t
(** Return [anticlock_d ~degree:90.0] *)

val clockwise_180 : t
(** Return [clockwise_d ~degree:180.0] *)

val anticlock_180 : t
(** Return [anticlock_d ~degree:180.0] *)

