open Lwt
open LTerm_widget
open Galaxy

let get_components star_id galaxy =
  let mainbox = new vbox in

  (* Generate stars *)
  for i = 0 to 10 do
    let hbox = new hbox in
    let rec gen_row num lst =
      if num = 0 then lst
      else
        if Random.int 25 = 0 then gen_row (num-1) ("*"::lst)
        else gen_row (num-1) ("  "::lst)
    in
    let row = gen_row 100 [] |> List.fold_left (^) "" in
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

  (* Setup "Going to: " label *)
  let going_to = ref (-1) in (* initialize value to -1 *)
  let going_to_label = new label "Going to: " in
  let radio_g = new radiogroup in
  let star_changed = function
    | Some n ->
      going_to := n;
      going_to_label#set_text ("Going to: " ^ string_of_int n)
    | None -> ()
  in
  radio_g#on_state_change star_changed;
  mainbox#add going_to_label;

  let button_hbox = new hbox in (* hbox containing the radio buttons *)
  button_hbox#add (new spacing ~cols:5 ());

  (* Find reachable stars *)
  let reachable = reachable galaxy star_id in
  going_to := (reachable |> List.hd |> snd);
  (* Default goes to first star if no other choice is pressed *)
  going_to_label#set_text ("Going to: " ^ string_of_int !going_to);
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

  button_hbox#add (new spacing ~cols:5 ());

  mainbox#add button_hbox;
  mainbox#add (new hline);

  (* Setup Submit button *)
  let submit_vbox = new vbox in
  let submit_button = new button "Submit" in

  submit_vbox#add submit_button;
  mainbox#add submit_vbox;
  (mainbox, (submit_button, !going_to));