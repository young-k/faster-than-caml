type weapon = {
  name : string;
  cost : int;
  damage : int;
  cool_down : int;
}
type weapons = weapon list
type augmentation = {
  name : string;
  cost : int;
  description : string;
}
type augmentations = augmentation list

type store = {
  weapons : weapons;
  augmentations : augmentations;
}

(* Will import from Ship. Need to discuss ship types *)
type resource = {
  fuel : int;
  missiles : int;
  scrap : int;
}
type person = (string * int * int * int)
type ship = {
  resources : resource;
  crew: person list;
  hull: int;
  evade: int;
  equipped : weapon list;
  location: int;
  shield: (int * int);
  inventory : weapons;
  augmentations : augmentations;
  system_levels : (int * int * int);
  system_powers : (int * int * int);
}

let init s = failwith "Unimplemented. Figure out .txt file for data"

let get_augmentations st = st.augmentations

let get_weapons st = st.weapons

let buy st s i = 
  let weapon = (try List.find_opt (fun (w : weapon) -> w.name = i) 
    st.weapons with _ -> None) in
  let aug = (try List.find_opt (fun (a : augmentation) -> a.name = i)
    st.augmentations with _ -> None) in
  match weapon, aug with
    | Some w, _ -> if s.resources.scrap > w.cost then 
      { 
        s with 
        resources = {s.resources with scrap = s.resources.scrap - w.cost};
        inventory = w::s.inventory
      } 
      else s
    | _, Some a -> if s.resources.scrap > a.cost then 
      {
        s with 
        resources = {s.resources with scrap = s.resources.scrap - a.cost};
        augmentations = a::s.augmentations
      } 
      else s
    | _ -> failwith "Item not found"

let display (x, y) s st = failwith "Unimplemented"
