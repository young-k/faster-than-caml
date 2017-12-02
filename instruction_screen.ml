open Lwt
open Lwt_react
open LTerm_widget

let text = "                           Instructions                        \n" ^
           "                           ============                        \n" ^
           "                                                               \n" ^
           "1. FTC is a rougelike, meaning if you lose you must start over.\n" ^
           "2. The exit for a galaxy is always star 10, and you must exit a\n" ^
           "   galaxy in at most 6 jumps.                                  \n" ^
           "3. Buying an item does not come with any confirmation!         \n" 

(* [in_frame w] is w wrapped in a frame *)
let in_frame w = let f = new frame in f#set w; f 
let in_modal w = let f = new modal_frame in f#set w; f 

let get_components () =
  let modal = new vbox in
  let mainbox = new vbox in
  let surroundbox = new hbox in 

  let logo = new LTerm_widget.label text in

  (* button code: refactor this *)
  let hbox = new hbox in
  let button = new button ("Go Back...") in
  hbox#add (new spacing ~cols:15 ());
  hbox#add (in_frame button);
  hbox#add (new spacing ~cols:15 ());

  modal#add ~expand:false logo;
  modal#add (new spacing ~rows:1 ());
  modal#add ~expand:false hbox;

  mainbox#add (new spacing ~rows:7 ());
  mainbox#add ~expand:false (in_frame modal); 
  mainbox#add (new spacing ~rows:7 ());

  surroundbox#add (new spacing ~cols:10 ());
  surroundbox#add mainbox;
  surroundbox#add (new spacing ~cols:10 ());
  (surroundbox, button);
