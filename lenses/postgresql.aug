(*
Module: Postgresql
  Parses postgresql.conf

Author: Raphael Pinson <raphink@gmail.com>

About: Reference
  http://www.postgresql.org/docs/current/static/config-setting.html

About: License
   This file is licenced under the LGPL v2+, like the rest of Augeas.

About: Lens Usage
   To be documented

About: Configuration files
   This lens applies to postgresql.conf. See <filter>.

About: Examples
   The <Test_Postgresql> file contains various examples and tests.
*)


module Postgresql =
  autoload xfm

(* Variable: to_comment_re
   The regexp to match the value *)
let to_comment_re =
     let to_comment_squote = /'[^\n']*'/
  in let to_comment_dquote = /"[^\n"]*"/
  in let to_comment_noquote = /[^=\n \t'"#][^\n#]*[^\n \t#]|[^\n \t'"#]/
  in to_comment_squote | to_comment_dquote | to_comment_noquote

let sep = del /([ \t]+)|([ \t]*=[ \t]*)/ " = "

let number_re = Rx.reldecimal

let number = Quote.do_squote_opt (store number_re)

let unit_re = Rx.decimal . /[kMG]?B|[m]?s|min|h|d/

let unit = Quote.do_squote_opt (store unit_re)


let boolean_re = /on|off?|t(r(ue?)?)?|f(a(l(se?)?)?)?|y(es?)?|no?/i
(* View: boolean
    A boolean value.
    0 and 1 are already managed by <number> *)
let boolean = Quote.do_squote_opt (store boolean_re)

(* View: word
     Anything other than <number>, <unit> or <boolean> *)
let word =
     let esc_squot = /\\\\'/
  in let no_quot = /[^#'\n]/
  in let forbidden = number_re | unit_re | boolean_re
  in let value = (no_quot|esc_squot)* - forbidden
  in Quote.do_squote (store value)

(* View: entry_gen
     Builder to construct entries *)
let entry_gen (lns:lens) =
  Util.indent . Build.key_value_line_comment Rx.word sep lns Util.comment_eol

(* View: entry *)
let entry = entry_gen number
          | entry_gen unit
          | entry_gen boolean
          | entry_gen word    (* anything else *)

(* View: lns *)
let lns = (Util.empty | Util.comment | entry)*

(* Variable: filter *)
let filter = incl "/etc/postgresql/*/*/postgresql.conf"

let xfm = transform lns filter

