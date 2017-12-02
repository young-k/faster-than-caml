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
  let b = new button ~brackets:("[ "," ]") "Buy" in
  let quit = ref false in
  let d = new button "Done" in
  d#on_click (fun () -> quit := true);
  mainBox#add label;
  mainBox#add b;
  mainBox#add d;

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
    hbox#add (button (i * 3 + 1));
    hbox#add ~expand:false (new vline);
    hbox#add (button (i * 3 + 2));
    hbox#add ~expand:false (new vline);
    hbox#add (button (i * 3 + 3));
    mainBox#add ~expand:false (new hline);
    mainBox#add hbox
  done;

  ((mainBox, item), (b, (d, quit)));
