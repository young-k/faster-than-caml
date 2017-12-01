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
  | ShowStore
  | ShowStartText
  | CloseStartText

type screen_type =
  | HomeScreen
  | GalaxyScreen of (int * galaxy)
  | StartScreen
  | Resting
  | Event of event
  | Store of store
  | Debug

type storage =
  | Event of event
  | Store of store
  | None

type controller = {
  ship: ship;
  screen_type: screen_type;
  star_id: int;
  galaxy: galaxy;
  storage: storage;
}

let init =
  let init_galaxy = Galaxy.init in
  {
    ship=Ship.init;
    screen_type=HomeScreen;
    star_id=(snd init_galaxy);
    galaxy=(fst init_galaxy);
    storage=None;
  }

let parse_command c com =
  match com with
  | ShowMap -> {c with screen_type=GalaxyScreen (c.star_id, c.galaxy)}
  | CloseMap -> {c with screen_type=Resting}
  | ShowStartText -> {c with screen_type=StartScreen}
  | ShowStore -> 
    (match c.storage with
      | Store s -> {c with screen_type=Store s}
      | _ -> failwith "No store in controller"
    )
  | Purchase s -> 
    (match c.storage with
      | Store st -> {c with ship=(buy st c.ship s); screen_type=Debug}
      | _ -> failwith "No store in controller"
    )
  | Go star_id -> {c with screen_type=Resting; star_id=star_id} (* TEMP *)
  | Choice b -> 
    (match c.storage with
      | Event e -> {c with ship = (pick_choice c.ship e b); 
          screen_type = Resting; storage = None}
      | _ -> failwith "No event in controller"
    )
  | _ -> failwith "Unimplemented"


let get_display c =
  c.ship, c.screen_type
