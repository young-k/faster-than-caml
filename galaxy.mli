(* The [Galaxy] represents a galaxy that is made up of stars each corresponding
 * to an event that a user can encounter. *)

(* [event_type] is the different type of events that each point in the
 * galaxy could have *)
type event_type = Store | Nothing | Event | Combat | End

(* [star] has fields [id], [event], [reachable] where [id] is the star's id, 
 * [event] is the [event_type] that this star contains, and [reachable] is a 
 * list of all reachable star ids  *)
type star = {
  id : int;
  event : event_type;
  reachable : int list;
}

(* [map] is a star list that contains all the stars in this specific
 * galaxy *)
type map = star list

(* [init a] generates random stars based on an id system [a]
 * returns: generated map and the start id of the star the user starts on *)
val init : (map * int)

(* [reachable a] returns all reachable stars with their event from a current
 * star with id [a]. 
 * requires: map and valid star id of type int 
 * returns: list of (event_type option, int) where event_type is None if
 * it is not a store or end since this is used for display, and its
 * corresponding int is the star id *)
val reachable : map -> int -> ((event_type option) * int) list

(* [get_event a] returns the event of a given star id [a]
 * requires: map and valid star id of type int 
 * returns: the event_type of the star *)
val get_event : map -> int -> event_type

(* [get_end a] returns the last star given a map
 * requires: map
 * returns: the id of the last star *)
val get_end : map -> int

(* [display (x,y) m] returns a string intended to display the map
 * requires: int [x] and [y] that correspond to the width and height of the 
 * user's window, a map [m]
 * returns: string that is a visual representation of the map *)
val display : (int * int) -> map -> string

