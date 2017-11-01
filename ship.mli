(* [Ship] contains all data and methods of the player's ship *)
module type Ship = sig

  type weapon_type = Ion | Laser | Beam
  (* [weapon] represents the tuple
   * (weapon name, charge, charge time, damage, type) *)
  type weapon = (string * int * int * int * weapon_type)
  (* [crew] represents the tuple
   * (name, weapon skills, engine skills, shield skills) *)
  type person = (string * int * int * int)

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
    augmentations : string list;
    (* [system_levels] are the max power each system can have
     * can be upgraded *)
    system_levels : (int*int*int);
    (* [system_power] power distrubuted to each system
     * requires sum of all system_power <= power AND
     * each system power <= system level
     * tentative: (shield, engine, weapons) *)
    system_powers : (int*int*int);
    
  }

  (* [init] initiates ship *)
  val init : ship

  (* [get_location] returns int id of location *)
  val get_location : ship -> int

  (* [set_location] returns ship with new location
   * requires [str] is valid location id *)
  val set_location : ship -> int -> ship

  (* [get_resources] returns tuple of ship resources *)
  val get_resources : ship -> (int * int * int)

  (* [set_resources] returns ship with new tuple of resources
   * requires [delta] to be tuple of val changes in resources *)
  val set_resources : ship -> (int * int * int) -> ship

  (* [evade] returns int stat for evasion based on ship stats*)
  val evade : ship -> int

  (* [get_hull] returns [ship]'s hull *)
  val get_hull : ship -> int

  (* [damage] returns ship with shield/hull reduced by specified amount *)
  val damage : ship -> int -> ship

  (* [repair] returns ship with hull increased by specified amount *)
  val repair : ship -> int -> ship

  (* [get_weapon] returns [Some index] of a weapon
   * if no weapon is available, returns [None] *)
  val get_weapon : ship -> int -> weapon option

  (* [upgrade_system] upgrades [i]th system, expends scraps *)
  val upgrade_system : ship -> int -> ship

  (* [damage_system] damages [i]th system. calls damage *)
  val damage_system : ship -> int -> ship

  (* [repair_system] restores all systems. *)
  val repair_system : ship -> ship

  (* [add_augmentation] takes an augmentation name and adds it to the ship *)
  val add_augmentation : ship -> string -> ship
  
end
