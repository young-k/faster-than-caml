(* The [Galaxy] represents a galaxy that is made up of stars each corresponding
 * to an event that a user can encounter. *)

(* [event_type] is the different type of events that each point in the
 * galaxy could have *)
type event_type = Start | Store | Nothing | Event | Combat | End

(* [star] has fields [id], [event], [reachable] where [id] is the star's id, 
 * [event] is the [event_type] that this star contains, and [reachable] is a 
 * list of all reachable star ids  *)
type star = {
  id : int;
  event : event_type;
  reachable : int list;
}

(* [galaxy] is a star list that contains all the stars in this specific
 * galaxy *)
type galaxy = star list

(* [init ()] returns the generated map and the start id of the star the 
 * user starts on *)
val init : unit -> (galaxy * int)

(* [reachable g a] returns all reachable stars with their event from a current
 * star with id [a] in galaxy [g]
 * requires: galaxy [g] and valid star id of type int [a]
 * returns: list of (event_type option, int) where event_type is None if
 * it is not a store or end since this is used for display, and its
 * corresponding int is the star id *)
val reachable : galaxy -> int -> ((event_type option) * int) list

(* [get_event g a] returns the event of a given star id [a] in galaxy [g]
 * requires: galaxy [g] and valid star id of type int [a]
 * returns: the event_type of the star with id [a] in [g] *)
val get_event : galaxy -> int -> event_type

(* [get_end a] returns the last star in a galaxy [a]
 * requires: galaxy [a]
 * returns: the id of the last star *)
val get_end : galaxy -> int
