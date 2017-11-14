(* Controller acts as the intermediary between the UI and our other modules *)
open Ship
open Galaxy
open Event
open Store
open Command

type screen_type =
  | HomeScreen
  | Galaxy of map
  | StartScreen
  | Resting
  | Event of event
  | Store of store

type controller = {
  ship: ship;
  screen_type: screen_type;
  galaxy: map;
}

(* [init] generates a controller *)
val init: controller

(* [parse_command contr com] is the resulting controller after parsing a command
   and applying the results. *)
val parse_command: controller -> command -> controller

(* [get_display contr] is a tuple containing a ship state and a screen_type to
   display on the UI. *)
val get_display: controller -> (ship * screen_type)
