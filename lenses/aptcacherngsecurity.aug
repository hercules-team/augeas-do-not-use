(* Copyright 2013 Erik B. Andersen. 

About: License
	This file is licenced under the LGPL v2+.

*)
module AptCacherNGSecurity =
	autoload xfm
	
	(* Define a comment *)
	let comment = [ label "#comment" . Util.del_str "#" . store /[^\n]*/ . Util.del_str "\n" ]
	
	(* Define a Username/PW pair *)
	let authpair = [ key /[^ \t:\/]*/ . del /:/ ":" . store /[^: \t\n]*/ ]
	
	(* Define a record. So far as I can tell, the only auth level supported is Admin *)
	let record = [ key "AdminAuth". del /[ \t]*:[ \t]*/ ": ". authpair . Util.del_str "\n"]
	
	(* Define Empty line *)
	let empty = [ del /[ \t]*\n/ "\n" ] 
	
	(* Define the basic lens *)
	let lns = ( record | empty | comment )*
	
	
	
	let filter = incl "/etc/apt-cacher-ng/security.conf"
		. Util.stdexcl
	
	let xfm = transform lns filter
	
	
