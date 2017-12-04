open Ship

type store = {
  weapons : weapon list;
  augmentations : augmentation list;
  fuel : int;
  missiles : int;
}

let fuel_cost = 3
let missile_cost = 7

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

let parse_augmentation s : augmentation =
  let w = String.split_on_char ';' s in
    let typ = (match (List.nth w 2) with
    | "Damage" -> Damage
    | "CoolDown" -> CoolDown
    | "Hull" -> Hull
    | "Evade" -> Evade
    | _ -> failwith "Invalid weapon type!"
  ) in
  {
    name = List.nth w 0;
    cost = List.nth w 1 |> int_of_string;
    aug_type = typ;
    stat = List.nth w 3 |> int_of_string;
    description = List.nth w 4;
  }

let init (s : ship) =
  let aug_strings = Parser.get_lines_from_f "./game_data/augmentations.txt" 3 in
  let weaps_strings = Parser.get_lines_from_f "./game_data/weapons.txt" 3 in
  let augs = List.fold_left (fun acc x -> let aug = parse_augmentation x in
                             if List.mem aug s.augmentations then acc
                             else aug::acc) [] aug_strings in
  let weaps = List.fold_left (fun acc x -> let weap = parse_weapon x in
                              if List.mem weap s.inventory then acc
                              else weap::acc) [] weaps_strings in
  {
    weapons = weaps;
    augmentations = augs;
    fuel = 5;
    missiles = 5;
  }

let get_augmentations (st : store) = st.augmentations

let get_weapons (st : store) = st.weapons

(* [apply_augmentation s a] generates a new ship after applying augmentation [a]
 * to ship [s]
 * requires: [s] a ship, [a] an augmentation *)
let apply_augmentation (s : Ship.ship) (a : augmentation) =
  match a.aug_type with
  | Hull -> {s with max_hull = s.max_hull + a.stat}
  | Evade -> {s with evade = s.evade + a.stat}
  | Damage -> let inv = List.map
                        (fun weap -> {weap with damage = weap.damage + a.stat})
                        s.inventory in {s with inventory = inv}
  | CoolDown -> let inv = List.map
                          (fun (weap:weapon) -> {weap with
                                        capacity = max 0 (weap.capacity - a.stat);
                                        charge = min weap.charge
                                                (max 0 (weap.capacity - a.stat))
                                        }
                          )
                          s.inventory in {s with inventory = inv}

let buy st (s : Ship.ship) i =
  if i = "Fuel" then
    (if s.resources.scrap >= fuel_cost then 
      {
        s with
        resources = 
        {s.resources with 
          scrap = s.resources.scrap - fuel_cost;
          fuel = s.resources.fuel + 1;
        };
      }
     else s)
  else if i = "Missile" then
    (if s.resources.scrap >= missile_cost then 
    {
      s with
      resources = 
      {s.resources with 
        scrap = s.resources.scrap - missile_cost;
        missiles = s.resources.missiles + 1;
      };
    }
  else s)
  else
    let weapon = (try List.find_opt (fun (w : weapon) -> w.name = i)
      st.weapons with _ -> None) in
    let aug = (try List.find_opt (fun (a : augmentation) -> a.name = i)
      st.augmentations with _ -> None) in
    match weapon, aug with
      | Some w, _ -> if s.resources.scrap >= w.cost then
        {
          s with
          resources = {s.resources with scrap = s.resources.scrap - w.cost};
          inventory = w::s.inventory
        }
        else s
      | _, Some a -> if s.resources.scrap >= a.cost then
        {
          (apply_augmentation s a) with
          resources = {s.resources with scrap = s.resources.scrap - a.cost};
          augmentations = a::s.augmentations
        }
        else s
      | _ -> failwith ("Item not found: " ^ i)

  let can_buy st (s : Ship.ship) i =
    if i = "Fuel" then s.resources.scrap >= fuel_cost
    else if i = "Missile" then s.resources.scrap >= missile_cost
    else
      let weapon = (try List.find_opt (fun (w : weapon) -> w.name = i)
      st.weapons with _ -> None) in
      let aug = (try List.find_opt (fun (a : augmentation) -> a.name = i)
        st.augmentations with _ -> None) in
        match weapon, aug with
        | Some w, _ -> s.resources.scrap >= w.cost
        | _, Some a -> s.resources.scrap >= a.cost
        | _ -> failwith ("Item not found: " ^ i)

let display (x, y) s st = failwith "Unimplemented"
