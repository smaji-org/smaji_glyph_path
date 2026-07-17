(*
 * point.mli
 * -----------
 * Copyright : (c) 2025, smaji.org
 * Copyright : (c) 2025, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


module PointI : sig
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
end

module PointF : sig
  type cell = float
  type t = { x : cell; y : cell }

  val abs : t -> t
  val distance : ?from:t -> t -> float
  val perimeter : t list -> float
  val angle : t -> cell
  val rotate : angle:cell -> t -> t
  val zero : t
  val to_pointi : t -> PointI.t
  val of_pointi : PointI.t -> t
  val to_tuple : t -> cell * cell
  val of_tuple : cell * cell -> t
  val to_string : t -> string
  val neg : t -> t
  val radian : t -> cell

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
end

module Matrix : sig
  type column = { r1 : PointF.cell; r2 : PointF.cell }
  type t = { c1 : column; c2 : column }

  val apply : t -> PointF.t -> PointF.t
  val ( * ) : t -> t -> t
  val clockwise : radian:float -> t
  val anticlock : radian:float -> t
  val clockwise_90 : t
  val anticlock_90 : t
  val clockwise_180 : t
  val anticlock_180 : t
end

module Line : sig
  module Point = PointF

  type yx= { slope: float; y: float  }
  type xy= { slope: float; x: float  }
  type t=
    | YX of yx
    | XY of xy

  val to_string : t -> string

  type point = Point.t

  val of_vec_point : vec:Point.t -> Point.t -> t
  val of_points : Point.t -> Point.t -> t
  val of_slope : x:float -> y:float -> point -> t

  type intersection = Point of point | Line of t | None

  val get_intersection_point : intersection -> point
  val intersection_of_lines : t -> t -> intersection

  val orth : float -> float
  val extended_slope : slope:float -> float -> Point.t
  val vec_len : Point.t -> float
  val extended_vec : vec:Point.t -> float -> Point.t
  val extended_angle : angle:float -> float -> Point.t
  val point_of_length : slope:float -> float -> Point.t
  val unit_vector_slope : slope:float -> Point.t
  val unit_vector : Point.t -> Point.t
  val vector_sum : PointF.t list -> Point.t
  val vector_mean : PointF.t list -> Point.t
end
