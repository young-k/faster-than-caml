open Char
open Lwt
open Lwt_react
open LTerm_widget
open Ship

(* [in_frame w] is w wrapped in a frame *)
let in_frame w = let f = new frame in f#set w; f
let in_modal w = let f = new modal_frame in f#set w; f

let ship_ascii = "\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\166\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\164\226\149\144-\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\145&]\194\160\194\160\194\160\194\160\194\160\194\160]\194\160\194\160\194\160\194\172\226\137\136\226\137\136\226\137\136\226\137\136\226\149\166\194\160\194\160\194\160\226\140\144-\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\144 $&\226\150\144%;\226\150\132..\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160`````\194\160\194\160\194\160}\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\144 *\226\150\132\226\140\144;'#.\194\160\194\160\194\160\194\160-\194\160\194\160'\194\160\194\160\194\160/\194\160-\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\153\226\150\132\226\150\132\194\160,==\194\160,\226\149\148\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144-\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160,.\194\160\226\140\144\226\149\144\194\160'`\194\160\194\160\194\160\194\160\\\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160/\194\160'\194\160,~\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160,-**'\\\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160.......................\194\160\194\160\194\160\194\160\194\160\194\160\194\160`--~.......\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\226\149\145\194\160\194\160\194\160\194\160\194\160\194\160\194\160`-\194\160.-\194\160'\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160.\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160'''''`'\194\160.\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\226\149\145\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\148\130\194\160\194\160\194\160\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160,,, ---- ------\194\160- -\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160*\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\226\149\154\226\149\144\226\149\144\226\149\151\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\148\130\194\160\194\160\194\160\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\144\226\149\154\226\149\160\226\149\159\226\149\160\226\150\144\194\160\194\160:\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\226\149\144\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\226\149\148\226\149\144\226\149\144\226\149\157\194\160\194\160\194\160\194\160\194\160\194\160\194\160!\194\160\194\160\194\160\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\144\226\149\160\226\149\160\226\149\159\226\149\159\226\150\144\194\160\194\160:\194\160\194\160\194\160 \194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\226\149\144\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\226\149\145\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\148\130\194\160\194\160\194\160\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160```~\194\160.....  ..\194\160\194\160...\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160 ^\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\226\149\145 \194\160\194\160\194\160\194\160\194\160\194\160-`\194\160\194\160`. \194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160 .\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160...---- '\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160'**\226\140\144,/\194\160\194\160\194\160\194\160\194\160\194\160\194\160'......................'\194\160\194\160\194\160\194\160\194\160\194\160\194\160.\226\148\128\194\160`''''''''\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160''\194\160...z\226\137\164\194\172.\194\160\194\160\194\160/\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\\  .\194\160`\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\159%]\226\140\144\194\160\194\160\194\160\194\160 \226\149\154\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144-\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\144 #\226\149\148\226\150\144\226\149\153`\226\149\154\194\160\194\160\194\160\194\160\194\160#\194\160\194\160\226\137\136==\194\160-\194\160\194\160,\194\160.\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\144 #\226\149\153\226\150\140--\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160----\194\172\194\160\194\160\194\160\226\149\152\194\160`\194\160}\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\159\226\150\146#\194\160\194\160\226\149\146\194\160\194\160\194\160\226\149\146\194\160\194\160\194\160\194\160``'`'\194\160\194\160\194\160\194\160/\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144``\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n";;

let rec repeat str n acc = if n = 0 then acc else repeat str (n-1) acc^str

let get_components exit ship () =
  let mainbox = new hbox in

  let vbox = new vbox in

  let mapbox = new hbox in
  let map = new button ("JUMP") in
  let ship_screen = new button ("SHIP") in
  mapbox#add (new spacing ~cols:30 ());
  mapbox#add (in_frame map);
  mapbox#add (in_frame ship_screen);
  mapbox#add (new spacing ~cols:30 ());

  let footer = new hbox in

  (* Generating weapons section *)
  let weapons_section = new vbox in
  let weapons_label_box = new vbox in
  let weapons_label = new label "Weapons" in
  let weapons = new hbox in
  for i = 0 to (ship.systems.weapons_level-1) do
    match (Ship.get_weapon ship i) with
    | Some w ->
      let some = new label w.name in
      weapons#add some;
      if i<>(ship.systems.weapons_level-1) then weapons#add new vline
      else ()
    | None ->
      let none = new label "None" in
      weapons#add none;
      if i<>(ship.systems.weapons_level-1) then weapons#add new vline
      else ()
  done;

  (* Generating Systems section *)
  let systems_section = new vbox in
  let systems_label = new label "Systems" in
  let systems = new hbox in

  (* Used to generate display for shield/weapon systems *)
  let rec gen_lst_display lvl pow acc = 
    if pow<>0 then gen_lst_display (lvl-1) (pow-1) ("*"::acc) 
    else 
      if lvl<> 0 then gen_lst_display (lvl-1) pow ("_"::acc)
      else acc 
  in 

  (* Takes list from gen_lst_display and generates the text *)
  let gen_display lst = 
    let rev_lst = List.rev lst in 
    List.fold_left (^) "" rev_lst
  in 

  let engine_system = new vbox in
  let e_level = ship.systems.engine_level in 
  let e_power = ship.systems.engine_power in 
  let engine_display = gen_lst_display e_level e_power [] |> gen_display in
  let engine_lbl = new label ("Engine Level: " ^ engine_display) in
  engine_system#add engine_lbl;
  systems#add engine_system;
  systems#add ~expand:false new vline;

  let shield_system = new vbox in
  let s_level = ship.systems.shield_level in
  let s_power = ship.systems.shield_power in
  let shield_display = gen_lst_display s_level s_power [] |> gen_display in 
  let shield_lbl = new label ("Shield: " ^ shield_display) in
  shield_system#add shield_lbl;
  systems#add shield_system;
  systems#add ~expand:false new vline;

  let weapons_system = new vbox in
  let w_level = ship.systems.weapons_level in 
  let w_power = ship.systems.weapons_power in
  let weapons_display = gen_lst_display w_level w_power [] |> gen_display in 
  let weapons_lbl = new label ("Weapons: " ^ weapons_display) in
  weapons_system#add weapons_lbl;
  systems#add weapons_system;

  weapons_label_box#add weapons_label;
  weapons_label_box#add new vline;

  weapons_section#add weapons_label_box;
  weapons_section#add ~expand:false new hline;
  weapons_section#add weapons;

  systems_section#add systems_label;
  systems_section#add ~expand:false new hline;
  systems_section#add systems;
  
  let weapons_frame = in_frame weapons_section in
  let systems_frame = in_frame systems_section in
  footer#add weapons_frame;
  footer#add systems_frame;


  let vbox2 = new vbox in
  let ship_ascii = new label ("hp: "^(repeat "\226\150\136" ship.hull "")^
    (repeat "\226\150\145" (ship.max_hull-ship.hull) "")^"\n\n"^ship_ascii) in
  vbox2#add ~expand:false mapbox;
  vbox2#add ship_ascii;
  vbox2#add ~expand:false footer;

  mainbox#add ~expand:false vbox;
  mainbox#add vbox2;
  (map, ship_screen, mainbox);
