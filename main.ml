open Lwt
open Lwt_react
open LTerm_widget

open Start_screen
open Start_text

open Command
open Ship

let main () =
  (* Create a thread waiting for escape to be pressed. *)
  let waiter, wakener = wait () in
  let wrapper = new vbox in

  (* temp code for exiting *)
  let button = new button ~brackets:("[ "," ]") "exit" in
  button#on_click (wakeup wakener);
  wrapper#add ~expand:false button;

  let result = Start_screen.get_components () in 
  wrapper#add (fst result);
  (snd result)#on_click 
    (fun () -> 
       wrapper#remove (fst result); 
       let result = Start_text.get_components () in
       wrapper#add (fst result);
       (snd result)#on_click (fun () -> wrapper#remove (fst result));
    );

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
