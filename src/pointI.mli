(*
 * pointI.mli
 * -----------
 * Copyright : (c) 2025, smaji.org
 * Copyright : (c) 2025, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


type cell = int
type t = { x : cell; y : cell }

val abs : t -> t
val distance : ?from:t -> t -> float
val perimeter : t list -> float
val zero : t
val to_tuple : t -> cell * cell
val of_tuple : cell * cell -> t
val to_string : t -> string
val neg : t -> t

module Ops : sig
  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t
  val ( * ) : t -> t -> t
  val ( / ) : t -> t -> t
  val ( *> ) : cell -> t -> t
  val ( /> ) : cell -> t -> t
  val ( *< ) : t -> cell -> t
  val ( /< ) : t -> cell -> t
end
