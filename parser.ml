(* Parser generates a random list of strings from an input file *)

(* [read_lines ch num lst] is a string list of the first [num] possible lines
   from a file not already in [lst]. If [num] is more than the number of
   non-comment or blank lines in the file, then a list will just contain all
   the valid lines.
   requires: [ch] is an in_channel, [num] is an int, [lst] is a string list *)
let rec read_lines ch num lst =
  if num=0 then lst
  else
    try
      let line = input_line ch in
      if (line= "" || (String.get line 0) = '#' || List.mem line lst)
      then
        read_lines ch num lst
      else
        read_lines ch (num-1) (line::lst)
    with
    | End_of_file -> lst

(* [read_lines_rand f ch num lst] is a string list of size [num] random lines
   read from file [f] using [ch]. If [num] is more than the number of
   non-comment or blank lines in the file, then a list will just contain all
   the possible lines.
   requires: [ch] is an in_channel, [num] is an int, [lst] is a string list *)
let rec read_lines_rand f ch num lst =
  if num=0 then lst
  else
    try
      let line = input_line ch in
      if (line= "" || (String.get line 0) = '#')
      then
        read_lines_rand f ch num lst
      else
        if (Random.float 1.0 > 0.5)
        then
          read_lines_rand f ch (num-1) (line::lst)
        else
          read_lines_rand f ch num lst
    with
    | End_of_file ->
      let channel = open_in f in
      read_lines channel num lst

let get_lines_from_f f num =
  let channel = open_in f in
  read_lines_rand f channel num []
