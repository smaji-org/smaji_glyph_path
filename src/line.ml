(*
 * line.ml
 * -----------
 * Copyright : (c) 2025 - 2026, smaji.org
 * Copyright : (c) 2025 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


open! Bugfix

type point= Point.t

type yox= { slope: float; y: float  }
type xoy= { slope: float; x: float  }
type t=
  | YoX of yox
  | XoY of xoy

let to_yox (xy:xoy)=
  let yx_slope= 1. /. xy.slope in
  let y= -. xy.x *. yx_slope in
  {slope=yx_slope; y}

let to_xoy (yx:yox)=
  let xy_slope= 1. /. yx.slope in
  let x= -. yx.y *. xy_slope in
  {slope=xy_slope; x}

let to_string= function
  | YoX {slope;y}->
    Printf.sprintf "YX {slope: %f; y: %f}" slope y
  | XoY {slope;x}->
    Printf.sprintf "XY {slope: %f; x: %f}" slope x

let of_slope_yox slope point=
  let open Point in
  let p= point in
  let y= p.y -. (p.x *. slope) in
  YoX {slope;y}

let of_slope_xoy slope point=
  let open Point in
  let p= point in
  let x= p.x -. (p.y *. slope) in
  XoY {slope;x}

let of_slope ~x ~y point=
  let open Float in
  if x = 0. && y = 0. then invalid_arg "slope '0/0' is invalid" else
  if y = 0. then
    of_slope_yox (y/.x) point
  else if x = 0. then
    of_slope_xoy (x/.y) point
  else if abs(y/.x) <= 1. then
    of_slope_yox (y/.x) point
  else
    of_slope_xoy (x/.y) point

let of_vec_point ~(vec:point) point=
  of_slope ~x:vec.x ~y:vec.y point

let of_points a b=
  let open Point in
  let open Ops in
  if a = b then invalid_arg "the two points are the same" else
  let vec= b - a in
  if Float.abs(vec.y /. vec.x) <= 1. then
    let slope= vec.y /. vec.x in
    let y= b.y -. (b.x *. slope) in
    YoX {slope;y}
  else
    let slope= vec.x /. vec.y in
    let x= b.x -. (b.y *. slope) in
    XoY {slope;x}

type intersection=
  | Point of point
  | Line of t
  | None

let get_intersection_point= function
  | Point point-> point
  | Line _ | None-> invalid_arg "parallel lines"

let rec intersection_of_lines l1 l2=
  if l1 = l2 then Line l1 else
  match l1, l2 with
  | YoX {slope=s1;y=i1}, YoX {slope=s2;y=i2}->
    if s1 = s2 then
      None
    else
      let x= (i2 -. i1) /. (s1 -. s2) in
      let y= x *. s1 +. i1 in
      Point {x; y}
  | XoY {slope=s1;x=i1}, XoY {slope=s2;x=i2}->
    if s1 = s2 then
      None
    else
      let y= (i2 -. i1) /. (s1 -. s2) in
      let x= y *. s1 +. i1 in
      Point {x; y}
  | YoX yx, XoY xy->
    if yx.slope = 0. && xy.slope = 0. then
      Point {x=xy.x;y=yx.y}
    else if Float.abs(yx.slope) < Float.abs(xy.slope) then
      intersection_of_lines l1 (YoX(to_yox xy))
    else
      intersection_of_lines (XoY(to_xoy yx)) l2
  | XoY xy, YoX yx->
    if xy.slope = 0. && yx.slope = 0. then
      Point {x=xy.x;y=yx.y}
    else if Float.abs(xy.slope) < Float.abs(yx.slope) then
      intersection_of_lines l1 (XoY(to_xoy yx))
    else
      intersection_of_lines (YoX(to_yox xy)) l2

let vector_len (vec:Point.t)=
  Float.sqrt(vec.x *. vec.x +. vec.y *. vec.y)

let extended_vec (vec:Point.t) len=
  let vec_len= vector_len vec in
  let x= len *. (vec.x /. vec_len)
  and y= len *. (vec.y /. vec_len) in
  Point.{ x;y }

let extended_angle ~radian length=
  let x= cos radian *. length
  and y= sin radian *. length in
  Point.{ x;y }

let unit_vector (vec:point)=
  if vec.x = 0. && vec.y = 0. then invalid_arg "zero vector is invalid" else
  let len = vector_len vec in
  Point.{ x= vec.x /. len; y= vec.y /. len }

let vector_sum= Point.(List.fold_left Ops.(+) zero)

let vector_mean l=
  let open Point in
  let (count, sum)= List.fold_left
    (fun (c, acc) vec->
      (c+.1., Point.Ops.(+) acc vec))
    (0., Point.zero) l
  in
  { x= sum.x /. count; y= sum.y /. count }
