(*
 * point.ml
 * -----------
 * Copyright : (c) 2025, smaji.org
 * Copyright : (c) 2025, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)


open Utils

module PointI = struct
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

end

module PointF = struct
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

  let to_pointi p=
    let x= int_of_float p.x
    and y= int_of_float p.y in
    PointI.{ x; y }

  let of_pointi (p:PointI.t)=
    let x= float_of_int p.x
    and y= float_of_int p.y in
    { x; y }

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

  let rotate ~angle:_angle point=
    let angle_point= angle point in
    let angle_rotate= _angle +. angle_point in
    let open Float in
    let length= pow point.x 2. +. pow point.y 2. |> sqrt in
    let x= cos angle_rotate *. length
    and y= sin angle_rotate *. length in
    {x;y}

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
end

module Matrix = struct
  open PointF

  type column= { r1: PointF.cell; r2: PointF.cell }
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
end

module Line = struct
  module Point = PointF
  type point= Point.t

  type yx= { slope: float; y: float  }
  type xy= { slope: float; x: float  }
  type t=
    | YX of yx
    | XY of xy

  let to_yx (xy:xy)=
    let yx_slope= 1. /. xy.slope in
    let y= -. xy.x *. yx_slope in
    {slope=yx_slope; y}

  let to_xy (yx:yx)=
    let xy_slope= 1. /. yx.slope in
    let x= -. yx.y *. xy_slope in
    {slope=xy_slope; x}

  let to_string= function
    | YX {slope;y}->
      Printf.sprintf "YX {slope: %f; y: %f}" slope y
    | XY {slope;x}->
      Printf.sprintf "XY {slope: %f; x: %f}" slope x

  let of_slope_yx slope point=
    let open Point in
    let p= point in
    let y= p.y -. (p.x *. slope) in
    YX {slope;y}

  let of_slope_xy slope point=
    let open Point in
    let p= point in
    let x= p.x -. (p.y *. slope) in
    XY {slope;x}

  let of_slope ~x ~y point=
    let open Float in
    if x = 0. && y = 0. then invalid_arg "slope '0/0' is invalid" else
    if y = 0. then
      of_slope_yx (y/.x) point
    else if x = 0. then
      of_slope_xy (x/.y) point
    else if abs(y/.x) <= 1. then
      of_slope_yx (y/.x) point
    else
      of_slope_xy (x/.y) point

  let of_vec_point ~(vec:point) point=
    of_slope ~x:vec.x ~y:vec.y point

  let of_points a b=
    let open PointF in
    let open Ops in
    if a = b then invalid_arg "the two points are the same" else
    let vec= b - a in
    if Float.abs(vec.y /. vec.x) <= 1. then
      let slope= vec.y /. vec.x in
      let y= b.y -. (b.x *. slope) in
      YX {slope;y}
    else
      let slope= vec.x /. vec.y in
      let x= b.x -. (b.y *. slope) in
      XY {slope;x}

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
    | YX {slope=s1;y=i1}, YX {slope=s2;y=i2}->
      if s1 = s2 then
        None
      else
        let x= (i2 -. i1) /. (s1 -. s2) in
        let y= x *. s1 +. i1 in
        Point {x; y}
    | XY {slope=s1;x=i1}, XY {slope=s2;x=i2}->
      if s1 = s2 then
        None
      else
        let y= (i2 -. i1) /. (s1 -. s2) in
        let x= y *. s1 +. i1 in
        Point {x; y}
    | YX yx, XY xy->
      if yx.slope = 0. && xy.slope = 0. then
        Point {x=xy.x;y=yx.y}
      else if Float.abs(yx.slope) < Float.abs(xy.slope) then
        intersection_of_lines l1 (YX(to_yx xy))
      else
        intersection_of_lines (XY(to_xy yx)) l2
    | XY xy, YX yx->
      if xy.slope = 0. && yx.slope = 0. then
        Point {x=xy.x;y=yx.y}
      else if Float.abs(xy.slope) < Float.abs(yx.slope) then
        intersection_of_lines l1 (XY(to_xy yx))
      else
        intersection_of_lines (YX(to_yx xy)) l2

  let orth slope= -1. /. slope

  let extended_slope ~slope length=
    let open Float in
    let x= pow (length *. length /. (1. +. slope*.slope)) 0.5 in
    let x= if length < 0. then -.x else x in
    let y= x *. slope in
    Point.{ x; y }

  let vec_len (vec:Point.t)=
    Float.sqrt(vec.x *. vec.x +. vec.y *. vec.y)

  let extended_vec ~(vec:Point.t) length=
    let vec_len= vec_len vec in
    let x= length *. (vec.x /. vec_len)
    and y= length *. (vec.y /. vec_len) in
    Point.{ x;y }

  let extended_angle ~angle length=
    let x= cos angle *. length
    and y= sin angle *. length in
    Point.{ x;y }

  let point_of_length ~slope length=
    let open Float in
    let x= sqrt ((pow length 2.) /. (1. +. pow slope 2.)) in
    let x=
      if length < 0. then -.x else x
    in
    let y= x *. slope in
    Point.{ x; y }

  let unit_vector_slope ~slope= point_of_length ~slope 1.
  let unit_vector (vec:Point.t)=
    let slope= vec.y /. vec.x in
    let length= if vec.x < 0. then -1. else 1. in
    point_of_length ~slope length

  let vector_sum= Point.(List.fold_left Ops.(+) zero)
  let vector_mean l=
    let open Point in
    let (count, sum)= List.fold_left
      (fun (c, acc) vec->
        (c+.1., Point.Ops.(+) acc vec))
      (0., Point.zero) l
    in
    { x= sum.x /. count; y= sum.y /. count }
end

