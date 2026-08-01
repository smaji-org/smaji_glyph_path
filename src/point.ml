(*
 * point.ml
 * -----------
 * Copyright : (c) 2025 - 2026, smaji.org
 * Copyright : (c) 2025 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


open! Bugfix

type cell = float
type t= {
  x: cell;
  y: cell;
}

let abs t= {
  x= abs_float(t.x);
  y= abs_float(t.y);
}

let zero= {
  x= 0.;
  y= 0.;
}

let to_tuple p=
  (p.x, p.y)
let of_tuple (x,y)= {x;y}

module Ops = struct
  let ( *> ) f p= { x= f *. p.x; y= f *. p.y }
  let ( /> ) f p= { x= f /. p.x; y= f /. p.y }
  let ( *< ) = Fun.flip ( *> )
  let ( /< ) p f= { x= p.x /. f; y= p.y /. f}

  let ( + ) p1 p2= { x= p1.x+.p2.x; y= p1.y+.p2.y }
  let ( - ) p1 p2= { x= p1.x-.p2.x; y= p1.y-.p2.y }
  let ( * ) p1 p2= { x= p1.x*.p2.x; y= p1.y*.p2.y }
  let ( / ) p1 p2= { x= p1.x/.p2.x; y= p1.y/.p2.y }
end

let to_string p= Printf.sprintf "(%s,%s)"
  (string_of_float p.x)
  (string_of_float p.y)

let neg p= { x= (-. p.x); y= (-. p.y) }

let distance ?(from={x=0.;y=0.}) (p2:t)=
  let open Ops in
  let difference= (p2 - from) in
  let x= difference.x
  and y= difference.y in
  x *. x +. y *. y |> Float.sqrt

let length points=
  let rec length fst acc prev points=
    match points with
    | []->
      let acc= acc +. distance ~from:prev fst in
      acc
    | point::tl->
      let acc= acc +. distance ~from:point prev in
      length fst acc point tl
  in
  match points with
  | [fst;snd]-> distance ~from:fst snd
  | fst::snd::thd::tl-> length fst 0. fst (snd::thd::tl)
  | _-> 0.

(*
let angle vector=
  let open Float in
  let angle=
    let c= (pow vector.x 2.) +. (pow vector.y 2.) |> sqrt in
    let rotate= vector.y /.  c |> asin in
    if vector.x >= 0. then
      if vector.y >= 0. then
        rotate
      else
        2. *. pi +. rotate
    else
      pi -. rotate
  in
  angle
*)

let radian vec=
  let length= distance vec in
  let calc v= acos (v.x /. length) in
  if vec.y >= 0. then
    calc vec
  else
    Float.pi
    +. calc {
      x= -. vec.x;
      y= -. vec.y;
    }

let rotate ~radian:_radian point=
  let angle_point= radian point in
  let angle_rotate= _radian +. angle_point in
  let open Float in
  let length= pow point.x 2. +. pow point.y 2. |> sqrt in
  let x= cos angle_rotate *. length
  and y= sin angle_rotate *. length in
  {x;y}

