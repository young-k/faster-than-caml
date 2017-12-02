open Lwt
open Lwt_react
open LTerm_widget
open Ship
open Controller

let get_components c () =
  let equipped = c.ship.equipped in
  let inventory = c.ship.inventory in
  let systems = c.ship.systems in
  let mainBox = new vbox in
  let d = new button "Done" in

  let eBox = new vbox in
  let eLabel = new label "Equipped" in
  let ehbox = new hbox in
  for i = 1 to systems.weapons_power do
    let button i = new button ("Equipped " ^ (string_of_int i)) in
      ehbox#add (button i);
      ehbox#add ~expand:false (new vline);
  done;
  eBox#add ~expand:false eLabel;
  eBox#add ~expand:false (new hline);
  eBox#add ehbox;
  eBox#add ~expand:false (new hline);

  let iBox = new vbox in
  let iLabel = new label "Inventory" in
  let ihbox = new hbox in
  for i = 1 to List.length inventory do
    let button i = new button ("Inventory " ^ (string_of_int i)) in
      ihbox#add (button i);
      ihbox#add ~expand:false (new vline);
  done;
  iBox#add ~expand:false iLabel;
  iBox#add ~expand:false (new hline);
  iBox#add ihbox;
  iBox#add ~expand:false (new hline);

  let sBox = new vbox in
  let sLabel = new label "Systems" in
  let shbox = new hbox in
  let shield = new button ("Shield level " ^ (string_of_int systems.shield_level)) in
    shbox#add shield;
    shbox#add ~expand:false (new vline);
  let engine = new button ("Engine level " ^ (string_of_int systems.engine_level)) in
    shbox#add engine;
    shbox#add ~expand:false (new vline);
  let weapons = new button ("Weapons level " ^ (string_of_int systems.weapons_level)) in
    shbox#add weapons;
    shbox#add ~expand:false (new vline);
  sBox#add ~expand:false sLabel;
  sBox#add ~expand:false (new hline);
  sBox#add shbox;

  mainBox#add d;
  mainBox#add ~expand:false (new hline);
  mainBox#add eBox;
  mainBox#add iBox;
  mainBox#add sBox;

  (* for i = 0 to 1 do
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
    hbox#add (button (i * 3 + 1));
    hbox#add ~expand:false (new vline);
    hbox#add (button (i * 3 + 2));
    hbox#add ~expand:false (new vline);
    hbox#add (button (i * 3 + 3));
    mainBox#add ~expand:false (new hline);
    mainBox#add hbox
  done; *)

  (mainBox, d);
