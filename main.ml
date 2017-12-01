open Lwt
open Lwt_react
open LTerm_widget

open Home_screen
open Start_screen
open Store_screen
open Debug_screen

open Controller

let exit = ref false

(* terminal, controller *)
let rec loop t c =
  (* Create a thread *)
  let waiter, wakener = wait () in
  let wrapper = new vbox in

  (* button for exiting *)
  let button = new button ~brackets:("[ "," ]") "exit" in
  button#on_click (fun () -> exit := true; (wakeup wakener) ());
  wrapper#add ~expand:false button;

  let frame = new frame in
  frame#set wrapper;

  let display = get_display c in

  match snd display with
  | HomeScreen ->
    let result = Home_screen.get_components () in
    wrapper#add (fst result);
    (snd result)#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c ShowStartText))
  | StartScreen ->
    let result = Start_screen.get_components () in
    wrapper#add (fst result);
    (snd result)#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c ShowStartText))
  | Store s ->
    let result = Store_screen.get_components s () in
    wrapper#add (fst result);
    (fst(snd result))#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c (Purchase (snd (snd result))#text)))
  | Debug ->
    let result = Debug_screen.get_components c () in
    wrapper#add (fst result);
    (snd result)#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c ShowStartText))
  | _ -> return ()

let main () =
  let controller = Controller.init in

  Lazy.force LTerm.stdout >>= fun term ->
  LTerm.enable_mouse term >>= fun () ->
  Lwt.finalize
    (fun () -> loop term controller)
    (fun () -> LTerm.disable_mouse term)

let () = Lwt_main.run (main ())
