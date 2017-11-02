open Lwt_react
open Lwt

let main () =
  (* Create a thread waiting for escape to be pressed. *)
  let waiter, wakener = wait () in

  (* Create the UI. *)
  let vbox = new LTerm_widget.vbox in
  vbox#add (new LTerm_widget.label "Hello, world!");
  vbox#add (new LTerm_widget.label "Press escape to exit.");
  vbox#on_event (function
                   | LTerm_event.Key { LTerm_key.code = LTerm_key.Escape } -> wakeup wakener (); true
                   | _ -> false);

  (* Run. *)
  Lazy.force LTerm.stdout
  >>= fun term ->
  LTerm_widget.run term vbox waiter

let () = Lwt_main.run (main ())
