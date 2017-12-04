(* types from ship.mli *)

type weapon_type = Ion | Laser | Beam | Missile

type weapon = {
  name : string;
  cost : int;
  damage : int;
  capacity : int;
  charge : int;
  wtype : weapon_type;
}

type shield = {
  layers : int;
  charge : int;
  capacity : int;
}

type augmentation_type = Damage | CoolDown | Evade | Hull

type augmentation = {
  name : string;
  cost : int;
  aug_type : augmentation_type;
  stat : int;
  description : string;
}

type person = {
  name : string;
  skills : (int * int * int);
}

type resources = {
  fuel : int;
  missiles : int;
  scrap : int;
}

type systems = {
  shield_level : int;
  shield_power : int;
  engine_level : int;
  engine_power : int;
  weapons_level : int;
  weapons_power : int;
}

type ship = {
  resources: resources;
  crew: person list;
  hull: int;
  max_hull: int;
  evade: int;
  equipped : weapon list;
  shield: shield;
  inventory : weapon list;
  augmentations : augmentation list;
  systems: systems;
}

let init = {
  (* Starting resources *)
  resources = {fuel = 5; missiles = 1; scrap = 100;};
  crew = [{
    name = "O Camel";
    skills = (3,3,3)
  }];
  hull = 30;
  max_hull = 30;
  evade = 20;
  equipped = [{
    name = "Ion cannon";
    cost = 10;
    damage = 1;
    capacity = 2;
    charge = 0;
    wtype = Ion;
  }];
  shield = {
    layers = 1;
    charge = 0;
    capacity = 5;
  };
  inventory = [{
    name = "Ion cannon";
    cost = 10;
    damage = 1;
    capacity = 2;
    charge = 0;
    wtype = Ion;
  }];
  augmentations = [];
  systems = {
  shield_level = 1;
  shield_power = 1;
  engine_level = 1;
  engine_power = 1;
  weapons_level = 1;
  weapons_power = 1;
  }

}

(*----------------------basic get/set functions--------------------*)

let evade ship = ship.evade

let get_hull ship = ship.hull

let charge_shield ship =
  if ship.shield.layers = ship.systems.shield_power then ship
  else if ship.shield.charge = ship.shield.capacity then
    {ship with shield = {layers = ship.shield.layers+1;
                         charge = 0;
                         capacity = ship.shield.capacity}}
  else {ship with shield = {ship.shield with charge = ship.shield.charge+1}}

(*----------------------resources get/set functions----------------*)

let get_resources ship = ship.resources

let set_resources ship (da, db, dc) =
  {ship with resources = {fuel = ship.resources.fuel + da;
   missiles = ship.resources.missiles + db;
   scrap = ship.resources.scrap + dc;}
  }

let get_fuel ship = ship.resources.fuel

let set_fuel ship i =
  {ship with resources = {ship.resources with fuel = i}}

let get_missiles ship = ship.resources.missiles

let set_missiles ship i =
  {ship with resources = {ship.resources with missiles = i}}

let get_scrap ship = ship.resources.scrap

let set_scrap ship i =
  {ship with resources = {ship.resources with scrap = i}}

(*----------------------weapon/hull functions----------------------*)

let damage ship dmg wtype = let sh = ship.shield in
  let level = sh.layers in
  if level >= dmg && wtype != Missile then
  {ship with shield = {sh with layers = sh.layers - dmg}}
  else if wtype = Missile then
  {ship with hull = let red = (ship.hull - dmg) in
      if red < 0 then 0 else red}
  else {ship with shield = {sh with layers = 0};
    hull = let red = (ship.hull - (dmg - level)) in
      if red < 0 then 0 else red}

let repair_all_hull ship = 
  let cost = (ship.max_hull - ship.hull) * 3 * 9 / 10 in
  {ship with 
    hull = ship.max_hull;
    resources = {ship.resources with scrap = ship.resources.scrap - cost}
  }

let repair_hull ship n =
  let cost = n * 3 in
  {ship with
    hull = ship.hull + n;
    resources = {ship.resources with scrap = ship.resources.scrap - cost}
  }

let increase_hull ship rep = {ship with max_hull = ship.max_hull + rep}

let get_weapon ship ind = try (Some (List.nth (ship.equipped) ind))
  with _ -> None

let equip ship inv_ind slot =
  let inv = List.filter (fun i -> not (List.mem i ship.equipped)) 
    ship.inventory in
  let w = List.nth_opt inv slot in
  match w with
  | Some weap ->
    {ship with
      equipped = weap::ship.equipped
    }
  | None -> ship

let unequip ship slot =
  let w = List.nth_opt ship.equipped slot in
  match w with
  | Some weap -> 
    {ship with 
      equipped = 
        (List.filter (fun (weapon : weapon) -> weap.name <> weapon.name) 
          ship.equipped)
    }
  | None -> ship

let add_weapon ship weapon = {ship with inventory = weapon::ship.inventory}

let charge_weapons ship =
  let increase (weap:weapon) =
    if weap.charge = weap.capacity then weap
    else {weap with charge = weap.charge+1}
  in
  {ship with equipped = List.map increase ship.equipped}

let weapon_ready ship slot = match get_weapon ship slot with
  | None -> false
  | Some weap -> weap.charge = weap.capacity

let fire_weapon ship slot = let rec filter n (lst:weapon list) = match lst with
    | [] -> []
    | h::t -> if n = slot then {h with charge = 0}::t
        else h::(filter (n+1) t)
  in
  {ship with equipped = filter 0 ship.equipped}

let step ship = charge_shield ship |> charge_weapons

(*----------------------system functions---------------------------*)
let set_shield_power ship n =
  {ship with systems = {ship.systems with shield_power = n}}

let set_engine_power ship n =
  {ship with systems = {ship.systems with engine_power = n}}

let set_weapons_power ship n =
  {ship with systems = {ship.systems with weapons_power = n}}

let set_shield_level ship n =
  {ship with systems = {ship.systems with shield_level = n}}

let set_engine_level ship n =
  {ship with systems = {ship.systems with engine_level = n}}

let set_weapons_level ship n =
  {ship with systems = {ship.systems with weapons_level = n}}

let repair_systems ship = {ship with systems = {ship.systems with
  shield_power = ship.systems.shield_level;
  engine_power = ship.systems.engine_level;
  weapons_power = ship.systems.weapons_level;}}

(*----------------------augmentation functions---------------------*)

let add_augmentation ship aug =
  {ship with augmentations = aug::ship.augmentations}

let get_augmentation ship ind = try (Some (List.nth (ship.augmentations) ind))
  with _ -> None

(*----------------------crew functions-----------------------------*)

let get_person ship ind = try (Some (List.nth (ship.crew) ind))
  with _ -> None

(*----------------------upgrade functions-----------------------------*)
let upgrade_engine_level ship =
  let new_level = ship.systems.engine_level + 1 in
  let price = new_level * 100 in
  if ship.resources.scrap < price then ship
  else (set_engine_level (set_resources ship (0, 0, -price)) new_level)

let upgrade_shield_level ship =
  let new_level = ship.systems.shield_level + 1 in
  let price = new_level * 100 in
  if ship.resources.scrap < price then ship
  else (set_shield_level (set_resources ship (0, 0, -price)) new_level)

let upgrade_weapons_level ship =
  let new_level = ship.systems.weapons_level + 1 in
  let price = new_level * 100 in
  if ship.resources.scrap < price then ship
  else (set_weapons_level (set_resources ship (0, 0, -price)) new_level)
