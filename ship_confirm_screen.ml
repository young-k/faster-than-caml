open Lwt
open Lwt_react
open LTerm_widget
open Controller

(* Debug screen displays current controller to make sure events correctly
 * modify the controller and to make debugging with GUI easier. Currently only 
 * displays specific fields of ship but feel free to add necessary feels. *)

let in_frame w = let f = new frame in f#set w; f 

let in_modal w = let f = new modal_frame in f#set w; f 

let get_components (c : controller) () =
  let text = "Ship Info: \n" ^
  "Scrap: " ^ string_of_int c.ship.resources.scrap ^ "\n" ^
  "Hull: " ^ string_of_int c.ship.hull ^ "\n" ^
  "Evade: " ^ string_of_int c.ship.evade ^ "\n" ^
  "Weapons: " ^ (List.fold_right 
    (fun (x : Ship.weapon) acc -> acc ^ x.name ^ "; ") c.ship.inventory "") 
    ^ "\n" ^
  "Augmentations: " ^ (List.fold_right 
    (fun (x : Ship.augmentation) acc -> acc ^ x.name ^ "; ") 
      c.ship.augmentations "") in


  let modal = new vbox in
  let mainbox = new vbox in
  let surroundbox = new hbox in 

  let logo = new LTerm_widget.label text in

  (* button code: refactor this *)
  let hbox = new hbox in
  let button = new button ("Continue...") in
  hbox#add (new spacing ~cols:15 ());
  hbox#add (in_frame button);
  hbox#add (new spacing ~cols:15 ());

  modal#add ~expand:false logo;
  modal#add (new spacing ~rows:1 ());
  modal#add ~expand:false hbox;

  mainbox#add (new spacing ~rows:7 ());
  mainbox#add ~expand:false (in_frame modal); 
  mainbox#add (new spacing ~rows:7 ());

  surroundbox#add (new spacing ~cols:10 ());
  surroundbox#add mainbox;
  surroundbox#add (new spacing ~cols:10 ());
  (surroundbox, button);
