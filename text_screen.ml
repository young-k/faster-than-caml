open Lwt
open Lwt_react
open LTerm_widget

let start_text = 
  "The data you carry is vital to the remaining Federation fleet. \n" ^
  "You'll need supplies for your journey, so make sure to explore \n" ^
  "each sector before moving onto the next. But get to the exit   \n" ^
  "before the pursuing Rebel fleet can catch up!" 

let empty_text = 
  "There is not much of interest nearby. A small sun in the \n" ^
  "distance with a few orbiting planets in nearby space     \n" ^
  " is your only companionship.                                "

let next_galaxy_text = 
  "Congratulations on completing this galaxy. \n" ^
  "Time to move on to the next one! \n" ^
  "Quickly before the pursuing Rebel fleet can catch up!" 

let default_btext = "Continue..."
let next_galaxy_btext = "Jump to next galaxy."

(* [in_frame w] is w wrapped in a frame *)
let in_frame w = let f = new frame in f#set w; f 

let in_modal w = let f = new modal_frame in f#set w; f 

(* [get_text i] gets the modal text and button text for a given screen.
 * 0: start_screen
 * 1: nothing screen
 * 2: next galaxy screen *)
let get_text i = 
  if i=0 then (start_text, default_btext)
  else if i=1 then (empty_text, default_btext)
  else (next_galaxy_text, next_galaxy_btext)

let get_components i () =
  let modal = new vbox in
  let mainbox = new vbox in
  let surroundbox = new hbox in 

  let texts = get_text i in

  let logo = new LTerm_widget.label (fst texts) in

  let hbox = new hbox in
  let button = new button (snd texts) in
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
