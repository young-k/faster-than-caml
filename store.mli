(* The [Store] represents the store where a user can buy upgrades for their
 * ship. *)
module type Store = sig

    (* [weapons] represents a list of weapons comprised of a tuple with
     * (weapon name, cost) *)
    type weapons = (string * int) list

    (* [augmentations] represents a list of augmentations comprised of a tuple 
     * with (augmentation name, cost) *)
    type augmentations = (string * int) list

    (* [store] contains all weapons and all augmentaitons *)
    type store = {
        weapons: weapons;
        augmentations: augmentations;
    }

    (* [init] generates weapons and augmentations and returns a store *)
    val init: store

    (* [get_augmentations s] returns a list of all augmentation
     * requires: [s] a store state *)
    val get_augmentations: store -> augmentations

    (* [get_weapons s] returns a list of all weapons 
     * requires: [s] a store state *)
    val get_weapons: store -> weapons

    (* will change 'a to ship state once implemented *)
    
    (* [buy_augmentations s s' i] returns a new ship state after buying an
     * augmentation
     * requires: [s] a store state, [s'] a valid ship state, 
        [i] an augmentation name 
     * returns: a new ship state after buying augmentation*)
    val buy_augmentations: store -> 'a -> string -> 'a

    (* [buy_weapons s s' i] returns a new ship state after buying a weapon
     * requires: [s] a store state, [s'] a valid ship state, 
        [i] a weapon name 
     * returns: a new ship state after buying augmentation*)
    val buy_weapons: store -> 'a -> string -> 'a

end