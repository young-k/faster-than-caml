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

let main () =
  (* Create a thread waiting for escape to be pressed. *)
  let waiter, wakener = wait () in

  let mainbox = new vbox in
  let homescreen = new LTerm_widget.label (text ^ "\n\nCreated by [we need a team name]") in
  mainbox#add homescreen;

  let hbox = new hbox in
  let start_button = new button ("START") in
  start_button#on_click (fun () -> failwith "Unimplemented");

  hbox#add (new spacing ~cols:15 ());
  hbox#add (in_frame start_button);
  hbox#add (new spacing ~cols:15 ());

  mainbox#add ~expand:false hbox;
  mainbox#add (new spacing ~rows:1 ());

  let frame = new frame in
  frame#set mainbox;

  (* escape to exit *)
  mainbox#on_event (function
      | LTerm_event.Key { LTerm_key.code = LTerm_key.Escape } -> wakeup wakener (); true
      | _ -> false);

  Lazy.force LTerm.stdout >>= fun term ->
  LTerm.enable_mouse term >>= fun () ->
  Lwt.finalize
    (fun () -> run term frame waiter)
    (fun () -> LTerm.disable_mouse term)


let () = Lwt_main.run (main ())
