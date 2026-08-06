(*
 * outline.ml
 * -----------
 * Copyright : (c) 2023 - 2026, smaji.org
 * Copyright : (c) 2023 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_outline.
 *)

open! Bugfix

type point = Point.t

type segment=
  | Line of point
  | Qcurve of { ctrl: point; end': point }
  | Ccurve of { ctrl1: point; ctrl2:point; end': point }
  | SQcurve of point
  | SCcurve of { ctrl: point; end': point }

let segment_end= function
  | Line p-> p
  | Qcurve c-> c.end'
  | Ccurve c-> c.end'
  | SQcurve p-> p
  | SCcurve c-> c.end'

type t= {
  start: point;
  segments: segment list;
}

let get_end t=
  match List.rev t.segments with
  | []-> t.start
  | last::_-> segment_end last

type frame = {
  x: Point.cell; y: Point.cell;
  width: Point.cell; height: Point.cell;
}

let frame_dummy= {
  x= Float.infinity; y= Float.infinity;
  width= Float.neg_infinity; height= Float.neg_infinity;
}

let segment_to_string  ?(indent=0) segment=
  let open Printf in
  let indent= String.make indent ' ' in
  match segment with
  | Line point-> sprintf "%sLine %s" indent (Point.to_string point)
  | Qcurve { ctrl; end' }-> sprintf "%sQcurve { ctrl: %s; end: %s; }" indent (Point.to_string ctrl) (Point.to_string end')
  | Ccurve { ctrl1; ctrl2; end' }-> sprintf "%sCcurve { ctrl1: %s; ctrl2: %s; end: %s }" indent (Point.to_string ctrl1) (Point.to_string ctrl2)(Point.to_string end')
  | SQcurve point-> sprintf "%sSQcurve %s" indent (Point.to_string point)
  | SCcurve { ctrl; end' }-> sprintf "%sSCcurve { ctrl: %s; end: %s; }" indent (Point.to_string ctrl) (Point.to_string end')


let path_to_string ?(indent=0) path=
  let indent_str= String.make indent ' ' in
  let indent_str1= String.make (indent+2) ' ' in
  let start= Printf.sprintf "start: %s" (Point.to_string path.start) in
  let segements= path.segments
    |> List.map (segment_to_string ~indent:(indent+2))
    |> String.concat "\n"
  in
  Printf.sprintf "%s{\n%s%s\n%s\n%s}" indent_str indent_str1 start segements indent_str

let end_of_segments path=
  match path.segments with
  | []-> None
  | _->
    Option.some @@ match path.segments |> List.rev |> List.hd with
    | Line point-> point
    | Qcurve { ctrl=_; end' }-> end'
    | Ccurve { ctrl1=_; ctrl2=_; end' }-> end'
    | SQcurve point-> point
    | SCcurve { ctrl=_; end' }-> end'

let is_closed path=
  match end_of_segments path with
  | Some end'-> path.start = end'
  | None-> false

let is_open= Fun.negate is_closed

let segment_map ~op ~param seg=
  let op v= op param v in
  match seg with
  | Line end'-> Line (op end')
  | Qcurve { ctrl; end' }->
    let ctrl= op ctrl
    and end'= op end' in
    Qcurve {ctrl; end'}
  | Ccurve { ctrl1; ctrl2; end' }->
    let ctrl1= op ctrl1
    and ctrl2= op ctrl2
    and end'= op end' in
    Ccurve {ctrl1; ctrl2; end'}
  | SQcurve end'-> SQcurve (op end')
  | SCcurve { ctrl; end' }->
    let ctrl= op ctrl
    and end'= op end' in
    SCcurve {ctrl; end'}

let segment_translate ~d seg=
  segment_map ~op:Point.Ops.(+) ~param:d seg

let segment_scale ~r seg=
  segment_map ~op:Point.Ops.( * ) ~param:r seg

let translate ~d t=
  let open Point.Ops in
  let start= t.start + d in
  let segments= t.segments
    |> List.map (segment_translate ~d) in
  { start; segments }

let scale ~r t=
  let open Point.Ops in
  let start= t.start * r in
  let segments= t.segments
    |> List.map (segment_scale ~r) in
  { start; segments }

let frame_update (point:point) frame=
  let x=
    if point.x = neg_infinity then
      neg_infinity
    else
      min point.x frame.x
  and y=
    if point.y = neg_infinity then
      neg_infinity
    else
      min point.y frame.y
  in
  let max_x=
    if frame.width = infinity then
      infinity
    else
      max point.x (frame.x +. frame.width)
  and max_y=
    if frame.height = infinity then
      infinity
    else
      max point.y (frame.y +. frame.height)
  in
  let width=
    if x = max_x then
      0.
    else
      max_x -. x
  and height=
    if y = max_y then
      0.
    else
      max_y -. y
  in
  { x; y; width; height }

let frame_merge f1 f2=
  let x= min f1.x f2.x
  and y= min f1.y f2.y in
  let max_x=
    if f1.width = infinity || f2.width = infinity then
      infinity
    else
      max (f1.x+.f1.width) (f2.x+.f2.width)
  and max_y=
    if f1.height = infinity || f2.height = infinity then
      infinity
    else
      max (f1.y+.f1.height) (f2.y+.f2.height) in
  let width= max_x -. x
  and height= max_y -. y in
  { x; y; width; height }

let frame_to_string frame=
  Printf.sprintf "{ x= %s; y= %s; width= %s; height= %s }"
    (string_of_float frame.x)
    (string_of_float frame.y)
    (string_of_float frame.width)
    (string_of_float frame.height)

let frame_of_points points=
  List.fold_left (Fun.flip frame_update) frame_dummy points

let segment_frame prev segment=
  let init= frame_dummy |> frame_update prev in
  match segment with
  | Line end'-> init |> frame_update end'
  | Qcurve { ctrl; end' }->
    let plots= Bezier.plot_quadratic prev ctrl end' in
    frame_of_points plots
  | Ccurve { ctrl1; ctrl2; end' }->
    let plots= Bezier.plot_cubic prev ctrl1 ctrl2 end' in
    frame_of_points plots
  | SQcurve _-> invalid_arg "SQcurve"
  | SCcurve _-> invalid_arg "SCcurve"

let frame path=
  let rec calc acc prev_ctrl prev_end segments=
    match segments with
    | []-> (acc, prev_end)
    | Line end' ::tl->
      let acc= acc |> frame_update prev_end |> frame_update end' in
      calc acc None end' tl
    | Qcurve { ctrl; end' } ::tl->
      let acc= Bezier.plot_quadratic prev_end ctrl end'
        |> frame_of_points
        |> frame_merge acc
      in
      calc acc (Some ctrl) end' tl
    | Ccurve { ctrl1; ctrl2; end' } ::tl->
      let acc= Bezier.plot_cubic prev_end ctrl1 ctrl2 end'
        |> frame_of_points
        |> frame_merge acc
      in
      calc acc (Some ctrl2) end' tl
    | SQcurve end' ::tl->
      let ctrl=
        match prev_ctrl with
        | Some prev_ctrl-> Point.Ops.(prev_end + prev_end - prev_ctrl)
        | None-> prev_end
      in
      let acc= Bezier.plot_quadratic prev_end ctrl end'
        |> frame_of_points
        |> frame_merge acc
      in
      calc acc (Some ctrl) end' tl
    | SCcurve { ctrl=ctrl2; end' } ::tl->
      let ctrl1=
        match prev_ctrl with
        | Some prev_ctrl-> Point.Ops.(prev_end + prev_end - prev_ctrl)
        | None-> prev_end
      in
      let acc= Bezier.plot_cubic prev_end ctrl1 ctrl2 end'
        |> frame_of_points
        |> frame_merge acc
      in
      calc acc (Some ctrl2) end' tl
  in
  let acc= frame_dummy
  and prev_end= path.start
  and prev_ctrl= None in
  let (frame, last)= calc acc prev_ctrl prev_end path.segments in
  let frame=
    { frame with
      width= max 1. frame.width;
      height= max 1. frame.height;
    }
  in
  (frame, last)

let frame_algo_svg path=
  let rec calc acc prev prev_ctrl prev_end segments=
    match segments with | []-> (acc, prev_end) | segment::tl->
    match segment with
    | Line end'->
      let acc= acc |> frame_update prev_end |> frame_update end' in
      calc acc segment None end' tl
    | Qcurve { ctrl; end' }->
      let acc= Bezier.plot_quadratic prev_end ctrl end'
        |> frame_of_points
        |> frame_merge acc
      in
      calc acc segment (Some ctrl) end' tl
    | Ccurve { ctrl1; ctrl2; end' }->
      let acc= Bezier.plot_cubic prev_end ctrl1 ctrl2 end'
        |> frame_of_points
        |> frame_merge acc
      in
      calc acc segment (Some ctrl2) end' tl
    | SQcurve end'->
      let ctrl=
        match prev_ctrl with
        | Some prev_ctrl->
          (match prev with
          | Qcurve _
          | SQcurve _ ->
            Point.Ops.(prev_end + prev_end - prev_ctrl)
          | _-> prev_end)
        | None-> prev_end
      in
      let acc= Bezier.plot_quadratic prev_end ctrl end'
        |> frame_of_points
        |> frame_merge acc
      in
      calc acc segment (Some ctrl) end' tl
    | SCcurve { ctrl=ctrl2; end' }->
      let ctrl1=
        match prev_ctrl with
        | Some prev_ctrl->
          (match prev with
          | Ccurve _
          | SCcurve _ ->
            Point.Ops.(prev_end + prev_end - prev_ctrl)
          | _-> prev_end)
        | None-> prev_end
      in
      let acc= Bezier.plot_cubic prev_end ctrl1 ctrl2 end'
        |> frame_of_points
        |> frame_merge acc
      in
      calc acc segment (Some ctrl2) end' tl
  in
  let acc= frame_dummy
  and prev= Line {x= infinity; y= infinity}
  and prev_end= path.start
  and prev_ctrl= None in
  calc acc prev prev_ctrl prev_end path.segments

let frame_paths ?(algo=frame) paths=
  let frames= paths |> List.map (fun path->
    let (frame,_)= algo path in frame)
  in
  List.fold_left frame_merge frame_dummy frames

let fit_frame ?(algo=frame) ~target paths=
  let frame_paths= frame_paths ~algo in
  let paths_frame= frame_paths paths in
  let size_paths=
    Point.{
      x= paths_frame.width;
      y= paths_frame.height;
    }
  and size_target=
    Point.{
      x= target.width;
      y= target.height;
    }
  and pos_target=
    Point.{
      x= target.x;
      y= target.y;
    }
  in
  let ratio= let open Point.Ops in size_target / size_paths in
  let paths_current= List.map (scale ~r:ratio) paths in
  let paths_current_frame= frame_paths paths_current in
  let delta=
    let open Point in
    let open Ops in
    let pos_paths= {
      x= paths_current_frame.x;
      y= paths_current_frame.y;
    } in
    pos_target - pos_paths
  in
  let paths_current= List.map (translate ~d:delta) paths_current in
  paths_current

