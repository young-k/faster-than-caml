(* Parser generates a random list of strings from an input file *)

(* [read_lines_f f ch lst] is the list of all lines from file f *)
val read_lines_f: string -> in_channel -> string list -> string list

(* [get_num_rand lst num acc] gets [num] number of random elements from lst*)
val get_num_rand: string list -> int -> string list -> string list

(* [get_lines_from_f f num] is a string list of [num] random lines from
   file [f]. Lines in [f] that begin with '#' or is empty are skipped. If
   [f] does not contain [num] valid lines, then the list returned will
   just contain all valid lines. *)
val get_lines_from_f: string -> int -> string list

(* [get_scores] takes in an int and returns a string list of the lines of the
 * scoreboard. If the player scores higher than a score on the scoreboard, then
 * the player score is added *)
val get_scores : int -> string list
