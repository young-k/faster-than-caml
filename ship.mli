(* [Ship] contains all data and functions of the player's ship *)

(* [weapon_type] is the variant that represents the types of ship weapons *)
type weapon_type = Ion | Laser | Beam | Missile

(* [weapon] represents the record which represents a ship weapon
 * contains fields {name, cost, damage, capacity, charge, and wtype} 
 * RI: charge <= capacity*)
type weapon = {
  name : string;
  cost : int;
  damage : int;
  capacity : int;
  charge : int;
  wtype : weapon_type;
}

(* [shield] represents represents the the record which contains
 * the number of active shield layers, the amount of charge, and
 * charge capacity *)
type shield = {
  layers : int;
  charge : int;
  capacity : int;
}

(* [augmentation_type] represents the different types of augmentations *)
type augmentation_type = Damage | CoolDown | Evade | Hull

(* [augmentation] represents an augmentation comprised of fields
 * {name, cost, description, aug_type, and stat} *)
type augmentation = {
  name : string;
  cost : int;
  aug_type : augmentation_type;
  stat : int;
  description : string;
}

(* [person] is the record that represents a crew member, contains fields
 * {name, skills: (weapon skills, engine skills, hull skills); hp} *)
type person = {
  name : string;
  skills : (int * int * int);
  hp : int;
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
  (* [crew] is the list of crew members. Can contain a max of 2 persons *)
  crew: person list;
  (* [hull] is the ship's hp *)
  hull: int;
  (* [max_hull] is the ship's max hull, = 30 *)
  max_hull: int;
  (* [evade] the ship's evade chance, 0 <= evade <= 100 *)
  evade: int;
  (* [equipped] represents the list of ship's equipped weapons
   * index of weapon represents slot, index = 0-3 *)
  equipped : weapon list;
  (* [shield] is the ship's shield *)
  shield: shield;
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

(* [evade s] returns int for evasion chance based on a given ship [s] *)
val evade : ship -> int

(* [get_hull s] returns int of ship [s]'s hp *)
val get_hull : ship -> int

(* [charge_shield s] returns ship [s] with shield charged by one tick *)
val charge_shield : ship -> ship

(*----------------------resources get/set functions----------------*)

(* [get_resources s] returns record of ship [s]'s resources *)
val get_resources : ship -> resources

(* [set_resources s (a, b, c)] returns ship [s] with each element of the triple 
 * [(a,b,c)] added to each respective field of resources *)
val set_resources : ship -> (int * int * int) -> ship

(* [get_fuel s] returns int number of ship [s]'s fuel *)
val get_fuel : ship -> int

(* [set_fuel s i] returns ship [s] with given number of fuel [i] *)
val set_fuel : ship -> int -> ship

(* [get_missiles s] returns int number of ship [s]'s missiles *)
val get_missiles : ship -> int

(* [set_missiles s i] returns ship [s] with given number of missiles [i] *)
val set_missiles : ship -> int -> ship

(* [get_scrap s] returns int number of ship [s]'s scrap *)
val get_scrap : ship -> int

(* [set_scrap s i] returns ship [s] with given number of scrap [i] *)
val set_scrap : ship -> int -> ship

(*----------------------weapon/hull functions----------------------*)

(* [damage s i w] returns ship [s] damaged by specified weapon type [w] and by
 * the specified amount [i] *)
val damage : ship -> int -> weapon_type -> ship

(* [repair_all_hull s] returns ship [s] with hull equal to max_hull and
 * with appropiate scrap deducted *)
val repair_all_hull : ship -> ship

(* [repair_hull s i] returns ship [s] with hull increased by the int given [i]
 * with appropiate scrap deducted *)
val repair_hull : ship -> int -> ship

(* [increase_hull s i] returns ship [s] with max_hull increased by specified 
 * amount [i] *)
val increase_hull : ship -> int -> ship

(* [get_weapon s i] returns [Some weapon] from ship [s]' equipped slot with 
 * given index[i] if no weapon is available, returns [None] *)
val get_weapon : ship -> int -> weapon option

(* [equip s i n] equips the ith weapon from the inventory to the nth slot
 * throws "Illegal inventory index", "Illegal weapon slot"
 * If there is not enough weapon_power then [equip] 
 * returns unchanged ship state *)
val equip : ship -> int -> int -> ship

(* [unequip s i] unequips weapon given slot number [i] from ship [s] and 
 * returns a new modified ship
 * requires: valid ship state, an int between 0 and ship's (weapon_power-1) *)
val unequip : ship -> int -> ship

(* [add_weapon s w] returns ship [s] with added weapon [w] to its inventory *)
val add_weapon : ship -> weapon -> ship

(* [charge_weapons s] returns ship [s] with all equipped weapons charged by 1 *)
val charge_weapons : ship -> ship

(* [weapon_ready s i] returns boolean of whether the ith equipped weapon of ship
 * [s] is ready to fire *)
val weapon_ready : ship -> int -> bool

(* [fire_weapon s i] sets the charge of the ith equipped weapon to 0 of 
 * ship [s] *)
val fire_weapon : ship -> int -> ship

(* [step s] returns ship [s] stepped by one game tick *)
val step : ship -> ship

(*----------------------system functions---------------------------*)

(* [set_shield_power s i] returns ship [s] with specified shield 
 * system power [i]*)
val set_shield_power : ship -> int -> ship

(* [set_engine_power s i] returns ship [s] with specified engine system power 
 * [i] *)
val set_engine_power : ship -> int -> ship

(* [set_weapons_power s i] returns ship [s] with specified weapons system power
 * [i] *)
val set_weapons_power : ship -> int -> ship

(* [set_shield_level s i] returns ship [s] with specified shield system level
 * [i] *)
val set_shield_level : ship -> int -> ship

(* [set_engine_level s i] returns ship [s] with specified engine system level 
 * [i] *)
val set_engine_level : ship -> int -> ship

(* [set_weapons_level s i] returns ship [s] with specified weapons system level 
 * [i] *)
val set_weapons_level : ship -> int -> ship

(* [repair_systems s] restores all systems of ship [s] *)
val repair_systems : ship -> ship

(*----------------------augmentation functions---------------------*)

(* [add_augmentation s a] takes an augmentation [a] and adds it to the ship
 * [s] *)
val add_augmentation : ship -> augmentation -> ship

(* [get_augmentation s i] returns Some (ith augmentation) of ship [s]
 * If wrong index/none available, returns None *)
val get_augmentation : ship -> int -> augmentation option

(*----------------------crew functions-----------------------------*)

(* [get_person s i] returns Some (ith crew member) of ship s
 * If wrong index/none available, returns None *)
val get_person : ship -> int -> person option

(* [add_crew] initiates a random person, adds them to the ship's crew,
 * and applies the person's skills to the ship. *)
val add_crew : ship -> ship

(*----------------------upgrade functions-----------------------------*)

(* [upgrade_engine_level s] returns a ship after attempting to upgrade 
 * engine level of ship [s] by 1
 * returns: updated ship with upgraded weapon level or same ship if 
 * invalid amount of scrap *)
val upgrade_engine_level : ship -> ship

(* [upgrade_shield_level s] returns a ship after attempting to upgrade 
 * shield level of ship [s] by 1
 * returns: updated ship with upgraded weapon level or same ship if invalid 
 * amount of scrap *)
val upgrade_shield_level : ship -> ship

(* [upgrade_weapons_level s] returns a ship after attempting to upgrade 
 * weapon level of ship [s] by 1
 * returns: updated ship with upgraded weapon level or same ship if invalid 
 * amount of scrap *)
val upgrade_weapons_level : ship -> ship