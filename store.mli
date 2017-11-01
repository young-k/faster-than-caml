(* The [Store] represents the store where a user can buy upgrades for their
 * ship. *)
module type Store = sig

  (* [weapon] represents a weapon comprised of fields
     * weapon name, cost, damage, and cool down *)
  type weapon = {
    name : string;
    cost : int;
    damage : int;
    cool_down : int;
  }

  (* [weapons] represents a list of weapons *)
  type weapons = weapon list

  (* [augmentation] represents an augmentation comprised of fields 
   * augmentation name, cost, and description *)
  type augmentation = {
    name : string;
    cost : int;
    description : string;
  }

  (* [augmentations] represents a list of augmentations*)
  type augmentations = augmentation list

  (* [store] contains all weapons and all augmentaitons *)
  type store = {
    weapons : weapons;
    augmentations : augmentations;
  }

  (* [init s] generates weapons and augmentations and returns a store 
   * requires: [s] a ship state *)
  val init : 'a -> store

  (* [get_augmentations s] returns a list of all augmentation
   * requires: [s] a store state *)
  val get_augmentations : store -> augmentations

  (* [get_weapons s] returns a list of all weapons 
   * requires: [s] a store state *)
  val get_weapons : store -> weapons

  (* will change 'a to ship state once implemented *)

  (* [buy s s' i] returns a new ship state after buying an
   * augmentation or weapon
   * requires: [s] a store state, [s'] a valid ship state, 
      [i] an augmentation or weapon name 
   * returns: a new ship state after buying augmentation*)
  val buy : store -> 'a -> string -> 'a

  (* [display (x,y) s s'] returns a string intended to display the store
   * requires: int [x] and [y] that correspond to the width and 
   * height of the user's window, [s] a store state, [s'] a ship state
   * returns: string that is a visual representation of the store *)
  val display : (int * int) -> store -> 'a -> string

end
