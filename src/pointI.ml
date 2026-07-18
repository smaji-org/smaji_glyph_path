(*
 * pointI.ml
 * -----------
 * Copyright : (c) 2025 - 2026, smaji.org
 * Copyright : (c) 2025 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


type cell = int
type t= {
  x: cell;
  y: cell;
}

let abs t= {
  x= abs(t.x);
  y= abs(t.y);
}

let zero= {
  x= 0;
  y= 0;
}

module Ops = struct
  let ( *> ) f p= { x= f * p.x; y= f * p.y }
  let ( /> ) f p= { x= f / p.x; y= f / p.y }
  let ( *< ) = Fun.flip ( *> )
  let ( /< ) p f= { x= p.x / f; y= p.y / f}

  let ( + ) p1 p2= { x= p1.x+p2.x; y= p1.y+p2.y }
  let ( - ) p1 p2= { x= p1.x-p2.x; y= p1.y-p2.y }
  let ( * ) p1 p2= { x= p1.x*p2.x; y= p1.y*p2.y }
  let ( / ) p1 p2= { x= p1.x/p2.x; y= p1.y/p2.y }
end

let to_tuple p= (p.x,p.y)
let of_tuple (x,y)= {x;y}
let to_string p= Printf.sprintf "(%d,%d)" p.x p.y

let neg p= { x= (- p.x); y= (- p.y) }

let distance ?(from={x=0;y=0}) (p2:t)=
  let open Ops in
  let difference= (p2 - from) in
  let x= difference.x
  and y= difference.y in
  let open Stdlib in
  x * x + y * y |> Float.of_int |> Float.sqrt

let perimeter points=
  let rec perimeter fst acc prev points=
    match points with
    | []->
      let acc= acc +. distance ~from:prev fst in
      acc
    | point::tl->
      let acc= acc +. distance ~from:point prev in
      perimeter fst acc point tl
  in
  match points with
  | [fst;snd]-> distance ~from:fst snd
  | fst::snd::thd::tl-> perimeter fst 0. fst (snd::thd::tl)
  | _-> 0.
