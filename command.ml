open Map
(* [command] represents a command input by a player. *)

type action =
  | Go        (* Go to another star *)
  | Move      (* Move a crew member to a room *)
  | Look      (* Look at reachable stars *)
  | Attack    (* Attack a room (of enemy ship) using a weapon *)
  | Charge    (* Charge a system *)
  | Decharge  (* Decharge a system *)
  | Power     (* Get the power level of a system *)
  | Locations (* Get locations of crew members *)
  | Inspect   (* Inspect the state of enemy ship *)
  | Pause     (* Pause the game *)
  | Unpause   (* Unpause the game *)
  | Hull      (* Get the current hull of your ship *)
  | State     (* Get state of ship *)
  | Scrap     (* Get the number of current scrap *)
  | Fuel      (* Get the ship's fuel *)
  | Missiles  (* Get the number of available missiles *)
  | Shield    (* Get the ship's shield vitals *)
  | Evasion   (* Get the current evasion level *)
  | Oxygen    (* Get the current oxygen level *)
  | HP        (* Get the hp of a crew member *)
  | Purchase  (* Purchase an item from a store *)
  | None

type obj =
  | Star of star                      (* Go *)
  | Crew_Room of (person * string)    (* Move *)
  | Room_Weapon of (string * weapon)  (* Attack *)
  | System of string                  (* Charge, Decharge, Power *)
  | None

type command = {
  action : action;
  obj : obj;
}


(* [parse str] is the command that represents player input [str].
 * requires: [str] represents a valid command *)
let parse str = failwith "Unimplemented"
