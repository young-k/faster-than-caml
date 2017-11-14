open Ship

type store = {
  weapons : weapon list;
  augmentations : augmentation list;
}

let parse_weapon s : weapon = 
  let w = String.split_on_char ';' s in
  let typ = (match (List.nth w 5) with
    | "Ion" -> Ion
    | "Laser" -> Laser
    | "Beam" -> Beam
    | "Missile" -> Missile
    | _ -> failwith "Invalid weapon type!"
  ) in
  {
    name = List.nth w 0;
    cost = List.nth w 1 |> int_of_string;
    damage = List.nth w 2 |> int_of_string;
    capacity = List.nth w 3 |> int_of_string;
    charge = List.nth w 4 |> int_of_string;
    wtype = typ;
  }

let parse_augmentations s : augmentation = 
  let w = String.split_on_char ';' s in
  {
    name = List.nth w 0;
    cost = List.nth w 1 |> int_of_string;
    description = List.nth w 2;
  }

let init (s : ship) = 
  let aug_strings = Parser.get_lines_from_f "./game_data/augmentations.txt" 3 in
  let weaps_strings = Parser.get_lines_from_f "./game_data/weapons.txt" 3 in
  let augs = List.fold_left (fun acc x -> let aug = parse_augmentations x in
                             if List.mem aug s.augmentations then acc 
                             else aug::acc) [] aug_strings in
  let weaps = List.fold_left (fun acc x -> let weap = parse_weapon x in
                              if List.mem weap s.inventory then acc
                              else weap::acc) [] weaps_strings in
  {
    weapons = weaps;
    augmentations = augs;
  }

let get_augmentations (st : store) = st.augmentations

let get_weapons (st : store) = st.weapons

let buy st (s : Ship.ship) i = 
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
