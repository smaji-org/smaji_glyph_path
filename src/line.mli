(*
 * line.mli
 * -----------
 * Copyright : (c) 2025 - 2026, smaji.org
 * Copyright : (c) 2025 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


type yx= { slope: float; y: float  }
type xy= { slope: float; x: float  }
type t=
  | YX of yx
  | XY of xy

val to_string : t -> string

type point = Point.t

val of_vec_point : vec:point -> point -> t
val of_points : point -> point -> t
val of_slope : x:float -> y:float -> point -> t

type intersection = Point of point | Line of t | None

val get_intersection_point : intersection -> point
val intersection_of_lines : t -> t -> intersection

val orth : float -> float
val extended_slope : slope:float -> float -> point
val vec_len : point -> float
val extended_vec : vec:point -> float -> point
val extended_angle : angle:float -> float -> point
val point_of_length : slope:float -> float -> point
val unit_vector_slope : slope:float -> point
val unit_vector : point -> point
val vector_sum : point list -> point
val vector_mean : point list -> point
