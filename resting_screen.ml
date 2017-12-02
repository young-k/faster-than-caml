open Char
open Lwt
open Lwt_react
open LTerm_widget

(* [in_frame w] is w wrapped in a frame *)
let in_frame w = let f = new frame in f#set w; f 
let in_modal w = let f = new modal_frame in f#set w; f 

let get_components exit ship () =
  let mainbox = new hbox in

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

  let vbox = new vbox in 
  vbox#add ~expand:false scrap;
  vbox#add ~expand:false fuel;
  vbox#add ~expand:false missiles;
  vbox#add ~expand:false hull;
  vbox#add ~expand:false shield;
  vbox#add ~expand:false crew;
  vbox#add ~expand:false exit;

  let mapbox = new hbox in
  let map = new button ("JUMP") in
  mapbox#add (new spacing ~cols:40 ());
  mapbox#add (in_frame map);
  mapbox#add (new spacing ~cols:40 ());

  let footer = new vbox in
  let inventory = new label "Inventory" in
  let weapons = new hbox in
  for i = 0 to 3 do
    let temp = new vbox in
    match (Ship.get_weapon ship i) with
    | Some w ->
      let some = new label "Weapon" in
      temp#add some;
    | None -> 
      let none = new label "None" in
      temp#add none;
    weapons#add temp;
    weapons#add new vline;
  done;

  footer#add ~expand:false new hline;
  footer#add inventory;
  footer#add ~expand:false new hline;
  footer#add weapons;

  let vbox2 = new vbox in
  let ship_ascii = new label "INSERT ASCII HERE :)" in
  vbox2#add ~expand:false mapbox;
  vbox2#add ship_ascii;
  vbox2#add ~expand:false footer;

  mainbox#add ~expand:false vbox;
  mainbox#add ~expand:false new vline;
  mainbox#add vbox2;
  (map, mainbox);
