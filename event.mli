open Ship
module type Event = sig

  (* [choice] contains (description, resource effects, next)*)
  type choice = {
    description: string;
    resource: (int*int*int);
    next: event} and 
  (* [event] is either a choice or an ending outcome *)
  event =
    |Choice of choice*choice
    |End of string*(int*int*int)
  
  (* randomly generates event tree from game data *)
  val init : event

  (* apply consequences of given choice and return *)
  val traverse: ship -> event -> bool -> ship

  (* get next event *)
  val next: event -> bool -> event
end
