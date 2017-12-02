open Lwt
open Lwt_react
open LTerm_widget

(* logo text *)
let text = "    ___ _   ___ _____ ___ ___   _____ _  _   _   _  _    ___   _   __  __ _    \n" ^
           "   | __/_\\ / __|_   _| __| _ \\ |_   _| || | /_\\ | \\| |  / __| /_\\ |  \\/  | |   \n" ^
           "   | _/ _ \\\\__ \\ | | | _||   /   | | | __ |/ _ \\| .` | | (__ / _ \\| |\\/| | |__ \n" ^
           "   |_/_/ \\_\\___/ |_| |___|_|_\\   |_| |_||_/_/ \\_\\_|\\_|  \\___/_/ \\_\\_|  |_|____|\n"

(* [in_frame w] is w wrapped in a frame *)
let in_frame w = let f = new frame in f#set w; f

let get_components () =
  let mainbox = new vbox in

  let logo = new LTerm_widget.label (text ^ "\n\nCreated by Megan Le, Wendy Zhang, Kevin Chan, Young Kim.") in
  mainbox#add logo;

  let hbox = new hbox in
  let start_button = new button ("START") in
  hbox#add (new spacing ~cols:21 ());
  hbox#add (in_frame start_button);
  hbox#add (new spacing ~cols:21 ());

  let hbox2 = new hbox in
  let instructions= new button ("INSTRUCTIONS") in
  hbox2#add (new spacing ~cols:25 ());
  hbox2#add (in_frame instructions);
  hbox2#add (new spacing ~cols:25 ());

  mainbox#add ~expand:false hbox;
  mainbox#add ~expand:false hbox2;
  mainbox#add (new spacing ~rows:1 ());
  (mainbox, (start_button, instructions));
