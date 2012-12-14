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

(* View: lns *)
let lns = Simplevars.lns

(* Variable: filter *)
let filter = incl "/etc/postgresql/*/*/postgresql.conf"

let xfm = transform lns filter

