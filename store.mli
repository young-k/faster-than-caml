(* The [Store] represents the store where a user can buy upgrades for their
 * ship. *)

(* [weapon_type] represents the type of a ship's weapon *)
type weapon_type = Ship.weapon_type

(* [weapon] represents a ship's weapon *)
type weapon = Ship.weapon

(* [augmentation] represents a ship's augmentation *)
type augmentation = Ship.augmentation

(* [store] contains all weapons and all augmentations availalbe to buy *)
type store = {
  weapons : weapon list;
  augmentations : augmentation list;
}

(* [init s] generates weapons and augmentations from a .txt file
 * and returns a store without weapons and augmentations that the given ship
 * state already has
 * requires: [s] a ship state *)
val init : Ship.ship -> store

(* [get_augmentations s] returns a list of all augmentation of a store
  * requires: [s] a store state *)
val get_augmentations : store -> augmentation list

(* [get_weapons s] returns a list of all weapons of a store
  * requires: [s] a store state *)
val get_weapons : store -> weapon list

(* [buy s s' i] returns a new ship state after buying an
  * augmentation or weapon
  * requires: [s] a store state, [s'] a valid ship state,
    [i] an augmentation or weapon name
  * returns: a new ship state after buying augmentation*)
val buy : store -> Ship.ship -> string -> Ship.ship

(* [display (x,y) s s'] returns a string intended to display the store
  * requires: int [x] and [y] that correspond to the width and
  * height of the user's window, [s] a store state, [s'] a ship state
  * returns: string that is a visual representation of the store *)
val display : (int * int) -> store -> Ship.ship -> string
