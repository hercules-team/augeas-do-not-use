(*                                                          *)
(* Sip_Conf module for Augeas                               *)
(* Author: Rob Tucker <rtucker@mozilla.com>                 *)
(* Much help from : Raphael Pinson <raphink@gmail.com>      *)
(* Based Off PHP lens by Raphael Pinson <raphink@gmail.com> *)
(*                                                          *)
(*                                                          *)

module Sip_Conf =
  autoload xfm

(************************************************************************
 * INI File settings
 *************************************************************************)

let comment        = IniFile.comment IniFile.comment_re IniFile.comment_default
let sep            = IniFile.sep IniFile.sep_re IniFile.sep_default
let empty          = IniFile.empty
let eol            = IniFile.eol
let comment_or_eol = comment | eol


let entry    = IniFile.indented_entry IniFile.entry_re sep comment

let text_re = Rx.word
let tmpl    =
  let is_tmpl = [ label "@is_template" . Util.del_str "!" ]
    in let use_tmpl = [ label "@use_template" . store Rx.word ]
    in let comma = Util.delim ","
    in Util.del_str "(" . Sep.opt_space
      . Build.opt_list (is_tmpl|use_tmpl) comma
      . Sep.opt_space . Util.del_str ")"
let title_comment_re = /[ \t]*[#;].*$/

let title_comment = [ label "@title_comment"
  . store title_comment_re ]
let title   = label "title" . Util.del_str "["
            . store text_re . Util.del_str "]"
            . tmpl? . title_comment? . eol
let record  = IniFile.record title entry 

let lns     = IniFile.lns record comment

let filter = incl "/etc/asterisk/sip.conf"

let xfm = transform lns filter
