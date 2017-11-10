open Ship
open Event
open Galaxy
open Store

(* [command] represents a command input by a player. *)

type command =
  | Attack of (int * string)  (* Choose a weapon in slot to attack a room *)
  | Choice of bool            (* Choosing an option (y/n) for events *)
  | CloseMap                  (* Gets rid of the display of the map *)
  | Equip of (string * int)   (* Equip a weapon to a certain slot *)
  | Go of int                 (* Go to another star *)
  | Look                      (* Look at reachable stars *)
  | Power of string           (* Get the power level of a system *)
  | Purchase of string        (* Purchase an item (weapon/augmentation) from a store *)
  | ShowMap                   (* Displays the map *)
  | None


(* [parse str] is the command that represents player input [str].
 * requires: [str] represents a valid command *)
let parse str = failwith "Unimplemented"
