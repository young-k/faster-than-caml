open Ship
(* [Event] contains all data and methods of randomly generated events *)
module type Event = sig

  (* [choice] contains (description, resource effects, next)*)
  type choice = {
    description: string;
    resource: (int * int * int);
    next: event} and 
  (* [event] is either a choice or an ending outcome *)
  event =
    | Choice of choice * choice
    | End of string * (int * int * int)
  
  (* [init] randomly generates event tree from game data *)
  val init : event

  (* [traverse] apply consequences of given choice and return *)
  val traverse: ship -> event -> bool -> ship

  (* [get_desciption] returns the string description of event choice *)
  val get_description : event -> bool -> string

  (* [event] get next event *)
  val next: event -> bool -> event
end
