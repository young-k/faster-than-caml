open Lwt
open Lwt_react
open LTerm_widget
open Store
open Controller

let get_components c () =
  let s = 
    (match c.storage with
      | Store st -> st
      | _ -> failwith "No store found in controller"
    ) in
  let mainBox = new vbox in
  let label = new label "_" in
  let item = new label "_" in
  let b = new button "Buy" in
  let quit = ref false in
  let d = new button "Done" in
  d#on_click (fun () -> quit := true);
  mainBox#add d;
  mainBox#add label;
  mainBox#add b;

  for i = 0 to 1 do
    let hbox = new hbox in
    let button i = 
      if (i - 1) > 2 then
        let aug = List.nth_opt s.augmentations (i-4) in
        (match aug with
          | Some a -> 
            let name = a.name in
            let description = 
              if a.cost <= c.ship.resources.scrap then 
                "\n Cost: " ^ (string_of_int a.cost) ^ "\n " ^ a.description 
              else "\n You do not have enough scrap" in
            let button = new button (name) in
            button#on_click (fun () -> label#set_text (name ^ description);
                                       item#set_text (name));
            button
          | None -> 
            let button = new button ("None") in
            button#on_click (fun () -> label#set_text ("None");
                                       item#set_text ("_"));
            button
        )
      else
        let weap = List.nth_opt s.weapons (i-1) in
        (match weap with
          | Some w ->
            let name = w.name in
            let description = 
              if w.cost <= c.ship.resources.scrap then 
                "\n Cost: " ^ (string_of_int w.cost) ^ 
                "\n Damage: " ^ (string_of_int w.damage) ^ "\n Capacity: " ^ 
                (string_of_int w.capacity) 
              else "\n You do not have enough scrap" in
            let button = new button (name) in
            button#on_click (fun () -> label#set_text (name ^ description);
                                       item#set_text (name));
            button
          | None -> 
            let button = new button ("None") in
            button#on_click (fun () -> label#set_text ("None");
                                      item#set_text ("_"));
            button
        )
    in
    let t = if i = 0 then "Weapons" else "Augmentations" in
    let lab = new label t in
    hbox#add (button (i * 3 + 1));
    hbox#add ~expand:false (new vline);
    hbox#add (button (i * 3 + 2));
    hbox#add ~expand:false (new vline);
    hbox#add (button (i * 3 + 3));
    mainBox#add ~expand:false (new hline);
    mainBox#add ~expand:false lab;
    mainBox#add ~expand:false (new hline);
    mainBox#add hbox
  done;

  let box = new hbox in
  let ftext = if s.fuel = 0 then ("\nNo more fuel available", "_")
    else if c.ship.resources.scrap < Store.fuel_cost 
      then ("\nYou do not have enough scrap", "_")
    else ("\nCost: " ^ string_of_int Store.fuel_cost, "Fuel") in
  let fbutton = new button ("Fuel: " ^ string_of_int s.fuel ^ " available") in
    fbutton#on_click (fun () -> label#set_text ("Fuel" ^ fst ftext); 
                                item#set_text(snd ftext));
  let mtext = if s.missiles = 0 then ("\nNo more missiles available", "_")
    else if c.ship.resources.scrap < Store.missile_cost 
      then ("\nYou do not have enough scrap", "_")
    else ("\nCost: " ^ string_of_int Store.missile_cost, "Missile") in
  let mbutton = new button ("Missiles: " ^ string_of_int s.missiles ^ " available") in
    mbutton#on_click (fun () -> label#set_text ("Missile" ^ fst mtext); 
                                item#set_text(snd mtext));
  let h1text = 
    if c.ship.resources.scrap < 3 
      then ("\nYou do not have enough scrap", "_")
    else ("\nCost: 3", "1 Hull") in
  let h1button = new button("Repair 1 Hull") in
    h1button#on_click (fun () -> label#set_text (h1button#label ^ (fst h1text));
                                 item#set_text (snd h1text););
  let hcost = 9 * (c.ship.max_hull - c.ship.hull) * 3 / 10 in
  let htext =
    if c.ship.resources.scrap < hcost
      then ("\nYou do not have enough scrap", "_")
    else ("\nCost: " ^ string_of_int hcost, "All Hull") in
  let hbutton = new button("Repair all Hull") in
    hbutton#on_click (fun () -> label#set_text (hbutton#label ^ (fst htext));
                                item#set_text (snd h1text););

  let rlab = new label "Resources" in
  box#add fbutton;
  box#add ~expand:false (new vline);
  box#add mbutton;
  box#add ~expand:false (new vline);
  box#add h1button;
  box#add ~expand:false (new vline);
  box#add hbutton;
  mainBox#add ~expand:false (new hline);
  mainBox#add ~expand:false rlab;
  mainBox#add ~expand:false (new hline);
  mainBox#add box;

  (mainBox, item, b, d, quit);
