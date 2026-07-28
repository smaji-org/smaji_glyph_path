(*
 * bugfix.ml
 * -----------
 * Copyright : (c) 2023 - 2026, smaji.org
 * Copyright : (c) 2023 - 2026, ZAN DoYe <zandoye@gmail.com>
 * Licence   : GPL2
 *
 * This file is a part of Smaji_glyph_path.
 *)

let string_ends_with ~suffix str=
  let str_len= String.length str
  and suffix_len= String.length suffix in
  let sub= String.sub str (str_len-suffix_len) suffix_len in
  sub = suffix

let string_of_float f=
  let str= string_of_float f in
  if string_ends_with ~suffix:"." str then str ^ "0" else str

