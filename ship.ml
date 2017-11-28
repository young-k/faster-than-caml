(* types from ship.mli *)

type weapon_type = Ion | Laser | Beam | Missile

type weapon = {
  name : string;
  cost : int;
  damage : int;
  cool_down : int;
  charge : int;
  wtype : weapon_type;
}

type augmentation = {
  name : string;
  cost : int;
  description : string;
}

type person = {
  name : string;
  skills : (int * int * int);
}

type resources = {
  fuel : int;
  missiles : int;
  scraps : int;
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
  evade: int;
  equipped : weapon list;
  location: int;
  shield: (int * int);
  inventory : weapon list;
  augmentations : augmentation list;
  systems: systems;
  }

let init = {
  (* Starting resources *)
  resources = {fuel = 5; missiles = 0; scraps = 0;};
  crew = [{
    name = "O Camel";
    skills = (3,3,3)
  }];
  hull = 30;
  evade = 20;
  equipped = [{
    name = "Ion cannon";
    cost = 10;
    damage = 1;
    cool_down = 2;
    charge = 0;
    wtype = Ion;
  }];
  (* placeholder location *)
  location = 0;
  shield = (1, 5);
  inventory = [{
    name = "Ion cannon";
    cost = 10;
    damage = 1;
    cool_down = 2;
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

let get_location ship = ship.location

let set_location ship id = {ship with location = id}

let evade ship = ship.evade

let get_hull ship = ship.hull

(*----------------------resources get/set functions----------------*)

let get_resources ship = ship.resources

let set_resources ship (da, db, dc) =
  {ship with resources = {fuel = ship.resources.fuel + da;
   missiles = ship.resources.missiles + db;
   scraps = ship.resources.scraps + dc;}
  }

let get_fuel ship = ship.resources.fuel

let set_fuel ship i =
  {ship with resources = {ship.resources with fuel = i}}

let get_missiles ship = ship.resources.missiles

let set_missiles ship i =
  {ship with resources = {ship.resources with missiles = i}}

let get_scraps ship = ship.resources.scraps

let set_scraps ship i =
  {ship with resources = {ship.resources with scraps = i}}

(*----------------------weapon/hull functions----------------------*)

let damage ship dmg wtype = let (shield, charge) = ship.shield in
  let level = shield / charge in
  if level >= dmg && wtype != Missile then
  {ship with shield = (shield - (dmg*charge), charge)}
  else if wtype = Missile then
  {ship with hull = let red = (ship.hull - dmg) in
      if red < 0 then 0 else red}
  else {ship with shield = (shield mod charge, charge);
    hull = let red = (ship.hull - (dmg - level)) in
      if red < 0 then 0 else red}

let repair ship rep = {ship with hull = ship.hull + rep}

let get_weapon ship ind = try (Some (List.nth (ship.equipped) ind))
  with _ -> None

let equip ship inv_ind slot =
  let rec replace lst i weap acc = match lst with
    | [] -> List.rev_append acc (weap::[])
    | h::t -> if i = slot then List.rev_append acc (weap::t)
      else replace t (i+1) weap (h::acc) in
  let w = (try (List.nth ship.inventory inv_ind)
    with _ -> failwith "Illegal inventory index") in
  let new_equipped = replace ship.equipped 0 w [] in
  if slot < 0 || slot > 3 then failwith "Illegal weapon slot"
    else {ship with equipped = new_equipped}

let add_weapon ship weapon = {ship with inventory = weapon::ship.inventory}

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

let repair_system ship = {ship with systems = {ship.systems with
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
