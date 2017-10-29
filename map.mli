(* A [Map] represents a map of a specific galaxy *)
module type Map = sig

  (* [event_type] is the different type of events that each point in the
   * galaxy could have *)
  type event_type = Store | Nothing | Event | Combat | End

  (* [star] is a tuple (id, event) where id is the star's id and event
   * is the event_type that this star contains *)
  type star = (int * event_type)

  (* [map] is a star list that contains all the stars in this specific
   * galaxy *)
  type map = star list

  (* [init a] generates random stars based on an id system [a]
   * requires: id system of type int 
   * returns: generated map and the start id of the star the user starts on *)
  val init: int -> (map * int)

  (* [reachable a] returns all reachable stars with their event from a current
   * star with id [a]. 
   * requires: map and valid star id of type int 
   * returns: list of (event_type option, int) where event_type is None if
   * it is not a store or end since this is used for display, and its
   * corresponding int is the star id *)
  val reachable: map -> int -> ((event_type option) * int) list

  (* [get_event a] returns the event of a given star id [a]
   * requires: map and valid star id of type int 
   * returns: the event_type of the star *)
  val get_event: map -> int -> event_type

  (* [get_end a] returns the last star given a map
   * requires: map
   * returns: the id of the last star *)
  val get_end: map -> int

end
