(*
 * matrix.ml
 * -----------
 * Copyright : (c) 2025, smaji.org
 * Copyright : (c) 2025, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


open Point

type column= { r1: cell; r2: cell }
type t= { c1: column; c2: column }

let apply m p=
  let x= m.c1.r1 *. p.x +. m.c2.r1 *. p.y
  and y= m.c1.r2 *. p.x +. m.c2.r2 *. p.y in
  { x; y }

let ( * ) a b=
  let c1=
    let r1= a.c1.r1 *. b.c1.r1 +. a.c2.r1 *. b.c1.r2
    and r2= a.c1.r2 *. b.c1.r1 +. a.c2.r2 *. b.c1.r2 in
    { r1; r2 }
  and c2=
    let r1= a.c1.r1 *. b.c2.r1 +. a.c2.r1 *. b.c2.r2
    and r2= a.c1.r2 *. b.c2.r1 +. a.c2.r2 *. b.c2.r2 in
    { r1; r2 }
  in
  { c1; c2 }

let clockwise ~radian=
  let s= sin radian
  and c= cos radian in
  { c1= {r1= c; r2= s}; c2={r1= -.s;r2=c} }
let anticlock ~radian=
  let radian= -. radian in
  clockwise ~radian

let clockwise_90= { c1= {r1= 0.; r2= 1.}; c2= {r1= -1.;r2= 0.} }
let anticlock_90= { c1= {r1= 0.; r2= -1.}; c2= {r1= 1.;r2= 0.} }
let clockwise_180= { c1= {r1= -1.; r2= 0.}; c2= {r1= 0.;r2= -1.} }
let anticlock_180= clockwise_180
