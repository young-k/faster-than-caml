open Ship
(* [Event] contains all data and methods of randomly generated events *)

(* [choice] contains a description and resource effects *)
type choice = {
  description: string;
  delta_resources: Ship.resources;
}

(* [event] contains a name, choice 1, and choice 2) *)
type event = {
  name: string;
  fst_choice: choice;
  snd_choice: choice
}

(* [init] randomly generates an event from game data *)
val init : event

(* [pick_choice s e b] applies consequences of choice to ship and returns *)
val pick_choice: ship -> event -> bool -> ship

(* [choice_description e b] returns string of choice description *)
val choice_description: event -> bool -> string

(* [get_name e] returns the string name of event *)
val get_name: event -> string
