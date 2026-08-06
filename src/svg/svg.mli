(*
 * svg.mli
 * -----------
 * Copyright : (c) 2023 - 2026, smaji.org
 * Copyright : (c) 2023 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)

module ViewBox = ViewBox
(** Module ViewBox *)

module Svg_path = Svg_path
(** Module Svg_path *)

type t = { viewBox : ViewBox.t; paths : Svg_path.t list; }
(** The type of svg, consists of viewBox and paths *)

val to_svg_string : ?close:bool -> ?indent:int -> t -> string
(** Return the svg-formatted plain text
  - [close] is default to true, so a "Z" command is appended to make the path closed
  - [indent] is default to zero. An [indent] spaces prefixed svg representation is returned.
  *)

val set_viewBox : ViewBox.t -> t -> t
(** [set_viewBox viewBox svg] return a new svg with its viewBox element changed to [viewBox] *)

module Adjust : sig
  val viewBox_reset : t -> t
  (** [viewBox_reset svg] translate(move) the entire graphics until its [min_x] and [min_y] attributes of the viewBox is the original point *)

  val viewBox_fit_frame : t -> ViewBox.t option
  (** [viewBox_fit_frame svg] recalculate the best fit viewBox frame of the content of [svg], iff [svg] contains paths *)

  val viewBox_fit_frame_reset : t -> t
  (** [viewBox_fit_frame svg] recalculate the best fit viewBox frame of the content of [svg], and then reset it *)

  val scale : x:float -> y:float -> t -> t
  (** Scale the content of the graphics by [x] and [y], viewBox is not affected *)

  val translate : dx:float -> dy:float -> t -> t
  (** Move the content of the graphics by [dx] and [dy], viewBox is not affected *)
end

val of_string : string -> t option
(** [of_string string] returns [Some t] if the string represents a legal svg glyph path file, otherwise, [None] is returned *)

val load_file : string -> t option
(** [load_file path] returns [Some t] if the [path] points to a legal svg glyph path file, otherwise, [None] is returned *)

val load_file_exn : string -> t
(** [load_file_exn path] returns [t] if the path points to a legal svg glyph path file, otherwise an exception is raised *)

