(* Parser generates a random list of strings from an input file *)

let rec read_lines_f f ch lst =
  try
    let line = input_line ch in
    if (line = "" || (String.get line 0) = '#')
    then read_lines_f f ch lst
    else read_lines_f f ch (line::lst)
  with
  | End_of_file -> lst

let rec get_num_rand lst num acc =
  if num=0 then acc
  else
    let _ = Random.self_init () in
    let len = List.length lst in
    let rand_line = List.nth lst (Random.int len) in
    if (List.mem rand_line acc)
    then get_num_rand lst num acc
    else get_num_rand lst (num-1) (rand_line::acc)

let get_lines_from_f f num =
  let channel = open_in f in
  let lst = read_lines_f f channel [] in
  if List.length lst <= num then lst 
  else get_num_rand lst num [] 

let rec insert_player n pscore lst = if n = 11 then [] else
  match lst with
  | [] -> if n <10 && pscore > 0 then ((string_of_int n)^": "^
                                        (string_of_int pscore))::[]
          else []
  | h::t -> if pscore > h then if h = 0 then
      ((string_of_int n)^": "^(string_of_int pscore))::(insert_player
                                                        (n+1) (-1) t)
      else ((string_of_int n)^": "^(string_of_int pscore))::(insert_player
                                                              (n+1) (-1) lst)
    else ((string_of_int n)^": "^(string_of_int h))::(insert_player
                                                      (n+1) pscore t)

let rec read_score ch lst =
  try
    let line = int_of_string (input_line ch) in
    if line = 0 && lst != [] then lst
    else read_score ch (line::lst)
  with
  | End_of_file -> lst

let get_scores pscore = let channel = try open_in "./game_data/scoreboard.txt"
    with _ -> failwith "Core game data missing: scoreboard.txt." in
  read_score channel [] |> List.rev |> insert_player 1 pscore
