open Ship
open Galaxy
open Event
open Store

type command =
  | Attack of (int * string)
  | Choice of bool
  | Equip of (string * int)
  | Go of int
  | Power of string
  | Purchase of string
  | ShowMap
  | ShowStore
  | ShowStartText
  | GoToResting
  | ShowShipConfirm
  | ShowShipScreen
  | ShowHomeScreen
  | ShowInstructions

type screen_type =
  | HomeScreen
  | Instructions
  | GalaxyScreen of (int * galaxy)
  | StartScreen
  | Resting
  | Event of event
  | Store of store
  | Notification of Ship.resources
  | ShipConfirm
  | ShipScreen
  | NextGalaxy
  | GameOver of string

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
  score: int;
  jumps: int;
  start_time: float;
}

let init =
  let init_galaxy = Galaxy.init in
  {
    ship = Ship.init;
    screen_type = HomeScreen;
    star_id = (snd init_galaxy);
    galaxy = (fst init_galaxy);
    storage = None;
    score = 0;
    jumps = 0;
    start_time = Unix.gettimeofday();
  }

let parse_command c com =
  if c.jumps >= 7 then {c with screen_type=
    GameOver "You have been caught by the federation. Rest in pieces."}
  else if c.ship.hull <=0 then {c with screen_type=
    GameOver "Your ship has been damaged beyond repair and has fallen apart."}
  else if get_fuel c.ship <=0 then {c with screen_type=
    GameOver "You have run out of fuel, with no way to escape the federation."}
  else
  match com with
  | ShowHomeScreen -> {c with screen_type=HomeScreen}
  | ShowInstructions -> {c with screen_type=Instructions}
  | ShowMap -> {c with screen_type=GalaxyScreen (c.star_id, c.galaxy)}
  | GoToResting -> {c with screen_type=Resting}
  | ShowStartText -> {c with screen_type=StartScreen}
  | ShowStore ->
    begin
    (match c.storage with
      | Store s -> {c with screen_type=Store s}
      | _ -> failwith "No store in controller"
    )
    end
  | Purchase s ->
    begin
    (match c.storage with
      | Store st ->
        let f_count = if s = "Fuel" then 1 else 0 in
        let m_count = if s = "Missile" then 1 else 0 in
        let store = if (can_buy st c.ship s) then 
        {
            augmentations = List.filter (fun (a : augmentation) -> a.name <> s)
              st.augmentations;
            weapons = List.filter (fun (w : weapon) -> w.name <> s) st.weapons;
            missiles = st.missiles - m_count;
            fuel = st.fuel - f_count;
        } else st in
        let new_ship = Store.buy st c.ship s in
        let pts = (get_scrap c.ship) - (get_scrap new_ship) in 
        {c with ship = new_ship;screen_type=Store store;score=c.score+pts}
      | _ -> failwith "No store in controller"
    )
    end
  | ShowShipConfirm -> {c with screen_type=ShipConfirm}
  | Go star_id ->
    if star_id = 10 then {c with galaxy=fst Galaxy.init;screen_type=NextGalaxy; 
      star_id=1; jumps=c.jumps+1; ship = (set_resources c.ship (-1,0,0))}
    else  
    begin
      match (get_event c.galaxy star_id) with
      | Store ->
        print_endline (string_of_int star_id);
        let s = Store.init c.ship in
        {c with screen_type=Store s; star_id=star_id; storage=Store s;
          jumps = c.jumps+1; ship = (set_resources c.ship (-1,0,0))}
      | Event ->
        let e = Event.init in
        {c with screen_type=Event e; star_id=star_id; storage=Event e;
          jumps = c.jumps+1; ship = (set_resources c.ship (-1,0,0))}
      | _ -> {c with screen_type=Resting; star_id=star_id; jumps = c.jumps+1; 
        ship = (set_resources c.ship (-1,0,0))}
    end
  | Choice b ->
    begin
    (match c.storage with
      | Event e -> {c with ship = (pick_choice c.ship e b);
          screen_type = Notification (choice_resources e b); storage = None}
      | _ -> failwith "No event in controller"
    )
    end
  | ShowShipScreen -> {c with screen_type=ShipScreen}
  | _ -> failwith "Unimplemented"


let get_display c =
  c.ship, c.screen_type
