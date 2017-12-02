open Lwt
open Lwt_react
open LTerm_widget

let text = "                            Game Over!                         \n" ^
           "                            ==========                         \n" 

(* [in_frame w] is w wrapped in a frame *)
let in_frame w = let f = new frame in f#set w; f 
let in_modal w = let f = new modal_frame in f#set w; f 

let get_components str () =
  let modal = new vbox in
  let mainbox = new vbox in
  let surroundbox = new hbox in 

  let logo = new LTerm_widget.label text in
  let msg = new LTerm_widget.label str in

  (* button code: refactor this *)
  let hbox = new hbox in
  let button = new button ("Start Again...") in
  hbox#add (new spacing ~cols:15 ());
  hbox#add (in_frame button);
  hbox#add (new spacing ~cols:15 ());

  modal#add ~expand:false logo;
  modal#add (new spacing ~rows:1 ());

  modal#add ~expand:false msg;
  modal#add (new spacing ~rows:1 ());
  modal#add ~expand:false hbox;

  mainbox#add (new spacing ~rows:7 ());
  mainbox#add ~expand:false (in_frame modal); 
  mainbox#add (new spacing ~rows:7 ());

  surroundbox#add (new spacing ~cols:10 ());
  surroundbox#add mainbox;
  surroundbox#add (new spacing ~cols:10 ());
  (surroundbox, button);
