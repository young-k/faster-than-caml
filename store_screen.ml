open Lwt
open Lwt_react
open LTerm_widget
open Store

let get_components s () =
  let mainBox = new vbox in
  let label = new label "_" in
  let item = new label "_" in
  let b = new button ~brackets:("[ "," ]") "Buy" in
  mainBox#add label;
  mainBox#add b;

  for i = 0 to 1 do
    let hbox = new hbox in
    let button i = 
      let name = 
        if (i - 1) > 2 then (List.nth s.augmentations (i-4)).name
        else (List.nth s.weapons (i-1)).name in
      let description = 
        if (i - 1) > 2 then 
          let aug = (List.nth s.augmentations (i-4)) in
          "\n Cost: " ^ (string_of_int aug.cost) ^ "\n " ^ aug.description
        else 
          let w = (List.nth s.weapons (i-1)) in
          "\n Cost: " ^ (string_of_int w.cost) ^ "\n Damage: " ^ 
          (string_of_int w.damage) ^ "\n Capacity: " ^ (string_of_int w.capacity)
        in
      let button = new button (name) in
      button#on_click (fun () -> label#set_text (name ^ description);
                                 item#set_text (name));
      button
    in
    hbox#add (button (i * 3 + 1));
    hbox#add ~expand:false (new vline);
    hbox#add (button (i * 3 + 2));
    hbox#add ~expand:false (new vline);
    hbox#add (button (i * 3 + 3));
    mainBox#add ~expand:false (new hline);
    mainBox#add hbox
  done;

  (mainBox, (b, item));
