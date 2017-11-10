open Lwt
open Lwt_react
open LTerm_widget

open Start_screen

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

  let wrapper = new vbox in

  wrapper#add (Start_screen.render_start_screen ());

  let frame = new frame in
  frame#set wrapper;

  (* escape to exit *)
  wrapper#on_event (function
      | LTerm_event.Key { LTerm_key.code = LTerm_key.Escape } -> wakeup wakener (); true
      | _ -> false);

  Lazy.force LTerm.stdout >>= fun term ->
  LTerm.enable_mouse term >>= fun () ->
  Lwt.finalize
    (fun () -> run term frame waiter)
    (fun () -> LTerm.disable_mouse term)


let () = Lwt_main.run (main ())
