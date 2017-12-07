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
      if (line= "" || (String.get line 0) = '#' || List.mem line lst)
      then
        read_lines_rand f ch num lst
      else
        let _ = Random.self_init() in 
        if (Random.float 1.0 > 0.95)
        then
          read_lines_rand f ch (num-1) (line::lst)
        else
          read_lines_rand f ch num lst
    with
    | End_of_file ->
      let channel = open_in f in
      read_lines_rand f channel num lst

let get_lines_from_f f num =
  let channel = open_in f in
  read_lines_rand f channel num []

let rec insert_player n pscore lst = 
  if n=11 then [] 
  else
    match lst with
    | [] -> 
      if n <10 && pscore>0 
      then ((string_of_int n) ^ ": " ^ (string_of_int pscore))::[] 
      else []
    | h::t -> 
      if pscore > h 
      then 
        if h = 0 then ((string_of_int n) ^ ": " ^ (string_of_int pscore))::
                      (insert_player (n+1) (-1) t)
        else ((string_of_int n)^": "^(string_of_int pscore))::
             (insert_player (n+1) (-1) lst)
      else ((string_of_int n)^": "^(string_of_int h))::
           (insert_player (n+1) pscore t)

let rec read_score ch lst =
  try
    let line = int_of_string (input_line ch) in
    if line = 0 && lst != [] then lst
    else read_score ch (line::lst)
  with
  | End_of_file -> lst

let get_scores pscore = 
  let channel = try open_in "./game_data/scoreboard.txt" 
    with _ -> failwith "Core game data missing: scoreboard.txt." in
  read_score channel [] |> List.rev |> insert_player 1 pscore
