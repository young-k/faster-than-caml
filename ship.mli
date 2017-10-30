(* [Ship] contains all data and methods of the player's ship *)
module type Ship = sig

  (* [weapon] represents (weapon name, charge, charge time, damage, type) *)
  type weapon = (string*int*int*int*int)
  (* [crew] represents (name, weapon skills, engine skills, shield skills) *)
  type person = (string*int*int*int)

  (* [ship] represents the state of the player's ship *)
  type ship = {
    (* [resources] is (fuel, missiles, scrap) *)
    resources : int*int*int;
    (* [crew] is the list of crew members *)
    crew : person list;
    (* [hull] the ship's hp, max hull = 30 *)
    hull : int;
    (* [evade] the ship's evade, 0 <= evade <= 100 *)
    evade : int;
    (* [weapons] list of weapons *)
    (* TODO: swap order of weapons *)
    (* TODO: implement different types of weapons
     * e.g. 0 = ion, 1 = beam *)
    weapons : weapon list;
    (* [location] id of ship's current location *)
    location : string;
    (* [shield] is (current shield level, charge time)
     * current shield level = # active shields * charge time + stored charges
     * current shield level <= shield power * charge time*)
    shield : (int*int);


    (* TODO for engine/power features
    (* [power] total power *)
    power : int;
    (* [system_levels] are the max power each system can have
     * can be upgraded *)
    system_levels : (int*int*int);
    (* [system_power] power distrubuted to each system
     * requires sum of all system_power <= power AND
     * each system power <= system level
     * tentative: (shield, engine, weapons) *)
    system_powers : (int*int*int);
    *)
  }

  (* initiates ship *)
  val init : ship

  (* returns string id of location *)
  val get_location : ship -> string

  (* requires [str] is valid location id
   * returns new ship *)
  val set_location : ship -> string -> ship

  (* returns tuple of ship resources *)
  val get_resources : ship -> (int*int*int)

  (* requires [delta] to be tuple of val changes in resources
   * returns new ship *)
  val set_resources : ship -> (int*int*int) -> ship

  (* returns t/f for evasion based on ship stats*)
  val evade : ship -> bool

  (* returns [ship]'s hull *)
  val get_hull : ship -> int

  (* returns ship with shield/hull reduced by specified amount
   * calls evade *)
  val damage : ship -> int -> ship

  (* returns ship with hull increased by specified amount *)
  val repair : ship -> int -> ship

  (* returns damage of [i]th weapon
   * if [i] is out of bounds, return 0 *)
  val weapon_dmg : ship -> int -> int

  (* TODO: system features
  (* upgrades [i]th system, expends scraps *)
  val upgrade_system : ship -> int -> ship

  (* upgrades total power, expends scraps *)
  val upgrade_power : ship -> ship

  (* damages [i]th system. calls damage *)
  val damage_system : ship -> int -> ship

  (* repairs [i]th system. calls repair *)
  val repair_system : ship -> int -> ship
  *)
end
