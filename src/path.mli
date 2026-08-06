(*
 * outline.mli
 * -----------
 * Copyright : (c) 2023 - 2026, smaji.org
 * Copyright : (c) 2023 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_outline.
 *)

type point= Point.t

(** The type of 2d segment *)
type segment =
  | Line of point
    (** Line segment from previous point to point *)
  | Qcurve of { ctrl : point; end' : point; }
    (** Quadratic Bézier Curve consists of previous point, ctrl and end' *)
  | Ccurve of { ctrl1 : point; ctrl2 : point; end' : point; }
    (** Cubic Bézier Curve consists of previous point, ctrl1, ctrl2 and end' *)
  | SQcurve of point
    (** Quadratic Bézier Curve consists of previous end', previous reflection of ctrl and point *)
  | SCcurve of { ctrl : point; end' : point; }
    (** Cubic Bézier Curve consists of previous end', previous reflection of ctrl2, ctrl and end' *)

val segment_end : segment -> point

type t = { start : point; segments : segment list; }
(** The type of glyph path *)

val get_end : t -> point
(** [get_end t] returns the endpoit of the path [t] *)

type frame = {
  x: Point.cell; y: Point.cell;
  width: Point.cell; height: Point.cell;
}

val frame_update : point -> frame -> frame
(** [frame_update point frame] is a minimum frame contains both [point] and [frame] *)

val frame_merge : frame -> frame -> frame
(** [frame_merge frame1 frame2] is a minimum frame contains both [frame1] and [frame2] *)

val frame_to_string : frame -> string
(** [to_string frame] is the written representation of [frame] *)

val path_to_string : ?indent:int -> t -> string
(** [path_to_string ?indent path] is the written representation of [path] with [indent] spaces prefixed. [indent] is default to zero. *)

val end_of_segments : t -> point option
(** Return the endpoint of the segments of the path, None is returned if the path has no segments. *)

val is_closed : t -> bool
(** Determine whether the path is closed i.e. an outline path *)

val is_open : t -> bool
(** Determine whether the path is open i.e. a stroke path *)

val segment_frame : point -> segment -> frame
(** Calcuate the best fit frame from the given start point and segment *)

val frame : t -> frame * point
(** Calcuate the best fit frame and the endpoint of the path *)

val frame_dummy : frame

val frame_algo_svg : t -> frame * point
(** Calcuate the best fit frame and the endpoint of the path by the algorithm used in SVG image processing *)

val segment_map :
  op:('a -> point -> point) -> param:'a -> segment -> segment
  (**
    [segment_map ~op ~param segment] applies the function `op param` to each point within the segment.
    The function `op` transforms the parameter and a point into a new point.
    The result is a new segment with all points replaced by the transformed points.
   *)

val segment_translate : d:Point.t -> segment -> segment
  (** Return the value of [segment_map ~op:Point.(+) ~param:d segment] *)

val segment_scale : r:Point.t -> segment -> segment
  (** Return the value of [segment_map ~op:Point.( * ) ~param:r segment] *)

val translate : d:Point.t -> t -> t
  (** [translate ~r path] translates the path [t] by the given difference [d] *)

val scale : r:Point.t -> t -> t
  (** [scale ~r path] scales the path [t] by the given factor [r] *)

val fit_frame : ?algo:(t -> frame * point) -> target:frame -> t list -> t list
  (** Scale and translate the paths so that the whole of them as a combined shape will fit the [target] frame.
  Available algorithms are:
  - {!frame}
  - {!frame_algo_svg}
  - custom algorithm
  *)

