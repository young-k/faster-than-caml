(* Controller acts as the intermediary between the UI and our other modules *)
open Ship
open Galaxy
open Event
open Store

type command =
  | Attack of int             (* Choose a weapon in slot to attack a room *)
  | Choice of bool            (* Choosing an option (y/n) for events *)
  | Equip of (string * int)   (* Equip a weapon to a certain slot *)
  | Go of int                 (* Go to another star *)
  | Power of string           (* Get the power level of a system *)
  | Purchase of string        (* Purchase an item from a store *)
  | ShowMap                   (* Displays the map *)
  | ShowStore                 (* Displays a store *) 
  | ShowStartText             (* Shows start text *)
  | GoToResting               (* Go to resting screen *)
  | ShowShipConfirm           (* Confirmation screen for store purchases *)
  | ShowShipScreen            (* Screen for details on ship & ship upgrades *)
  | ShowHomeScreen            (* Show home screen *)
  | ShowInstructions          (* Show instructions screen *)
  | ShowCombat                (* Show combat screen *) 

(* screen_type contains information about what to display on UI *)
type screen_type =
  | HomeScreen
  | Instructions
  | GalaxyScreen of (int * galaxy) (* star, galaxy *)
  | StartScreen
  | Resting
  | Event of event
  | Store of store
  | Notification of Ship.resources
  | ShipConfirm
  | ShipScreen
  | NextGalaxy
  | GameOver of string
  | Combat
  | Nothing

type storage =
  | Event of event
  | Store of store
  | None

type controller = {
  ship: ship;
  screen_type: screen_type;
  star_id: int;
  galaxy: galaxy;
  storage: storage; (* storing either an event or a store *)
  score: int;       (* score is the sum of scrap spent and damage dealt *)
  jumps: int;       (* number of jumps player has made so far *)
  start_time: float;(* starting time of game in seconds. For game ticks*)
}

(* [init] generates a controller *)
val init: controller

(* [parse_command c com] is the resulting controller after parsing a command
   and applying the results. *)
val parse_command: controller -> command -> controller

(* [get_display c] is a tuple containing a ship state and a screen_type to
   display on the UI. *)
val get_display: controller -> (ship * screen_type)
