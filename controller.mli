(* Controller acts as the intermediary between the UI and our other modules *)
open Ship
open Galaxy
open Event
open Store

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

(* screen_type contains information about what to display on UI *)
type screen_type =
  | HomeScreen
  | Galaxy of galaxy
  | StartScreen
  | Resting
  | Event of event
  | Store of store

type controller = {
  ship: ship;
  screen_type: screen_type;
  galaxy: galaxy;
}

(* [init] generates a controller *)
val init: controller

(* [parse_command contr com] is the resulting controller after parsing a command
   and applying the results. *)
val parse_command: controller -> command -> controller

(* [get_display contr] is a tuple containing a ship state and a screen_type to
   display on the UI. *)
val get_display: controller -> (ship * screen_type)
