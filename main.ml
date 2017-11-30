open Lwt
open Lwt_react
open LTerm_widget

open Home_screen
open Start_screen
open Galaxy_screen

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
  | GalaxyScreen (star_id, gal)->
    let result = Galaxy_screen.get_components star_id gal in
    wrapper#add (fst result);
    let submit_pressed () =
      let _ = (loop t (parse_command c (Go (result |> snd |> snd)))) in
      ()
    in
    (result |> snd |> fst)#on_click (fun () -> submit_pressed ());
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
