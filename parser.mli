(* Parser generates a random list of strings from an input file *)

(* [get_lines_from_f f num] is a string list of [num] random lines from
   file [f]. Lines in [f] that begin with '#' or is empty are skipped. If
   [f] does not contain [num] valid lines, then the list returned will
   just contain all valid lines. *)
val get_lines_from_f: string -> int -> string list
