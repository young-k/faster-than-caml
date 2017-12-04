open Lwt
open Lwt_react
open LTerm_widget

open Galaxy_screen
open Home_screen
open Instruction_screen    
open Next_galaxy_screen
open Store_screen
open Resting_screen
open Ship_confirm_screen
open Ship_screen
open Text_screen

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
  let score = new label ("Score: " ^ string_of_int c.score) in
  let jumps = new label ("Jumps: " ^ string_of_int c.jumps) in
  let ship = c.ship in
  let resources = Ship.get_resources ship in 
  let hull = Ship.get_hull ship in
  let scrap = new label ("Scrap: " ^ string_of_int resources.scrap) in
  let fuel = new label ("Fuel: " ^ string_of_int resources.fuel) in
  let missiles = new label ("Missiles: " ^ string_of_int resources.missiles) in
  let hull = new label ("Hull: " ^ string_of_int hull) in
  let shield = 
    new label ("Shield Level: " ^ string_of_int (ship.shield.layers)) in
  let crew = 
    new label (
      "   Crew Members: " ^ string_of_int (List.length ship.crew) ^ "   "
    ) in
  let sidebar = new vbox in 
  sidebar#add ~expand:false score;
  sidebar#add ~expand:false jumps;
  sidebar#add ~expand:false new hline;
  sidebar#add ~expand:false scrap;
  sidebar#add ~expand:false fuel;
  sidebar#add ~expand:false missiles;
  sidebar#add ~expand:false hull;
  sidebar#add ~expand:false shield;
  sidebar#add ~expand:false crew;
  sidebar#add ~expand:false button;
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
    let continue = ref true in
    (fst (snd result))#on_click (fun () -> 
        continue := true; (wakeup wakener) ());
    (snd (snd result))#on_click (fun () -> 
        continue := false; (wakeup wakener) ());
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else if !continue then loop t (parse_command c ShowStartText)
        else loop t (parse_command c ShowInstructions))
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
  | GameOver str->
    let result = Game_over_screen.get_components str () in
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
        else loop t (parse_command Controller.init ShowStartText))
  | StartScreen ->
    let result = Text_screen.get_components 0 () in
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
  | Nothing ->
    let result = Text_screen.get_components 1 () in
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
    let (map, ship_screen, mainbox) = Resting_screen.get_components button (fst display) () in
    wrapper#add mainbox;
    let show_ship = ref false in 
      map#on_click (fun () -> show_ship := false; wakeup wakener ());
      ship_screen#on_click (fun () -> show_ship := true; wakeup wakener ());
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else if !show_ship then loop t (parse_command c ShowShipScreen)
        else loop t (parse_command c ShowMap))
  | Combat ->
    let result = Combat_screen.get_components button (fst display) () in
    wrapper#add (result |> fst |> snd);
    (result |> fst |> fst)#on_click (wakeup wakener);
    let weapon_index = !(snd result) in
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else loop t (parse_command c (Attack weapon_index)))
  | Store s ->
    let (mainBox, item, b, d, quit) = Store_screen.get_components 
      {c with storage = Store s} () in
    wrapper#add mainBox;
    b#on_click (wakeup wakener);
    d#on_click (wakeup wakener);
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else if !quit then loop t (parse_command c ShowShipConfirm)
        else if item#text <> "_" then 
          loop t (parse_command {c with storage = Store s} (Purchase item#text))
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
      else loop t (parse_command c (Go !(result |> snd |> snd))))
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
    let (mainBox, action, d, equip, unequip, upgrade, index) = 
      Ship_screen.get_components c () in
    wrapper#add mainBox;
    d#on_click (fun () -> equip := false; unequip := false; upgrade := false; wakeup wakener ());
    action#on_click (fun () -> if !unequip || !equip || !upgrade then wakeup wakener ());
    Lwt.finalize
      (fun () -> run t frame waiter)
      (fun () ->
        if !exit then return ()
        else if !unequip then loop t (parse_command 
          {c with ship = (Ship.unequip c.ship !index)} ShowShipScreen)
        else if !equip then loop t (parse_command
          {c with ship = (Ship.equip c.ship (List.length c.ship.equipped) !index)}
          ShowShipScreen)
        else if !upgrade then 
          let new_ship = 
            (match !index with
              | 0 -> (Ship.upgrade_shield_level c.ship)
              | 1 -> (Ship.upgrade_engine_level c.ship)
              | 2 -> (Ship.upgrade_weapons_level c.ship)
              | _ -> failwith "Invalid index"
            ) in
          loop t (parse_command {c with ship = new_ship} ShowShipScreen)
        else loop t (parse_command c GoToResting))
  | NextGalaxy ->
    let result = Next_galaxy_screen.get_components () in
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
        else loop t (parse_command c (Go 1)))

let main () =
  let controller = Controller.init in

  Lazy.force LTerm.stdout >>= fun term ->
  LTerm.enable_mouse term >>= fun () ->
  Lwt.finalize
    (fun () -> loop term controller)
    (fun () -> LTerm.disable_mouse term)

let () = Lwt_main.run (main ())
