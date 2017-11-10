(* types from ship.mli *)

type weapon_type = Ion | Laser | Beam | Missile
(* [weapon] represents the tuple
 * {weapon name, cost, charge, cool_down, damage, wtype} *)
type weapon = {
  name : string;
  cost : int;
  damage : int;
  cool_down : int;
  charge : int;
  wtype : weapon_type;
}

(* [augmentation] represents an augmentation comprised of fields
 * augmentation name, cost, and description *)
type augmentation = {
  name : string;
  cost : int;
  description : string;
}

(* [person] represents the record
 * (name, (weapon skills, engine skills, shield skills)) *)
type person = {
  name : string;
  skills : (int * int * int);
}

(* [ship] represents the state of the player's ship *)
type ship = {
  (* [resources] is (fuel, missiles, scrap) *)
  resources: int * int * int;
  (* [crew] is the list of crew members *)
  crew: person list;
  (* [hull] the ship's hp, max hull = 30 *)
  hull: int;
  (* [evade] the ship's evade, 0 <= evade <= 100 *)
  evade: int;
  (* [equipped] represents the list of ship's equipped weapons
   * index of weapon represents slot *)
  equipped : weapon list;
  (* [location] represents int id of ship's current location *)
  location: int;
  (* [shield] represents the tuple (current shield level, charge time)
   * current shield level = # active shields * charge time + stored charges
   * current shield level <= shield power * charge time*)
  shield: (int * int);
  (* [inventory] stores all the weapons a ship owns *)
  inventory : weapon list;
  (* [augmentations] represents the list of ship's augmentations *)
  augmentations : augmentation list;
  (* [system_levels] are the max power each system can have
   * can be upgraded *)
  system_levels : (int*int*int);
  (* [system_power] power distrubuted to each system
   * requires sum of all system_power <= power AND
   * each system power <= system level
   * tentative: (shield, engine, weapons) *)
  system_powers : (int*int*int);

  }

let init = {
  (* Starting resources *)
  resources = (5,0,0);
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
  system_levels = (1,1,1);
  system_powers = (1,1,1);

}

(*----------------------basic get/set functions--------------------*)

let get_location ship = ship.location

let set_location ship id = {ship with location = id}

let get_resources ship = ship.resources

let set_resources ship (da, db, dc) = let (a, b, c) = ship.resources in
  {ship with resources = (a + da, b + db, c + dc)}

let evade ship = ship.evade

let get_hull ship = ship.hull

(*----------------------weapon/hull functions----------------------*)

(* [damage] returns ship with shield/hull reduced by specified amount *)
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

(* [repair] returns ship with hull increased by specified amount *)
let repair ship rep = {ship with hull = ship.hull + rep}

(* [get_weapon] returns [Some weapon]
 * if no weapon is available, returns [None] *)
let get_weapon ship ind = try (Some (List.nth (ship.equipped) ind))
  with _ -> None

(* [equip] equips the ith weapon from the inventory to the nth (0-3) slot
 * throws "Illegal weapon slot" and "Illegal weapon slot" *)
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

(* [add_weapon] adds a weapon to the ship's inventory *)
let add_weapon ship weapon = {ship with inventory = weapon::ship.inventory}

(*----------------------system functions---------------------------*)

(* [upgrade_system] upgrades [i]th system, expends scraps
 * throws "Invalid system index" *)
let upgrade_system ship ind = let (x, y, z) = ship.system_levels in
  if ind = 0 then {ship with system_levels = (x+1, y, z)}
  else if ind = 1 then {ship with system_levels = (x, y+1, z)}
  else if ind = 2 then {ship with system_levels = (x, y, z+1)}
  else failwith "Invalid system index"

(* [damage_system] damages [i]th system with [dmg] amount of type [type] weapon.
 * throws "Invalid system index" *)
let damage_system ship ind dmg = let cap_int i = if i < 0 then 0 else i in
  let (x, y, z) = ship.system_levels in
  if ind = 0 then {ship with system_levels = (cap_int (x-dmg), y, z)}
  else if ind = 1 then {ship with system_levels = (x, cap_int (y-dmg), z)}
  else if ind = 2 then {ship with system_levels = (x, y, cap_int (z-dmg))}
  else failwith "Invalid system index"

(* [repair_system] restores all systems. *)
let repair_system ship = {ship with system_powers = ship.system_levels}

(*----------------------augmentation functions---------------------*)

(* [add_augmentation] takes an augmentation name and adds it to the ship *)
let add_augmentation ship aug = {ship with augmentations = aug::ship.augmentations}

(* [get_augmentation] returns the ith augmentation.
 * If wrong index/none available, returns None *)
let get_augmentation ship ind = try (Some (List.nth (ship.augmentations) ind))
  with _ -> None

(*----------------------crew functions-----------------------------*)

(* [get_person] returns the ith crew member
 * If wrong index/none available, returns None *)
let get_person ship ind = try (Some (List.nth (ship.crew) ind))
  with _ -> None
