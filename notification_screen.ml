open Lwt
open Lwt_react
open LTerm_widget

open Ship

(* [in_frame w] is w wrapped in a frame *)
let in_frame w = let f = new frame in f#set w; f

let get_components delta followup () =
  let mainbox = new vbox in

  let followup_label = new label followup in
  let descrp = new LTerm_widget.label ("You've gained:") in
  let rsc = if delta.scrap = 99 && delta.fuel = 99 && delta.missiles = 99 then
    new LTerm_widget.label ("A new crew member.")
    else new LTerm_widget.label ((string_of_int (delta.scrap))^" Scrap, "^
    (string_of_int (delta.fuel))^" Fuel, "^
    (string_of_int (delta.missiles))^" Missiles.") in

  let hbox = new hbox in
  mainbox#add ~expand:false(new spacing ~rows:15 ());
  hbox#add descrp;
  mainbox#add ~expand:false followup_label;
  mainbox#add ~expand:false (new spacing ~rows:1 ());
  mainbox#add ~expand:false hbox;
  mainbox#add ~expand:false(new spacing ~rows:1 ());

  let hbox = new hbox in
  hbox#add rsc;
  mainbox#add ~expand:false hbox;
  mainbox#add ~expand:false(new spacing ~rows:3 ());

  let hbox = new hbox in
  let ok_button = new button ("OK") in
  hbox#add (new spacing ~cols:35 ());
  hbox#add (in_frame ok_button);
  hbox#add (new spacing ~cols:35 ());
  mainbox#add ~expand:false hbox;

  mainbox#add ~expand:false (new hbox);

  (mainbox, ok_button);
