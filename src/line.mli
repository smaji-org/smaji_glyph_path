(*
 * line.mli
 * -----------
 * Copyright : (c) 2025 - 2026, smaji.org
 * Copyright : (c) 2025 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


type yox= { slope: float; y: float  }
(** [slope] is y over x and point {x=0; y} is the intersection point of this line and y-axis. *)

type xoy= { slope: float; x: float  }
(** [slope] is x over y and point {x; y=0} is the intersection point of this line and x-axis. *)

(** Type [t] is either [yox] or [xoy] *)
type t=
  | YoX of yox
  | XoY of xoy

val to_string : t -> string

type point = Point.t

val of_vec_point : vec:point -> point -> t
(** [of_vec_point ~vec point] is a line of which the slope is vec and it also passes through [point] *)

val of_points : point -> point -> t
(** [of_points p1 p2] is a line which passes through both [p1] and [p2] *)

val of_slope : x:float -> y:float -> point -> t
(** [of_slope ~x ~y point] is a line which passes through [point] and its slope is either [y over x] or [x or y] *)

type intersection = Point of point | Line of t | None
(** Intersection of two lines *)

val get_intersection_point : intersection -> point
(** Return the intersection point iff the two lines are not parallel. *)

val intersection_of_lines : t -> t -> intersection
(** Intersection of the two lines. *)

val extended_vec : point -> float -> point
(** [extended_vec vec length] is a vector whose slope is the same as [vec] and its length is [length] *)

val extended_angle : radian:float -> float -> point
(** [extended_angle ~radian length] is a vector whose slope is the same as [radian] and its length is [length] *)

val unit_vector : point -> point
(** [unit_vector vec] is a vector whose slope is the same as [vec] and its length is [1] *)

val vector_len : point -> float
(** [vector_len vec] is the length of [vec] *)

val vector_sum : point list -> point
(** [vector_sum vec_list] is the sum of all the vectors in [vec_list] *)

val vector_mean : point list -> point
(** [vector_mean vec_list] is the mean of all the vectors in [vec_list] *)
