open Lwt
open Lwt_react
open LTerm_widget
open Ship
open Controller

let get_components c () =
  let equipped = c.ship.equipped in
  let inventory = List.filter (fun i -> not (List.mem i equipped)) 
    c.ship.inventory in
  let systems = c.ship.systems in
  let mainBox = new vbox in
  let d = new button "Done" in
  let description = new label "" in
  let action = new button
    "Click here to unequip/equip or upgrade after selecting an item or system" in
  let unequip = ref false in
  let equip = ref false in
  let upgrade = ref false in
  let index = ref (-1) in

  let eBox = new vbox in
  let eLabel = new label "Equipped" in
  let ehbox = new hbox in
  for i = 0 to (systems.weapons_power-1) do
    let text = 
      (match List.nth_opt equipped i with
        | None -> ("Empty", "Empty")
        | Some e -> (e.name, e.name ^ "\nCost: " ^ string_of_int e.cost 
                    ^ "\nDamage: " ^ string_of_int e.damage ^ "\nCapacity: "
                    ^ string_of_int e.capacity)
      ) in
    let button i = new button (fst text) in
      let b = button i in
        b#on_click (fun () -> index := i; unequip := true; equip := false;
                              upgrade := false; action#set_label "Unequip";
                              description#set_text (snd text));
      ehbox#add b;
      ehbox#add ~expand:false (new vline);
  done;
  eBox#add ~expand:false eLabel;
  eBox#add ~expand:false (new hline);
  eBox#add ehbox;
  eBox#add ~expand:false (new hline);

  let iBox = new vbox in
  let iLabel = new label "Inventory" in
  let ihbox = new hbox in
  for i = 0 to (List.length inventory)-1 do
    let text = 
      (match List.nth_opt inventory i with
        | None -> ("Empty", "Empty")
        | Some e -> (e.name, e.name ^ "\nCost: " ^ string_of_int e.cost 
                     ^ "\nDamage: " ^ string_of_int e.damage ^ "\nCapacity: "
                     ^ string_of_int e.capacity)
      ) in
    let button i = new button (fst text) in
      let b = button i in
        b#on_click (fun () -> index := i; unequip := false; upgrade := false;
                              description#set_text (snd text) ;
                              if List.length equipped < systems.weapons_power then
                                (equip := true; action#set_label "Equip";)
                              else 
                                (equip := false; action#set_label "No slots available";)
                   );
      ihbox#add b;
      ihbox#add ~expand:false (new vline);
  done;
  iBox#add ~expand:false iLabel;
  iBox#add ~expand:false (new hline);
  iBox#add ihbox;
  iBox#add ~expand:false (new hline);

  let sBox = new vbox in
  let sLabel = new label "Systems" in
  let shbox = new hbox in
  let shield_cost = (systems.shield_level + 1) * 100 in
  let shield_text = 
    if shield_cost > c.ship.resources.scrap then 
      "You do not have enough scrap" 
    else "Upgrade Shield Level\nCost: " ^ string_of_int shield_cost in
  let shield = new button ("Shield level " ^ string_of_int systems.shield_level) in
    shield#on_click (fun () -> index := 0; unequip := false; equip := false;
                               upgrade := true; action#set_label shield_text;
                               description#set_text (shield#label ^ "\nCost: " 
                                ^ string_of_int shield_cost));
    shbox#add shield;
    shbox#add ~expand:false (new vline);
  let engine_cost = (systems.engine_level + 1) * 100 in
  let engine_text = 
    if engine_cost > c.ship.resources.scrap then 
      "You do not have enough scrap" 
    else "Upgrade Engine Level" in
  let engine = new button ("Engine level " ^ string_of_int systems.engine_level) in
    engine#on_click (fun () -> index := 1; unequip := false; equip := false;
                               upgrade := true; action#set_label engine_text;
                               description#set_text (engine#label ^ "\nCost: " 
                                ^ string_of_int engine_cost));
    shbox#add engine;
    shbox#add ~expand:false (new vline);
  let weapon_cost = (systems.weapons_level + 1) * 100 in
  let weapon_text = 
    if weapon_cost > c.ship.resources.scrap then 
      "You do not have enough scrap" 
    else "Upgrade Weapons Level\nCost: " ^ string_of_int weapon_cost in
  let weapons = new button ("Weapons level " ^ string_of_int systems.weapons_level) in
    weapons#on_click (fun () -> index := 2; unequip := false; equip := false;
                                upgrade := true; action#set_label weapon_text;
                                description#set_text (weapons#label ^ "\nCost: " 
                                  ^ string_of_int weapon_cost));
    shbox#add weapons;
    shbox#add ~expand:false (new vline);
  sBox#add ~expand:false sLabel;
  sBox#add ~expand:false (new hline);
  sBox#add shbox;

  mainBox#add d;
  mainBox#add description;
  mainBox#add ~expand:false action;
  mainBox#add ~expand:false (new hline);
  mainBox#add eBox;
  mainBox#add iBox;
  mainBox#add sBox;

  (mainBox, action, d, equip, unequip, upgrade, index);
