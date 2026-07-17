(*
 * matrix.mli
 * -----------
 * Copyright : (c) 2025, smaji.org
 * Copyright : (c) 2025, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


type column = { r1 : Point.cell; r2 : Point.cell }
type t = { c1 : column; c2 : column }

val apply : t -> Point.t -> Point.t
val ( * ) : t -> t -> t
val clockwise : radian:float -> t
val anticlock : radian:float -> t
val clockwise_90 : t
val anticlock_90 : t
val clockwise_180 : t
val anticlock_180 : t

