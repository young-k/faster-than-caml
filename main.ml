open Lwt
open Lwt_react
open LTerm_widget

open Home_screen
open Start_screen
open Store_screen
open Debug_screen
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
        else loop t (parse_command c CloseStartText))
  | Resting ->
    print_endline "IN RESTING";
    let result = Resting_screen.get_components button (fst display) () in
    wrapper#remove button;
    wrapper#add (snd result);
    (fst result)#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c ShowMap))
  | Store s ->
    let result = Store_screen.get_components {c with storage = Store s} () in
    wrapper#add (fst (fst result));
    (fst(snd result))#on_click (wakeup wakener);
    (fst(snd (snd result)))#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else if !(snd (snd (snd result))) then loop t (parse_command c ShowShipConfirm)
        else if (snd(fst result))#text <> "_" then 
          loop t (parse_command {c with storage = Store s} (Purchase (snd(fst result))#text))
        else loop t (parse_command {c with storage = Store s} ShowStore))
  | ShipConfirm ->
    let result = Debug_screen.get_components c () in
    wrapper#add (fst result);
    (snd result)#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c CloseMap))
  | GalaxyScreen (star_id, gal)->
    let result = Galaxy_screen.get_components star_id gal in
    wrapper#add (fst result);
    (result |> snd |> fst)#on_click (wakeup wakener);
    Lwt.finalize
    (fun () -> run t frame waiter)
    (fun () ->
      if !exit then return ()
      else loop t (parse_command c (Go (result |> snd |> snd))))
  | Event event ->
    let result = Event_screen.get_components event () in
    let bool = if (snd (snd result))#text = "Yes" then true
      else false in
    wrapper#add (fst result);
    (fst (snd result))#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c (Choice bool)))
  | _ -> return ()

let main () =
  let controller = Controller.init in

  Lazy.force LTerm.stdout >>= fun term ->
  LTerm.enable_mouse term >>= fun () ->
  Lwt.finalize
    (fun () -> loop term controller)
    (fun () -> LTerm.disable_mouse term)

let () = Lwt_main.run (main ())
