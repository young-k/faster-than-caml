open Combat
open Ship
open Galaxy
open Event
open Store

type command =
  | Attack of int
  | Choice of bool
  | Go of int
  | Purchase of string
  | ShowMap
  | ShowStore
  | ShowStartText
  | GoToResting
  | ShowShipConfirm
  | ShowShipScreen
  | ShowHomeScreen
  | ShowInstructions
  | ShowCurrentScreen

type screen_type =
  | HomeScreen
  | Instructions
  | GalaxyScreen of (int * galaxy)
  | StartScreen
  | Resting
  | Event of event
  | Store of store
  | Notification of (Ship.resources * string)
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
  storage: storage;
  score: int;
  jumps: int;
  galaxies: int;
  start_time: float;
}

let init =
  let init_galaxy = Galaxy.init () in
  {
    ship = Ship.init;
    screen_type = HomeScreen;
    star_id = (snd init_galaxy);
    galaxy = (fst init_galaxy);
    storage = None;
    score = 0;
    jumps = 0;
    galaxies = 0;
    start_time = Unix.gettimeofday();
  }

let is_purchase com =
  match com with
  | Purchase _ -> true
  | _ -> false

let parse_command c com =
  if c.jumps >= 7 then 
    let t = "You have been caught by the Federation. Rest in pieces." in
    {c with screen_type=GameOver t}
  else if c.ship.hull <=0 && not (is_purchase com) then 
    let t = "Your ship has been damaged beyond repair and has fallen apart." in
    {c with screen_type=GameOver t}
  else if get_fuel c.ship <=0 && not (is_purchase com) then 
    let t ="You have run out of fuel, with no way to escape the Federation." in
    {c with screen_type=GameOver t}
  else
    match com with
    | ShowHomeScreen -> {c with screen_type=HomeScreen}
    | ShowInstructions -> {c with screen_type=Instructions}
    | ShowMap -> {c with screen_type=GalaxyScreen (c.star_id, c.galaxy)}
    | GoToResting -> {c with screen_type=Resting}
    | ShowStartText -> {c with screen_type=StartScreen}
    | ShowStore ->
      begin
        match c.storage with
        | Store s -> {c with screen_type=Store s}
        | _ -> failwith "No store in controller"
      end
    | Attack ind ->
      (* TODO: Fill in combat logic *)
      {c with screen_type=GalaxyScreen (c.star_id, c.galaxy);}
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
      if star_id=10 then 
        {c with galaxy=fst (Galaxy.init ());
                screen_type=NextGalaxy;
                star_id=1; jumps=(-1); 
                galaxies = c.galaxies+1}
      else
        begin
          match (get_event c.galaxy star_id) with
          | Start ->
            {c with screen_type=Resting; star_id=star_id; jumps=c.jumps+1;
                    ship=(set_resources c.ship (-1,0,0))}
          | Store ->
            let s = Store.init c.ship in
            {c with screen_type=Store s; star_id=star_id; storage=Store s;
                    jumps=c.jumps+1; ship=(set_resources c.ship (-1,0,0))}
          | Event ->
            let e = Event.init () in
            {c with screen_type=Event e; star_id=star_id; storage=Event e;
                    jumps=c.jumps+1; ship=(set_resources c.ship (-1,0,0))}
          | Combat ->
            let combat = Combat.init c.ship () in 
            {c with screen_type=Combat combat; 
                    star_id=star_id; jumps=c.jumps+1;
                    ship=(set_resources c.ship (-1,0,0))}
          | Nothing ->
            {c with screen_type=Nothing;
                    star_id=star_id; jumps=c.jumps+1;
                    ship=(set_resources c.ship (-1,0,0))}
          | End ->
            {c with screen_type=Resting; star_id=star_id; jumps=c.jumps+1;
                    ship=(set_resources c.ship (-1,0,0))}
        end
    | Choice b ->
      begin
        match c.storage with
        | Event e ->
          {c with
           ship = (pick_choice c.ship e b);
           screen_type = Notification ((get_resources e b), (get_followup e b));
           storage = None;}
        | _ -> failwith "No event in controller"
      end
    | ShowShipScreen -> {c with screen_type=ShipScreen}
    | ShowCurrentScreen -> c


let get_display c =
  c.ship, c.screen_type
