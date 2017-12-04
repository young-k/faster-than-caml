open Lwt
open Lwt_react
open LTerm_widget

open Event

(* [in_frame w] is w wrapped in a frame *)
let in_frame w = let f = new frame in f#set w; f

let get_components e () =
  let mainbox = new vbox in

  let hbox = new hbox in
  let descrp = new LTerm_widget.label (get_name e) in

  mainbox#add ~expand:false(new spacing ~rows:15 ());
  hbox#add descrp;
  mainbox#add ~expand:false hbox;
  mainbox#add ~expand:false (new hline);
  mainbox#add ~expand:false(new spacing ~rows:1 ());

  let result_string = (new label "Yes") in
  let group_string = new radiogroup in
  let callback_string = function
    | Some s -> result_string#set_text (s)
    | None -> ()
  in
  group_string#on_state_change callback_string;

  let hbox = new hbox in
  hbox#add ~expand:false (new spacing ~cols:60 ());
  hbox#add (new radiobutton group_string (get_description e true) "Yes");
  (*hbox#add (new spacing ~cols:20 ());*)
  mainbox#add ~expand:false hbox;

  let hbox = new hbox in
  hbox#add ~expand:false (new spacing ~cols:60 ());
  hbox#add (new radiobutton group_string (get_description e false) "No");
  (*hbox#add (new spacing ~cols:20 ());*)
  mainbox#add ~expand:false hbox;
  mainbox#add ~expand:false(new spacing ~rows:1 ());

  let hbox = new hbox in
  let submit_button = new button ("Confirm") in
  hbox#add (new spacing ~cols:20 ());
  hbox#add ~expand:false (in_frame submit_button);
  hbox#add (new spacing ~cols:20 ());
  mainbox#add ~expand:false hbox;

  mainbox#add ~expand:false (new hbox);
  (mainbox, (submit_button, result_string));
