(*
 * test.ml
 * -----------
 * Copyright : (c) 2023 - 2023, smaji.org
 * Copyright : (c) 2023 - 2023, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_outline.
 *)

open Smaji_glyph_path


module TestPath = struct
  open Path
  open Point
  open Printf

  let%expect_test "frame_reflect"=
    let start= {x= 200.; y= 400. }
    and segments= [
      Ccurve {
        ctrl1= {x= 100.; y= 600. };
        ctrl2= {x= 200.; y= 800. };
        end'= {x= 400.; y= 500. };
      };
      SQcurve {x= 550.; y= 400. };
      ]
    in
    let path= { start; segments } in
    let frame, _prev= frame path in
    printf "%.3f, %.3f, %.3f, %.3f\n"
      frame.min_x frame.min_y
      frame.max_x frame.max_y;
    [%expect "160.770, 320.000, 560.000, 652.982"]

  let%expect_test "frame_algo_svg"=
    let start= {x= 200.; y= 400. }
    and segments= [
      Ccurve {
        ctrl1= {x= 100.; y= 600. };
        ctrl2= {x= 200.; y= 800. };
        end'= {x= 400.; y= 500. };
      };
      SQcurve {x= 550.; y= 400. };
      ]
    in
    let path= { start; segments } in
    let frame, _prev= frame_algo_svg path in
    printf "%.3f, %.3f, %.3f, %.3f\n"
      frame.min_x frame.min_y
      frame.max_x frame.max_y;
    [%expect "160.770, 400.000, 550.000, 652.982"]

end

module TestSvg = struct
  let%expect_test "move"=
    (match Svg.Svg_path.of_string "M12,23-3,1m 0.2\n, \n0.3L 20 , 20" with
    | Some path->
      let path_str= path |> List.map Svg.Svg_path.sub_to_string_hum |> String.concat "\n" in
      print_endline path_str
    | None-> ());
    [%expect "
      Absolute 12.0,23.0; L -3.0,1.0
      Relative 0.2,0.3; L 20.0,20.0"]


  let%expect_test "move"=
    (match Svg.Svg_path.of_string "m12,23-3,1 2,3L20 , 20" with
    | Some path->
      let path_str= path |> List.map Svg.Svg_path.sub_to_string_hum |> String.concat "\n" in
      print_endline path_str
    | None-> ());
    [%expect "Relative 12.0,23.0; l -3.0,1.0; l 2.0,3.0; L 20.0,20.0"]


  let%expect_test "Ccurve"=
    (match Svg.Svg_path.of_string "M20,20C1,2,3,4,5,6-1,2,3,4,5,6\n1,2,3,4,5,6" with
    | Some path->
      let path_str= path |> List.map Svg.Svg_path.sub_to_string_hum |> String.concat "\n" in
      print_endline path_str
    | None-> ());
    [%expect "Absolute 20.0,20.0; C {ctrl1: 1.0,2.0; ctrl2: 3.0,4.0; end: 5.0,6.0}; C {ctrl1: -1.0,2.0; ctrl2: 3.0,4.0; end: 5.0,6.0}; C {ctrl1: 1.0,2.0; ctrl2: 3.0,4.0; end: 5.0,6.0}"]

  let%expect_test "SCcurve"=
    (match Svg.Svg_path.of_string "M20,20S3,4,5,6-3,4,5,6\n3,4,5,6" with
    | Some path->
      let path_str= path |> List.map Svg.Svg_path.sub_to_string_hum |> String.concat "\n" in
      print_endline path_str
    | None-> ());
    [%expect "Absolute 20.0,20.0; S {ctrl2: 3.0,4.0; end: 5.0,6.0}; S {ctrl2: -3.0,4.0; end: 5.0,6.0}; S {ctrl2: 3.0,4.0; end: 5.0,6.0}"]


  let%expect_test "Qcurve"=
    (match Svg.Svg_path.of_string "M20,20Q1,2,3,4-1,2,3,4q1,2,3,4" with
    | Some path->
      let path_str= path |> List.map Svg.Svg_path.sub_to_string_hum |> String.concat "\n" in
      print_endline path_str
    | None-> ());
    [%expect "Absolute 20.0,20.0; Q {ctrl: 1.0,2.0; end: 3.0,4.0}; Q {ctrl: -1.0,2.0; end: 3.0,4.0}; q {ctrl: 1.0,2.0; end: 3.0,4.0}"]

  let%expect_test "SQcurve"=
    (match Svg.Svg_path.of_string "M20,20T1,2-1,2t1,2" with
    | Some path->
      let path_str= path |> List.map Svg.Svg_path.sub_to_string_hum |> String.concat "\n" in
      print_endline path_str
    | None-> ());
    [%expect "Absolute 20.0,20.0; T 1.0,2.0; T -1.0,2.0; t 1.0,2.0"]


  let%expect_test "viewBox"=
    (match Svg.ViewBox.of_string " 1 2, 3  ,  4 \n " with
    | Some viewBox-> Svg.ViewBox.to_string_hum viewBox |> print_endline
    | None-> print_endline "");
    [%expect "{min_x: 1.0; min_y: 2.0; width: 3.0; height: 4.0}"]

  let viewBox= Svg.ViewBox.{ min_x= 1.0; min_y= 2.0; width= 4.0; height= 3.0 }
  and path1=
    Svg.Svg_path.{
      start= Absolute {x=1.0; y=2.};
      segments= [
        Cmd_l {x=3.0; y=4.};
        Cmd_v 5.0;
        Cmd_h 6.0;
        ];
    }
  and path2=
    Svg.Svg_path.{
      start= Relative {x=10.0; y=10.};
      segments= [
        Cmd_l {x=3.0; y=4.};
        Cmd_v 5.0;
        Cmd_h 6.0;
        Cmd_t { end'= {x=7.0; y=8.} };
        Cmd_C {
          ctrl1= {x=100.0; y=100.};
          ctrl2= {x=150.0; y=30.};
          end'= {x=200.0; y=50.};
          };
        ];
    }

  let paths_individual= [
    [path1];
    [path2];
    ]
  and paths_continuous= [
    [path1; path2];
    ]

  let svg_individual= Svg.{ viewBox; paths= paths_individual }
  let svg_continuous= Svg.{ viewBox; paths= paths_continuous }

  let%expect_test "svg_to_string_individual"=
    Svg.svg_string_of_t svg_individual |> print_endline;
    [%expect "
      <svg viewBox=\"1.0,2.0 4.0,3.0\" xmlns=\"http://www.w3.org/2000/svg\">
        <path d=\"
          M 1.0,2.0
          l 3.0,4.0
          v 5.0
          h 6.0
          Z\"
        />
        <path d=\"
          m 10.0,10.0
          l 3.0,4.0
          v 5.0
          h 6.0
          t 7.0,8.0
          C 100.0,100.0,150.0,30.0,200.0,50.0
          Z\"
        />
      </svg>"]

  let%expect_test "svg_to_string_continuous"=
    Svg.svg_string_of_t svg_continuous |> print_endline;
    [%expect "
      <svg viewBox=\"1.0,2.0 4.0,3.0\" xmlns=\"http://www.w3.org/2000/svg\">
        <path d=\"
          M 1.0,2.0
          l 3.0,4.0
          v 5.0
          h 6.0
          Z

          m 10.0,10.0
          l 3.0,4.0
          v 5.0
          h 6.0
          t 7.0,8.0
          C 100.0,100.0,150.0,30.0,200.0,50.0
          Z\"
        />
      </svg>"]

  let%expect_test "svg_reset_viewBox_1"=
    let svg= svg_individual |> Svg.Adjust.viewBox_reset in
    Svg.svg_string_of_t svg |> print_endline;
    [%expect "
      <svg viewBox=\"0.0,0.0 4.0,3.0\" xmlns=\"http://www.w3.org/2000/svg\">
        <path d=\"
          M 0.0,0.0
          l 3.0,4.0
          v 5.0
          h 6.0
          Z\"
        />
        <path d=\"
          m 10.0,10.0
          l 3.0,4.0
          v 5.0
          h 6.0
          t 7.0,8.0
          C 99.0,98.0,149.0,28.0,199.0,48.0
          Z\"
        />
      </svg>"]

  let%expect_test "svg_reset_viewBox_2"=
    let viewBox= { viewBox with
      min_x= -. viewBox.min_x;
      min_y= -. viewBox.min_y }
    in
    let svg= Svg.{ viewBox; paths= paths_individual } |> Svg.Adjust.viewBox_reset in
    Svg.svg_string_of_t svg |> print_endline;
    [%expect "
      <svg viewBox=\"0.0,0.0 4.0,3.0\" xmlns=\"http://www.w3.org/2000/svg\">
        <path d=\"
          M 2.0,4.0
          l 3.0,4.0
          v 5.0
          h 6.0
          Z\"
        />
        <path d=\"
          m 10.0,10.0
          l 3.0,4.0
          v 5.0
          h 6.0
          t 7.0,8.0
          C 101.0,102.0,151.0,32.0,201.0,52.0
          Z\"
        />
      </svg>"]

  let%expect_test "get_path_frame individual"=
    paths_individual
      |> Svg.Svg_path.get_frame_paths
      |> Option.iter (fun frame-> frame
        |> Path.frame_to_string
        |> print_endline);
    [%expect "{ min_x= 1.0; min_y= 2.0; max_x= 200.0; max_y= 61.1130602954 }"]


  let%expect_test "get_path_frame continuous"=
    paths_continuous
      |> Svg.Svg_path.get_frame_paths
      |> Option.iter (fun frame-> frame
        |> Path.frame_to_string
        |> print_endline);
    [%expect "{ min_x= 1.0; min_y= 2.0; max_x= 200.0; max_y= 64.2446752477 }"]

  let%expect_test "fit_frame_individual"=
    Svg.Adjust.viewBox_fitFrame_reset svg_individual |> Svg.svg_string_of_t |> print_endline;
    [%expect "
      <svg viewBox=\"0.0,0.0 199.0,59.1130602954\" xmlns=\"http://www.w3.org/2000/svg\">
        <path d=\"
          M 0.0,0.0
          l 3.0,4.0
          v 5.0
          h 6.0
          Z\"
        />
        <path d=\"
          m 10.0,10.0
          l 3.0,4.0
          v 5.0
          h 6.0
          t 7.0,8.0
          C 99.0,98.0,149.0,28.0,199.0,48.0
          Z\"
        />
      </svg>"]

  let%expect_test "fit_frame_continuous"=
    Svg.Adjust.viewBox_fitFrame_reset svg_continuous |> Svg.svg_string_of_t |> print_endline;
    [%expect "
      <svg viewBox=\"0.0,0.0 199.0,62.2446752477\" xmlns=\"http://www.w3.org/2000/svg\">
        <path d=\"
          M 0.0,0.0
          l 3.0,4.0
          v 5.0
          h 6.0
          Z

          m 10.0,10.0
          l 3.0,4.0
          v 5.0
          h 6.0
          t 7.0,8.0
          C 99.0,98.0,149.0,28.0,199.0,48.0
          Z\"
        />
      </svg>"]

  let%expect_test "sub_to_path"=
    let p1= Svg.Svg_path.sub_to_path path1 in
    let prev= Path.end_of_path p1 in
    let p2= Svg.Svg_path.sub_to_path ?prev path2 in
    Path.path_to_string p1 |> print_endline;
    [%expect {|
      {
        start: (1.0,2.0)
        Line (4.0,6.0)
        Line (4.0,11.0)
        Line (10.0,11.0)
      }
      |}];
    Path.path_to_string p2 |> print_endline;
    [%expect {|
      {
        start: (20.0,21.0)
        Line (23.0,25.0)
        Line (23.0,30.0)
        Line (29.0,30.0)
        SQcurve (36.0,38.0)
        Ccurve { ctrl1: (100.0,100.0); ctrl2: (150.0,30.0); end: (200.0,50.0) }
      }
      |}]

  let%expect_test "load_file"=
    (match Svg.load_file "a.svg" with
    | Some svg-> svg |> Svg.svg_string_of_t |> print_endline
    | None-> print_endline "");
    [%expect "
      <svg viewBox=\"45.0,-33.8 150.0,150.0\" xmlns=\"http://www.w3.org/2000/svg\">
        <path d=\"
          M 151.3,99.8
          c -18.6,-0.1,-33.9,-7.4,-46.1,-21.9
          c -9.4,-11.3,-14.1,-24.1,-14.1,-38.2
          c 0.0,-18.8,7.3,-34.2,21.9,-46.4
          c 11.2,-9.3,24.0,-14.0,38.3,-14.1
          v 5.3
          h -0.1
          c -15.0,0.0,-27.2,5.0,-36.6,14.9
          c -9.6,10.2,-14.4,23.6,-14.4,40.3
          c 0.0,16.4,5.0,29.8,14.9,40.3
          c 9.7,9.8,21.8,14.6,36.3,14.6
          V 99.8
          Z\"
        />
      </svg>"]

  let%expect_test "file_fit_frame_a"=
    (match Svg.load_file "a.svg" with
    | Some svg->
      svg |> Svg.Adjust.viewBox_fitFrame_reset |> Svg.svg_string_of_t |> print_endline
    | None-> print_endline "");
    [%expect {|
      <svg viewBox="0.0,0.0 60.3,120.6" xmlns="http://www.w3.org/2000/svg">
        <path d="
          M 60.2,120.6
          c -18.6,-0.1,-33.9,-7.4,-46.1,-21.9
          c -9.4,-11.3,-14.1,-24.1,-14.1,-38.2
          c 0.0,-18.8,7.3,-34.2,21.9,-46.4
          c 11.2,-9.3,24.0,-14.0,38.3,-14.1
          v 5.3
          h -0.1
          c -15.0,0.0,-27.2,5.0,-36.6,14.9
          c -9.6,10.2,-14.4,23.6,-14.4,40.3
          c 0.0,16.4,5.0,29.8,14.9,40.3
          c 9.7,9.8,21.8,14.6,36.3,14.6
          V 120.6
          Z"
        />
      </svg> |}]

end

module TestGlif = struct
  open Glif
  open Printf

  let%expect_test "load_file"=
    (match load_file "a.xml" with
    | Some glif->
      ListLabels.iter glif.elements ~f:(function
      | Component component->
        printf "component %s\n" (Option.value ~default:"" component.base)
      | Contour contour->
        ListLabels.iter contour.points
          ~f:(fun point-> printf "%s %s %s\n"
            (string_of_contour_point_type point.typ)
            (Utils.string_of_float point.p.x)
            (Utils.string_of_float point.p.y)
            ))
    | None-> print_endline "");
    [%expect "
      component 4e00
      offcurve 237.0 152.0
      offcurve 193.0 187.0
      curve 134.0 187.0
      offcurve 74.0 187.0
      offcurve 30.0 150.0
      curve 30.0 88.0
      offcurve 30.0 23.0
      offcurve 74.0 -10.0
      curve 134.0 -10.0
      offcurve 193.0 -10.0
      offcurve 237.0 25.0
      curve 237.0 88.0"]

  let%expect_test "outline_of_points"=
    "a.xml" |> load_file |> Option.iter @@ fun glif->
      glif.elements |> List.iter (function
        | Component _-> ()
        | Contour contour->
          contour.points
            |> Glif.outline_of_points
            |> Option.iter @@ fun path->
              path |> Path.path_to_string |> print_endline
        );
    [%expect "
      {
        start: (134.0,187.0)
        Ccurve { ctrl1: (74.0,187.0); ctrl2: (30.0,150.0); end: (30.0,88.0) }
        Ccurve { ctrl1: (30.0,23.0); ctrl2: (74.0,-10.0); end: (134.0,-10.0) }
        Ccurve { ctrl1: (193.0,-10.0); ctrl2: (237.0,25.0); end: (237.0,88.0) }
        Ccurve { ctrl1: (237.0,152.0); ctrl2: (193.0,187.0); end: (134.0,187.0) }
      }"]

  let%expect_test "outline_of_points"=
    "b.xml" |> load_file |> Option.iter @@ fun glif->
      glif.elements |> List.iter (function
        | Component _-> ()
        | Contour contour->
          contour.points
            |> Glif.outline_of_points
            |> Option.iter @@ fun path->
              path |> Path.path_to_string |> print_endline
        );
    [%expect "
      {
        start: (297.0,-12.0)
        Ccurve { ctrl1: (408.0,-12.0); ctrl2: (508.0,85.0); end: (508.0,251.0) }
        Ccurve { ctrl1: (508.0,401.0); ctrl2: (440.0,498.0); end: (315.0,498.0) }
        Ccurve { ctrl1: (261.0,498.0); ctrl2: (207.0,469.0); end: (162.0,431.0) }
        Line (165.0,518.0)
        Line (165.0,712.0)
        Line (82.0,712.0)
        Line (82.0,0.0)
        Line (148.0,0.0)
        Line (156.0,50.0)
        Line (159.0,50.0)
        Ccurve { ctrl1: (202.0,11.0); ctrl2: (252.0,-12.0); end: (297.0,-12.0) }
      }
      {
        start: (283.0,58.0)
        Ccurve { ctrl1: (251.0,58.0); ctrl2: (207.0,71.0); end: (165.0,108.0) }
        Line (165.0,362.0)
        Ccurve { ctrl1: (211.0,406.0); ctrl2: (253.0,428.0); end: (294.0,428.0) }
        Ccurve { ctrl1: (385.0,428.0); ctrl2: (422.0,357.0); end: (422.0,250.0) }
        Ccurve { ctrl1: (422.0,130.0); ctrl2: (363.0,58.0); end: (283.0,58.0) }
      }"]

  let%expect_test "outline_to_points"=
    "b.xml" |> load_file |> Option.iter @@ fun glif->
      glif.elements |> List.iter (function
        | Component _-> ()
        | Contour contour->
          print_endline "path";
          contour.points
            |> Glif.outline_of_points
            |> Option.iter @@ fun path->
              path
                |> Glif.points_of_outline_exn
                |> List.map Glif.string_of_contour_point
                |> String.concat "\n"
                |> print_endline
        );
    [%expect "
      path
      offcurve (408.0,-12.0)
      offcurve (508.0,85.0)
      curve (508.0,251.0)
      offcurve (508.0,401.0)
      offcurve (440.0,498.0)
      curve (315.0,498.0)
      offcurve (261.0,498.0)
      offcurve (207.0,469.0)
      curve (162.0,431.0)
      line (165.0,518.0)
      line (165.0,712.0)
      line (82.0,712.0)
      line (82.0,0.0)
      line (148.0,0.0)
      line (156.0,50.0)
      line (159.0,50.0)
      offcurve (202.0,11.0)
      offcurve (252.0,-12.0)
      curve (297.0,-12.0)
      path
      offcurve (251.0,58.0)
      offcurve (207.0,71.0)
      curve (165.0,108.0)
      line (165.0,362.0)
      offcurve (211.0,406.0)
      offcurve (253.0,428.0)
      curve (294.0,428.0)
      offcurve (385.0,428.0)
      offcurve (422.0,357.0)
      curve (422.0,250.0)
      offcurve (422.0,130.0)
      offcurve (363.0,58.0)
      curve (283.0,58.0)"]

end

