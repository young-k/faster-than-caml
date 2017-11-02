open Ship
(* [Event] contains all data and methods of randomly generated events *)
module type Event = sig

  (* [choice] contains (description, resource effects)*)
  type choice = {
    description: string;
    resource: (int * int * int);}
  (* [event] contains (description, choice 1, choice 2) *)
  type event = string * choice * choice

  (* [init] randomly generates event tree from game data *)
  val init : event

  (* [traverse] apply consequences of given choice and return *)
  val pick_choice: ship -> event -> bool -> ship

  (* [choice_description] returns string of choice description *)
  val choice_description : event -> bool -> string

  (* [get_description] returns the string description of event choice *)
  val get_description : event -> bool -> string

end
