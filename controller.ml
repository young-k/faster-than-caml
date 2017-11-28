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
  | Power of string
  | Purchase of string
  | ShowMap
  | ShowStartText
  | CloseStartText

type screen_type =
  | HomeScreen
  | Galaxy of (int * galaxy)
  | StartScreen
  | Resting
  | Event of event
  | Store of store

type storage =
  | Event of event
  | Store of store
  | None

type controller = {
  ship: ship;
  screen_type: screen_type;
  star: int;
  galaxy: galaxy;
  storage: storage;
}

let init =
  let init_galaxy = Galaxy.init in
  {
    ship=Ship.init;
    screen_type=HomeScreen;
    star=(snd init_galaxy);
    galaxy=(fst init_galaxy);
    storage=None;
  }

let parse_command c com =
  match com with
  | ShowMap -> {c with screen_type=Galaxy (c.star, c.galaxy)}
  | CloseMap -> {c with screen_type=Resting}
  | ShowStartText -> {c with screen_type=StartScreen}
  | _ -> failwith "Unimplemented"


let get_display c =
  c.ship, c.screen_type
