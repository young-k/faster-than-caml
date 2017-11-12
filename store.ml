type weapon_type = Ship.weapon_type

type weapon = Ship.weapon

type augmentation = Ship.augmentation

type store = {
  weapons : weapon list;
  augmentations : augmentation list;
}

let init s = failwith "Unimplemented. Figure out .txt file for data"

let get_augmentations (st : store) = st.augmentations

let get_weapons (st : store) = st.weapons

let buy st (s : Ship.ship) i = 
  let weapon = (try List.find_opt (fun (w : weapon) -> w.name = i) 
    st.weapons with _ -> None) in
  let aug = (try List.find_opt (fun (a : augmentation) -> a.name = i)
    st.augmentations with _ -> None) in
  match weapon, aug with
    | Some w, _ -> if s.resources.scraps > w.cost then 
      { 
        s with 
        resources = {s.resources with scraps = s.resources.scraps - w.cost};
        inventory = w::s.inventory
      } 
      else s
    | _, Some a -> if s.resources.scraps > a.cost then 
      {
        s with 
        resources = {s.resources with scraps = s.resources.scraps - a.cost};
        augmentations = a::s.augmentations
      } 
      else s
    | _ -> failwith "Item not found"

let display (x, y) s st = failwith "Unimplemented"
