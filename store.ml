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
  let rec gen_augs n lst =
    if n = 0 then lst
    else 
      let str = Parser.get_lines_from_f "./game_data/augmentations.txt" 1 in
      let aug = parse_augmentation (List.hd str) in
      if List.mem aug lst then gen_augs n lst
      else gen_augs (n-1) (aug::lst) in
  let rec gen_weaps n lst =
    if n = 0 then lst
    else 
      let str = Parser.get_lines_from_f "./game_data/weapons.txt" 1 in
      let weap = parse_weapon (List.hd str) in
      if List.mem weap lst then gen_weaps n lst
      else gen_weaps (n-1) (weap::lst) in
  let augs = gen_augs 3 [] in
  let weaps = gen_weaps 3 [] in
  {
    weapons = weaps;
    augmentations = augs;
    fuel = 5;
    missiles = 5;
  }

let get_augmentations (st : store) = st.augmentations

let get_weapons (st : store) = st.weapons

let apply_augmentation (s : Ship.ship) (a : augmentation) =
  match a.aug_type with
  | Hull -> {s with max_hull = s.max_hull + a.stat}
  | Evade -> {s with evade = s.evade + a.stat}
  | Damage -> let inv = List.map
                        (fun weap -> {weap with damage = weap.damage + a.stat})
                        s.inventory in 
              let equipped = List.map
                            (fun weap -> {weap with damage = weap.damage + a.stat})
                            s.equipped in
                            {s with inventory = inv; equipped = equipped}
  | CoolDown -> let inv = List.map
                          (fun (weap:weapon) -> {weap with
                                        capacity = max 0 (weap.capacity - a.stat);
                                        charge = min weap.charge
                                                (max 0 (weap.capacity - a.stat))
                                        }
                          )
                          s.inventory in
                let equipped = List.map
                          (fun (weap:weapon) -> {weap with
                                        capacity = max 0 (weap.capacity - a.stat);
                                        charge = min weap.charge
                                                (max 0 (weap.capacity - a.stat))
                                        }
                          )
                          s.equipped in {s with inventory = inv; equipped = equipped}

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
