open Ship
open Galaxy
open Event
open Store

type command =
  | Attack of (int * string)
  | Choice of bool
  | CloseMap
  | Equip of (string * int)
  | Go of int
  | Look
  | Power of string
  | Purchase of string
  | ShowMap
  | None

type screen_type =
  | HomeScreen
  | Galaxy of (int * galaxy)
  | StartScreen
  | Resting
  | Event of event
  | Store of store

type controller = {
  ship: ship;
  screen_type: screen_type;
  star: int;
  galaxy: galaxy;
  event: event option;
}

let init =
  let init_galaxy = Galaxy.init in
  {
    ship=Ship.init;
    screen_type=HomeScreen;
    star=(snd init_galaxy);
    galaxy=(fst init_galaxy);
    event=None;
  }

let parse_command c com =
  failwith "Unimplemented"

let get_display c =
  failwith "Unimplemented"
