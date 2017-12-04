(* The [Store] represents the store where a user can buy upgrades for their
 * ship. *)

(* [store] contains all weapons and all augmentations availalbe to buy *)
type store = {
  weapons : Ship.weapon list;
  augmentations : Ship.augmentation list;
  fuel : int;
  missiles : int;
}

val fuel_cost : int

val missile_cost : int

(* [parse_weapon s] generates a weapon by parsing a string [s] with format
 * "name;cost;damage;capacity;charge;wtype"
 * requires: [s] valid string following format *)
 val parse_weapon : string -> Ship.weapon

(* [parse_augmentations s] generates an augmentation by parsing a string [s]
 * with format "name;cost;aug_type;stat;description"
 * requires: [s] valid string following format *)
val parse_augmentation : string -> Ship.augmentation

(* [init s] generates weapons and augmentations from a .txt file
 * and returns a store without weapons and augmentations that the given ship
 * state already has
 * requires: [s] a ship state *)
val init : Ship.ship -> store

(* [get_augmentations s] returns a list of all augmentation of a store
  * requires: [s] a store state *)
val get_augmentations : store -> Ship.augmentation list

(* [get_weapons s] returns a list of all weapons of a store
  * requires: [s] a store state *)
val get_weapons : store -> Ship.weapon list

(* [apply_augmentation s a] generates a new ship after applying augmentation [a]
 * to ship [s]
 * requires: [s] a ship, [a] an augmentation *)
val apply_augmentation : Ship.ship -> Ship.augmentation -> Ship.ship

(* [buy s s' i] returns a new ship state after buying an
  * augmentation or weapon
  * requires: [s] a store state, [s'] a valid ship state,
    [i] an augmentation or weapon name
  * returns: a new ship state after buying augmentation*)
val buy : store -> Ship.ship -> string -> Ship.ship

(* [can_buy s s' i] returns whether a ship is able to buy the given
  * augmentation or weapon
  * requires: [s] a store state, [s'] a valid ship state,
    [i] an augmentation or weapon name
  * returns: bool corresponding to if ship can buy item *)
val can_buy : store -> Ship.ship -> string -> bool

(* [display (x,y) s s'] returns a string intended to display the store
  * requires: int [x] and [y] that correspond to the width and
  * height of the user's window, [s] a store state, [s'] a ship state
  * returns: string that is a visual representation of the store *)
val display : (int * int) -> store -> Ship.ship -> string
