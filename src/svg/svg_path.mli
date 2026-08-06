(*
 * path.mli
 * -----------
 * Copyright : (c) 2023 - 2026, smaji.org
 * Copyright : (c) 2023 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)

type point = Point.t

(** {2 Path command descriptions} *)

type cubic_desc = { ctrl1 : point; ctrl2 : point; end' : point; }
(** The type of description of cubic bézier curve command*)

type s_cubic_desc = { ctrl2 : point; end' : point; }
(** The type of description of subsequent cubic bézier curve command*)

type quadratic_desc = { ctrl : point; end' : point; }
(** The type of description of quadratic bézier curve command*)

type s_quadratic_desc = { end' : point; }
(** The type of description of subsequent cubic bézier curve command*)

(** The type of description of elliptical arc curve command*)
type arc_desc = {
  rx : float;       (** x radius of the ellipse *)
  ry : float;       (** y radius of the ellipse *)
  angle : float;    (** rotation in degrees of the ellipse relative to the x-axis *)
  large_arc : bool; (** chose one of the large arc (true) or small arc (false) *)
  sweep : bool;     (** chose one of the clockwise turning arc (true) or counterclockwise turning arc (false) *)
  end' : point;     (** the end point of the arc and also the new current point for the next command *)
}

(** Path commands *)
type command =
  | Cmd_L of point
  | Cmd_l of point
  | Cmd_H of float
  | Cmd_h of float
  | Cmd_V of float
  | Cmd_v of float
  | Cmd_C of cubic_desc
  | Cmd_c of cubic_desc
  | Cmd_S of s_cubic_desc
  | Cmd_s of s_cubic_desc
  | Cmd_Q of quadratic_desc
  | Cmd_q of quadratic_desc
  | Cmd_T of s_quadratic_desc
  | Cmd_t of s_quadratic_desc
  | Cmd_A of arc_desc
  | Cmd_a of arc_desc

type start_point = Absolute of point | Relative of point

(** {2 Point or path command adjustment } *)

val point_translate : ?dx:float -> ?dy:float -> point -> point

val point_scale : ?x:float -> ?y:float -> point -> point

val start_point_adjust_point :
  dx:float -> dy:float -> start_point -> start_point

val start_point_adjust_scale :
  x:float -> y:float -> start_point -> start_point

val command_adjust_position : dx:float -> dy:float -> command -> command

val command_adjust_scale : x:float -> y:float -> command -> command

(** {2 Convert the given point or path command to string } *)

(** For each type, there are two versions of converter: with or without [_svg] suffix respectively. The [_svg] version converts the given value to svg-formatted plain text, while the other version converts the given value to human readable verion. *)

val start_point_to_string : start_point -> string

val start_point_to_string_svg : start_point -> string

val point_to_string : point -> string

val point_to_string_svg : string * string -> string

val cubic_desc_to_string : cubic_desc -> string

val cubic_desc_to_string_svg : cubic_desc -> string

val s_cubic_desc_to_string : s_cubic_desc -> string

val s_cubic_desc_to_string_svg : s_cubic_desc -> string

val quadratic_desc_to_string : quadratic_desc -> string

val quadratic_desc_to_string_svg : quadratic_desc -> string

val arc_desc_to_string : arc_desc -> string

val arc_desc_to_string_svg : arc_desc -> string

val command_to_string : command -> string

val command_to_string_svg : command -> string

(** {2 Sub segment and path descriptions} *)

type sub = { start : start_point; segments : command list; }
(** svg sub path *)

type t = sub list
(** By svg stanard, an svg path is a collection of sub paths. *)

(** {2 Frame and frame arithemetic } *)

val sub_frame : ?prev:point -> sub -> Path.frame * point
(** Calcuate the best fit frame and the endpoint of the [sub]. *)

val frame : t -> Path.frame option
(** Calcuate the best fit frame of [Svg_path.t]. *)

val paths_frame : t list -> Path.frame option
(** Calcuate the best fit frame of [Svg_path.t list]. *)

(** {2 Adjust sub segment or path } *)
module Adjust :
  sig
    val translate_sub : dx:float -> dy:float -> sub -> sub
    (** [translate_sub ~dx ~dy sub] translates the sub path [sub] by the given difference [dx], [dy] *)

    val scale_sub : x:float -> y:float -> sub -> sub
    (** [scale_sub ~x ~y sub] scales the sub path [sub] by the given factor [x], [y] *)

    val translate : dx:float -> dy:float -> t -> t
    (** [translate ~dx ~dy path] translates the [path] by the given difference [dx], [dy] *)

    val scale : x:float -> y:float -> t -> t
    (** [scale ~x ~y path] scales the [path] by the given factor [x], [y] *)
  end

(** {2 Convert sub segment or path to string } *)

val sub_to_string_hum : sub -> string
(** [sub_to_string_hum sub] is the human readable representation of [sub] *)

val to_string_hum : t -> string
(** [to_string_hum path] is the human readable representation of [path] *)

val sub_to_string_svg :
  ?close:bool -> ?prev:point -> ?indent:int -> sub -> string
(** [sub_to_string_svg ?close ?prev ?indent sub] is the svg formatted string of [sub].
  - [close] is default to true, so a "Z" command is appended to make the path closed
  - if [prev] is given, a relative path is reallocated based on it.
  - [indent] is default to zero. An [indent] spaces prefixed string is returned.
  *)

val to_string_svg : ?close:bool -> ?indent:int -> t -> string
(** [to_string_svg ?close ?indent path] is the svg formatted string of [path].
  - [close] is default to true, so a "Z" command is appended to make the path closed
  - [indent] is default to zero. An [indent] spaces prefixed string is returned.
  *)


(** {2 Parse and return path commands } *)

module Parser :
sig
  open Utils.MiniParsec
  type command =
      Cmd_M of point list
    | Cmd_m of point list
    | Cmd_L of point list
    | Cmd_l of point list
    | Cmd_H of float list
    | Cmd_h of float list
    | Cmd_V of float list
    | Cmd_v of float list
    | Cmd_C of cubic_desc list
    | Cmd_c of cubic_desc list
    | Cmd_S of s_cubic_desc list
    | Cmd_s of s_cubic_desc list
    | Cmd_Q of quadratic_desc list
    | Cmd_q of quadratic_desc list
    | Cmd_T of point list
    | Cmd_t of point list
    | Cmd_A of arc_desc list
    | Cmd_a of arc_desc list
    | Cmd_Z
    | Cmd_z
  val string_of_cl : char list -> string
  val float1 : float parser
  val float2 : (float * float) parser
  val float4 : (float * float * float * float) parser
  val float6 : (float * float * float * float * float * float) parser
  val point : point parser
  val tag_M : char parser
  val tag_m : char parser
  val tag_L : char parser
  val tag_l : char parser
  val tag_H : char parser
  val tag_h : char parser
  val tag_V : char parser
  val tag_v : char parser
  val tag_C : char parser
  val tag_c : char parser
  val tag_S : char parser
  val tag_s : char parser
  val tag_Q : char parser
  val tag_q : char parser
  val tag_T : char parser
  val tag_t : char parser
  val tag_A : char parser
  val tag_a : char parser
  val tag_Z : char parser
  val tag_z : char parser
  val arc_desc : arc_desc parser
  val cmd_M : command parser
  val cmd_m : command parser
  val cmd_L : command parser
  val cmd_l : command parser
  val cmd_H : command parser
  val cmd_h : command parser
  val cmd_V : command parser
  val cmd_v : command parser
  val cmd_C : command parser
  val cmd_c : command parser
  val cmd_S : command parser
  val cmd_s : command parser
  val cmd_Q : command parser
  val cmd_q : command parser
  val cmd_T : command parser
  val cmd_t : command parser
  val cmd_A : command parser
  val cmd_a : command parser
  val cmd_Z : command parser
  val cmd_z : command parser
  val path : command list parser
end

val of_string : string -> t option
(** Parse the d attribute and return the path *)

val sub_of_path : Path.t -> sub
(** Convert [Path.t] to [sub] command. Note, [Svg_path.t] can not be converted to Path.t directly, since [Svg_path.t] is a list of sub paths. *)

val sub_to_path : ?prev:point -> sub -> Path.t
(** Convert [sub] command to [Path.t]. this function will straighten elliptical arc since its not used in glyph path so it is not supported. *)

