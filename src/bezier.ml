(*
 * bezier.ml
 * -----------
 * Copyright : (c) 2025 - 2026, smaji.org
 * Copyright : (c) 2025 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)

open! Bugfix

type point = Point.t

let lerp1 p0 p1 s=
  if s < 0. || s > 1. then invalid_arg "step is invalid";
  let open Point.Ops in
  s *> p1 + (1. -. s) *> p0

let lerp2 p0 p1 p2 s=
  let p3= lerp1 p0 p1 s
  and p4= lerp1 p1 p2 s in
  lerp1 p3 p4 s

let lerp3 p0 p1 p2 p3 s=
  let p4= lerp1 p0 p1 s
  and p5= lerp1 p1 p2 s
  and p6= lerp1 p2 p3 s in
  lerp2 p4 p5 p6 s

let lerp list s=
  let rec extract_points list=
    match list with
    | [] | [_]-> []
    | p0::p1::tl->
      lerp1 p0 p1 s :: extract_points (p1::tl)
  in
  let rec lerp_n list=
    match list with
    | [] | [_]-> invalid_arg "the length of the list must be >= 2"
    | p0::p1::[]-> lerp1 p0 p1 s
    | _-> lerp_n (extract_points list)
  in
  lerp_n list

let plot2 ?s p0 p1 p2=
  let s=
    match s with
    | Some s-> s
    | None-> [p0; p1; p2] |> Point.length |> Int.of_float
  in
  List.init (s+1)
    (fun step->
      lerp2 p0 p1 p2
      ((float_of_int step) /. (float_of_int s)))

let plot_quadratic= plot2

let plot3 ?s p0 p1 p2 p3=
  let s=
    match s with
    | Some s-> s
    | None-> [p0; p1; p2; p3] |> Point.length |> Int.of_float
  in  List.init (s+1)
    (fun step->
      lerp3 p0 p1 p2 p3
      ((float_of_int step) /. (float_of_int s)))

let plot ?s points=
  let s=
    match s with
    | Some s-> s
    | None-> points |> Point.length |> Int.of_float
  in  List.init (s+1)
    (fun step->
      lerp points
      ((float_of_int step) /. (float_of_int s)))

let plot_cubic= plot3

let best_fit_frame plots= List.fold_left
  (fun ((p_min, p_max): point * point) (p:point)->
    let min_x= Float.min p_min.x p.x
    and min_y= Float.min p_min.y p.y
    and max_x= Float.max p_max.x p.x
    and max_y= Float.max p_max.y p.y in
    let min= Point.{x= min_x; y= min_y}
    and max= Point.{x= max_x; y= max_y} in
    (min, max)
  )
  Point.(
    {x= Float.infinity; y= Float.infinity},
    {x= Float.neg_infinity; y= Float.neg_infinity}
  )
  plots
