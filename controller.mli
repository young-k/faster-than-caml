(* Controller acts as the intermediary between the UI and our other modules *)
open Ship
open Galaxy
open Event
open Store
open Combat

type command =
  | Choice of bool            (* Choosing an option (y/n) for events *)
  | Go of int                 (* Go to another star *)
  | Purchase of string        (* Purchase an item from a store *)
  | ShowMap                   (* Displays the map *)
  | ShowStore                 (* Displays a store *) 
  | ShowStartText             (* Shows start text *)
  | GoToResting               (* Go to resting screen *)
  | ShowShipConfirm           (* Confirmation screen for store purchases *)
  | ShowShipScreen            (* Screen for details on ship & ship upgrades *)
  | ShowHomeScreen            (* Show home screen *)
  | ShowInstructions          (* Show instructions screen *)
  | ShowCurrentScreen         (* Shows the current screen of a controller *)
  | SaveShip of ship          (* Save ship; post-combat *)

(* screen_type contains information about what to display on UI *)
type screen_type =
  | HomeScreen
  | Instructions
  | GalaxyScreen of (int * galaxy) (* star, galaxy *)
  | StartScreen
  | Resting
  | Event of event
  | Store of store
  | Notification of (Ship.resources * string) (* string is follow_up desc *)
  | ShipConfirm
  | ShipScreen
  | NextGalaxy
  | GameOver of string
  | Combat of combat_event
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
  galaxies: int;    (* number of galaxies player has reached *)
  start_time: float;(* starting time of game in seconds. For game ticks*)
}

(* [init] generates a controller *)
val init: unit -> controller

(* [parse_command c com] is the resulting controller after parsing a command
   and applying the results. *)
val parse_command: controller -> command -> controller

(* [get_display c] is a tuple containing a ship state and a screen_type to
   display on the UI. *)
val get_display: controller -> (ship * screen_type)
