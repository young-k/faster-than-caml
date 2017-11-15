(* [Ship] contains all data and methods of the player's ship *)

(* [weapon_type] is the variant that represents the types of ship weapons *)
type weapon_type = Ion | Laser | Beam | Missile

(* [weapon] represents the record which represents a ship weapon
 * contains fields {name, cost, damage, capacity, charge, and wtype} *)
type weapon = {
  name : string;
  cost : int;
  damage : int;
  capacity : int;
  charge : int;
  wtype : weapon_type;
}

(* [augmentation] represents an augmentation comprised of fields
 * {name, cost, and description} *)
type augmentation = {
  name : string;
  cost : int;
  description : string;
}

(* [person] is the record that represents a crew member, contains fields
 * {name, skills: (weapon skills, engine skills, shield skills)} *)
type person = {
  name : string;
  skills : (int * int * int);
}

(* [resources] is the record that represents the resources of a ship including
 * fuel, missiles, and scrap *)
type resources = {
  fuel : int;
  missiles : int;
  scrap : int;
}

(* [systems] is the record representing the state of the ship's systems 
 * [< >_level] is the max power each system can have.
 * [< >_power] is the power distrubuted to each system
 * requires each system power <= system level *)
type systems = {
  shield_level : int;
  shield_power : int;
  engine_level : int;
  engine_power : int;
  weapons_level : int;
  weapons_power : int;
}

(* [ship] represents the state of the player's ship *)
type ship = {
  (* [resources] is the record containting (fuel, missiles, scrap) *)
  resources: resources;
  (* [crew] is the list of crew members *)
  crew: person list;
  (* [hull] the ship's hp, max hull = 30 *)
  hull: int;
  (* [evade] the ship's evade chance, 0 <= evade <= 100 *)
  evade: int;
  (* [equipped] represents the list of ship's equipped weapons
   * index of weapon represents slot, index = 0-3 *)
  equipped : weapon list;
  (* [location] represents int id of ship's current location *)
  location: int;
  (* [shield] represents the tuple (current shield level, charge time)
   * current shield level = # active shields * charge time + stored charges
   * current shield level <= shield power * charge time *)
  shield: (int * int);
  (* [inventory] is the list of all the weapons a ship owns *)
  inventory : weapon list;
  (* [augmentations] is the list of ship's augmentations *)
  augmentations : augmentation list;
  (* [system_levels] is the triple of the max power each system can have *)
  systems: systems;

}

(* [init] returns an initiated ship *)
val init : ship

(*----------------------basic get/set functions--------------------*)

(* [get_location] returns int id of location *)
val get_location : ship -> int

(* [set_location] returns ship with new location
 * requires [str] is valid location id *)
val set_location : ship -> int -> ship

(* [evade] returns int for evasion chance based on ship stats *)
val evade : ship -> int

(* [get_hull] returns int of ship's hp *)
val get_hull : ship -> int

(*----------------------resources get/set functions----------------*)

(* [get_resources] returns record of the ship's resources *)
val get_resources : ship -> resources

(* [set_resources] returns ship with each element of the triple added to 
 * each respective field of resources *)
val set_resources : ship -> (int * int * int) -> ship

(* [get_fuel] returns int number of ship's fuel *)
val get_fuel : ship -> int

(* [set_fuel] returns ship with given number of fuel *)
val set_fuel : ship -> int -> ship

(* [get_missiles] returns int number of ship's missiles *)
val get_missiles : ship -> int

(* [set_missiles] returns ship with given number of missiles *)
val set_missiles : ship -> int -> ship

(* [get_scrap] returns int number of ship's scrap *)
val get_scrap : ship -> int

(* [set_scrap] returns ship with given number of scrap *)
val set_scrap : ship -> int -> ship

(*----------------------weapon/hull functions----------------------*)

(* [damage] returns ship damaged by specified weapon type and by 
 * the specified amount *)
val damage : ship -> int -> weapon_type -> ship

(* [repair] returns ship with hull increased by specified amount *)
val repair : ship -> int -> ship

(* [get_weapon] returns [Some weapon] from the equipped slot with given index
 * if no weapon is available, returns [None] *)
val get_weapon : ship -> int -> weapon option

(* [equip] equips the ith weapon from the inventory to the nth (0-3) slot 
 * throws "Illegal inventory index", "Illegal weapon slot" 
 * and "Not enough weapons power" *)
val equip : ship -> int -> int -> ship

(* [add_weapon] returns ship with added weapon to its inventory *)
val add_weapon : ship -> weapon -> ship

(*----------------------system functions---------------------------*)

(* [set_shield_power] returns ship with specified shield system power *)
val set_shield_power : ship -> int -> ship

(* [set_engine_power] returns ship with specified engine system power *)
val set_engine_power : ship -> int -> ship

(* [set_weapons_power] returns ship with specified weapons system power *)
val set_weapons_power : ship -> int -> ship

(* [set_shield_level] returns ship with specified shield system level *)
val set_shield_level : ship -> int -> ship

(* [set_engine_level] returns ship with specified engine system level *)
val set_engine_level : ship -> int -> ship

(* [set_weapons_level] returns ship with specified weapons system level *)
val set_weapons_level : ship -> int -> ship

(* [repair_system] restores all systems. *)
val repair_system : ship -> ship

(*----------------------augmentation functions---------------------*)

(* [add_augmentation] takes an augmentation and adds it to the ship *)
val add_augmentation : ship -> augmentation -> ship

(* [get_augmentation] returns the ith augmentation.
 * If wrong index/none available, returns None *)
val get_augmentation : ship -> int -> augmentation option

(*----------------------crew functions-----------------------------*)

(* [get_person] returns the ith crew member
 * If wrong index/none available, returns None *)
val get_person : ship -> int -> person option
