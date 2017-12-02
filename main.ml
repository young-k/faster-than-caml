open Lwt
open Lwt_react
open LTerm_widget

open Galaxy_screen
open Home_screen
open Instruction_screen    
open Start_screen
open Store_screen
open Ship_confirm_screen
open Ship_screen

open Controller

let exit = ref false

(* terminal, controller *)
let rec loop t c =
  (* Create a thread *)
  let waiter, wakener = wait () in
  let wrapper = new hbox in

  (* button for exiting *)
  let button = new button ~brackets:("[ "," ]") "exit" in
  button#on_click (fun () -> exit := true; (wakeup wakener) ());

  (* sidebar fixture *)
  let ship = c.ship in
  let resources = Ship.get_resources ship in 
  let hull = Ship.get_hull ship in
  let scrap = new label ("Scrap: " ^ string_of_int resources.scrap) in
  let fuel = new label ("Fuel: " ^ string_of_int resources.fuel) in
  let missiles = new label ("Missiles: " ^ string_of_int resources.missiles) in
  let hull = new label ("Hull: " ^ string_of_int hull) in
  let shield = 
    new label ("Shield Level: " ^ string_of_int (fst ship.shield)) in
  let crew = 
    new label (
      "   Crew Members: " ^ string_of_int (List.length ship.crew) ^ "   "
    ) in
  let curr_star = new label ("Star: " ^ string_of_int c.star_id) in 
  let sidebar = new vbox in 
  sidebar#add ~expand:false scrap;
  sidebar#add ~expand:false fuel;
  sidebar#add ~expand:false missiles;
  sidebar#add ~expand:false hull;
  sidebar#add ~expand:false shield;
  sidebar#add ~expand:false crew;
  sidebar#add ~expand:false button;
  sidebar#add ~expand:false curr_star;
  wrapper#add ~expand:false sidebar;
  let sidebarline = new vline in
  wrapper#add ~expand:false sidebarline;

  let frame = new frame in
  frame#set wrapper;

  let display = get_display c in

  match snd display with
  | HomeScreen ->
    let result = Home_screen.get_components () in
    wrapper#remove sidebar;
    wrapper#remove sidebarline;
    let screen = new vbox in
    screen#add ~expand:false button;
    screen#add (fst result);
    wrapper#add screen;
    (snd result)#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c ShowStartText))
  | Instructions ->
    let result = Instruction_screen.get_components () in
    wrapper#remove sidebar;
    wrapper#remove sidebarline;
    let screen = new vbox in
    screen#add ~expand:false button;
    screen#add (fst result);
    wrapper#add screen;
    (snd result)#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c ShowHomeScreen))
  | StartScreen ->
    let result = Start_screen.get_components () in
    wrapper#remove sidebar;
    wrapper#remove sidebarline;
    let screen = new vbox in
    screen#add ~expand:false button;
    screen#add (fst result);
    wrapper#add screen;
    (snd result)#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c GoToResting))
  | Resting ->
    let result = Resting_screen.get_components button (fst display) () in
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
    let result = Ship_confirm_screen.get_components c () in
    wrapper#add (fst result);
    (snd result)#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c GoToResting))
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
  | Notification rsc ->
    let result = Notification_screen.get_components rsc () in
    wrapper#add (fst result);
    (snd result)#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c (GoToResting)))
  | ShipScreen ->
    let result = Ship_screen.get_components c () in
    wrapper#add (fst result);
    (snd result)#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c GoToResting))
  | _ -> return ()

let main () =
  let controller = Controller.init in

  Lazy.force LTerm.stdout >>= fun term ->
  LTerm.enable_mouse term >>= fun () ->
  Lwt.finalize
    (fun () -> loop term controller)
    (fun () -> LTerm.disable_mouse term)

let () = Lwt_main.run (main ())
