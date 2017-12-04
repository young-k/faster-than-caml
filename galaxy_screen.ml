open Lwt
open LTerm_widget
open Galaxy

(* [in_frame w] is w wrapped in a frame *)
let in_frame w = let f = new frame in f#set w; f

let get_components star_id galaxy =
  let map = new hbox in
  let mainbox = new vbox in

  (* Generate stars *)
  for i = 0 to 10 do
    let hbox = new hbox in
    let rec gen_row num lst =
      if num = 0 then lst
      else
        if Random.int 7 = 0 then gen_row (num-1) ("*"::lst)
        else gen_row (num-1) ("  "::lst)
    in
    let row = gen_row 30 [] |> List.fold_left (^) "" in
    let label = new label row in
    hbox#add label;
    mainbox#add hbox;
  done;

  mainbox#add (new hline);

  let hbox = new hbox in
  (* Generate question label *)
  let label = new label "[ Where do you want to go to? ]" in
  hbox#add label;
  mainbox#add hbox;


  (* Find reachable stars *)
  let reachable = reachable galaxy star_id in

  (* Setup radio group for buttons *)
  let going_to = ref (reachable |> List.hd |> snd) in (* initialize value to first choice *)
  let radio_g = new radiogroup in
  let star_changed = function
    | Some n ->
      going_to := n;
    | None -> ()
  in
  radio_g#on_state_change star_changed;

  let button_hbox = new hbox in (* hbox containing the radio buttons *)
  button_hbox#add (new spacing ~cols:5 ()); 

  (* Default goes to first star if no other choice is pressed *)
  let add_star (event_type, id) =
    let str_id = string_of_int id in
    match event_type with
    | Some Store ->
      button_hbox#add (new radiobutton radio_g ("Store "^(str_id)) id)
    | _ ->
      button_hbox#add (new radiobutton radio_g ("Star "^(str_id)) id)
  in

  (* Generate button for stars *)
  let _ = List.map (add_star) reachable in


  mainbox#add button_hbox; 
  mainbox#add (new hline);

  (* Setup Submit button *)
  let submit_vbox = new vbox in
  let submit_button = new button "Submit" in

  submit_vbox#add submit_button;
  mainbox#add submit_vbox;
  map#add mainbox;
  (map, (submit_button, going_to));
