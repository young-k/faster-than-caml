open Controller
open Ship
open Galaxy
open Store
open Event

let s_of_i = string_of_int

let skills_to_string (x, y, z) = s_of_i x ^ "." ^ s_of_i y ^ "." ^ s_of_i z

let ship_to_string s = 
  let resources = (s_of_i s.resources.fuel) ^ " " ^ 
    (s_of_i s.resources.missiles) ^ " " ^ (s_of_i s.resources.scrap) in
  let persons = List.fold_left 
    (fun acc (p:person) -> acc ^ p.name ^ "." ^ skills_to_string p.skills ^ "."
        ^ (string_of_int p.hp) ^ ";") 
      "" s.crew in
  let hull = s_of_i s.hull in
  let max_hull = s_of_i s.max_hull in
  let evade = s_of_i s.evade in
  let equipped = List.fold_left (fun acc (w:weapon) -> acc ^ w.name ^ ";") 
    "" s.equipped in
  let shield = s_of_i s.shield.layers ^ " " ^ s_of_i s.shield.charge ^ " " 
    ^ s_of_i s.shield.capacity in
  let inventory = List.fold_left (fun acc (w:weapon) -> acc ^ w.name ^ ";") 
    "" s.inventory in
  let augmentations = List.fold_left (fun acc (a:augmentation) -> acc ^ 
    a.name ^ ";") "" s.augmentations in
  let systems = s_of_i s.systems.shield_level ^ " " ^ 
    s_of_i s.systems.shield_power ^ " " ^ s_of_i s.systems.engine_level ^ " " ^ 
    s_of_i s.systems.engine_power ^ " " ^ s_of_i s.systems.weapons_level ^ " " ^ 
    s_of_i s.systems.weapons_power in
  resources ^ "\n" ^ persons ^ "\n" ^ hull ^ "\n" ^ max_hull ^ "\n" ^ evade ^
    "\n" ^ equipped ^ "\n" ^ shield ^ "\n" ^ inventory ^ "\n" ^ augmentations ^  
    "\n" ^ systems

let store_to_string (s : store) = 
  let weapons = List.fold_left (fun acc (w:weapon) -> acc ^ w.name ^ ".") 
  "" s.weapons in
  let augmentations = List.fold_left (fun acc (a:augmentation) -> acc ^ a.name 
    ^ ".") "" s.augmentations |> String.trim in
  weapons ^ ";" ^ augmentations ^ ";" ^ s_of_i s.fuel ^ ";" ^ s_of_i s.missiles

let event_type_to_string = function
  | Start -> "Start"
  | Store -> "Store"
  | Nothing -> "Nothing"
  | Event -> "Event"
  | Combat -> "Combat"
  | End -> "End"

let galaxy_to_string g =
  let reachable_to_string r = List.fold_right (fun i acc -> acc ^ " " ^ s_of_i 
    i) (List.rev r) "" in
  let lst = List.map (fun s -> s_of_i s.id ^ " " ^ event_type_to_string s.event 
    ^ reachable_to_string s.reachable) g in
  List.fold_left (fun acc x -> acc ^ x ^ ";") "" lst

let screen_type_to_string = function
  | HomeScreen -> "HomeScreen"
  | Instructions -> "Instructions"
  | GalaxyScreen (i, g) -> "GalaxyScreen " ^ galaxy_to_string g
  | StartScreen -> "StartScreem"
  | Resting -> "Resting"
  | Event e -> "Event " ^ e.name
  | Store s -> "Store " ^ store_to_string s
  | Notification (r, s) -> "Notification " ^ s_of_i r.fuel ^ " " ^ s_of_i 
                            r.missiles ^ " " ^ s_of_i r.scrap ^ " " ^ s
  | ShipConfirm -> "ShipConfirm"
  | ShipScreen -> "ShipScreen"
  | NextGalaxy -> "NextGalaxy"
  | GameOver s -> "GameOver " ^ s
  | Combat c -> "Combat"
  | Nothing -> "Nothing"

let storage_to_string (s : storage) =
  match s with
  | Event e -> "Event " ^ e.name
  | Store s -> "Store " ^ store_to_string s
  | None -> "None"

let controller_to_string c =
  let ship = ship_to_string c.ship in
  let screen_type = screen_type_to_string c.screen_type in
  let star_id = s_of_i c.star_id in
  let galaxy = galaxy_to_string c.galaxy in
  let storage = storage_to_string c.storage in
  let score = s_of_i c.score in
  let jumps = s_of_i c.jumps in
  let galaxies = s_of_i c.galaxies in
  let start_time = string_of_float c.start_time in
    ship ^ "\n" ^ screen_type ^ "\n" ^ star_id ^ "\n" ^ galaxy ^ "\n" ^ 
    storage ^ "\n" ^ score ^ "\n" ^ jumps ^ "\n" ^ galaxies ^ "\n" ^ start_time

let save_game c = try
  let ch = open_out "./game_data/save.txt" in
  let str = controller_to_string c in
  output_string ch str; flush ch;
  with _ -> failwith "Core game data missing: save.txt"

let i_of_s = int_of_string

let load_file =
  let ic = open_in "./game_data/save.txt"  in
  let n = in_channel_length ic in
  let s = Bytes.create n in
  really_input ic s 0 n; close_in ic;
  (Bytes.to_string s) |> String.split_on_char '\n'

let all_weapons = 
  let strs = Parser.get_lines_from_f "./game_data/weapons.txt" 20 in
  List.map (fun s -> parse_weapon s) strs

let all_augmentations = 
  let strs = Parser.get_lines_from_f "./game_data/augmentations.txt" 20 in
  List.map (fun s -> parse_augmentation s) strs

let get_ship lst = 
  let resources = 
    let r = List.nth lst 0 |> String.split_on_char ' ' |> 
            List.map (fun s -> int_of_string s) in
    {fuel = List.nth r 0; missiles = List.nth r 1; scrap = List.nth r 2} in
  let crew = 
    List.nth lst 1 |> String.split_on_char ';' |> 
    List.filter (fun s -> s <> "") |>
      List.map 
      (fun person -> let p_fields = String.split_on_char '.' person in
        {
          name = List.nth p_fields 0;
          skills = (List.nth p_fields 1 |> int_of_string, 
                    List.nth p_fields 2 |> int_of_string,
                    List.nth p_fields 3 |> int_of_string);
          hp = List.nth p_fields 4 |> int_of_string
        }
      ) in
  let hull = List.nth lst 2 |> int_of_string in
  let max_hull = List.nth lst 3 |> int_of_string in
  let evade = List.nth lst 4 |> int_of_string in
  let equipped = 
    let e = List.nth lst 5 |> String.split_on_char ';' 
      |> List.filter (fun s -> s <> "") in
      List.filter (fun (a:weapon) -> List.mem a.name e) all_weapons in
  let shield = 
    let s = List.nth lst 6 |> String.split_on_char ' ' |> 
            List.map (fun i -> int_of_string i) in
    {layers = List.nth s 0; charge = List.nth s 1; capacity = List.nth s 2} in
  let inventory = 
    let i = List.nth lst 7 |> String.split_on_char ';' |> 
      List.filter (fun s -> s <> "") in
      List.filter (fun (a:weapon) -> List.mem a.name i) all_weapons in 
  let augmentations = 
    let a = List.nth lst 8 |> String.split_on_char ';' |> 
      List.filter (fun s -> s <> "") in
      List.filter (fun (g:augmentation) -> List.mem g.name a) all_augmentations 
      in
  let systems = 
    let s = List.nth lst 9 |> String.split_on_char ' ' |>
            List.map (fun i -> int_of_string i) in
    {shield_level = List.nth s 0; shield_power = List.nth s 1;
      engine_level = List.nth s 2; engine_power = List.nth s 3;
      weapons_level = List.nth s 4; weapons_power = List.nth s 5} in
  let ship = 
    {
      resources = resources;
      crew = crew;
      hull = hull;
      max_hull = max_hull;
      evade = evade;
      equipped = equipped;
      shield = shield;
      inventory = inventory;
      augmentations = augmentations;
      systems = systems;
    } in
  List.fold_left 
    (fun ship a -> 
      match a.aug_type with
      | Damage | CoolDown -> apply_augmentation ship a
      | _ -> ship
    ) ship augmentations

  let all_events = 
    let lines = (Parser.get_lines_from_f "./game_data/events.txt" 30) in
    List.map 
    (fun h -> 
      match (String.split_on_char ';' h) with
      | a::b::c::d::e::f::g::h::i::j::k::[] ->
        let d = int_of_string d in
        let e = int_of_string e in
        let f = int_of_string f in
        let i = int_of_string i in
        let j = int_of_string j in
        let k = int_of_string k in
        let delt1 = {fuel=d; missiles=e; scrap=f} in
        let delt2 = {fuel=i; missiles=j; scrap=k} in
        let choice1 = {description=b; delta_resources=delt1; follow_up=c} in
        let choice2 = {description=g; delta_resources=delt2; follow_up=h} in
        {name=a; fst_choice=choice1; snd_choice=choice2}
      | _ -> failwith "Incorrect format for event"
    ) lines

  let string_to_event_type = function
    | "Start" -> Start
    | "Store" -> Store
    | "Nothing" -> Nothing
    | "Event" -> Event
    | "Combat" -> Combat
    | "End" -> End
    | _ -> failwith "Invalid event_type string"

  let string_to_galaxy s =
    let g = String.split_on_char ';' s |> List.filter (fun s -> s <> "") in
    List.map 
      (fun b -> 
        let star = String.split_on_char ' ' b in
        {
          id = List.nth star 0 |> i_of_s;
          event = List.nth star 1 |> string_to_event_type;
          reachable = 
            if List.length star > 2 
              then List.tl star |> List.tl |> List.map (fun t -> i_of_s t)
            else []
        }
      ) g
  
  let string_to_store s = 
    let st = String.split_on_char ';' s in
    let weapons = 
      let w = List.nth st 0 |> String.split_on_char '.' |> 
        List.filter (fun s -> s <> "") in
        List.filter (fun (a:weapon) -> List.mem a.name w) all_weapons in
    let augmentations = 
      let a = List.nth st 1 |> String.split_on_char '.' |> 
        List.filter (fun s -> s <> "") in
        List.filter (fun (g:augmentation) -> List.mem g.name a) 
          all_augmentations in
    {
      weapons = weapons;
      augmentations = augmentations;
      fuel = List.nth st 2 |> i_of_s;
      missiles = List.nth st 3 |> i_of_s;
    }

  let string_to_screen_type lst =
    let s = List.nth lst 10 |> String.split_on_char ' ' in
    match List.hd s with
    | "HomeScreen" -> HomeScreen
    | "Instructions" -> Instructions
    | "GalaxyScreen" -> 
      let str = List.nth lst 10 in
      let gstr = String.sub str 13 ((String.length str) - 13) in
      GalaxyScreen (List.nth lst 11 |> i_of_s, string_to_galaxy gstr)
    | "StartScreen" -> StartScreen
    | "Event" -> 
      let e_name = List.tl s |> List.fold_left (fun acc s -> acc ^ s ^ " ") "" 
        |> String.trim in
      Event ((List.find (fun e -> e.name = e_name)) all_events)
    | "Store" -> 
      let str = List.nth lst 10 in
      let store = String.sub str 6 ((String.length str) - 6) in
      Store (string_to_store store)
    | "Notification" -> Notification ({fuel = List.nth s 1 |> i_of_s; 
                                       missiles = List.nth s 2 |> i_of_s;
                                       scrap = List.nth s 3 |> i_of_s}, 
                                       List.nth s 4)
    | "ShipConfirm" -> ShipConfirm
    | "ShipScreen" -> ShipScreen
    | "NextGalaxy" -> NextGalaxy
    | "GameOver" -> GameOver (List.nth s 1)
    | "Nothing"-> Nothing
    | _ -> Resting
  
  let string_to_storage lst : storage =
    let s = List.nth lst 13 |> String.split_on_char ' ' in
    match List.hd s with
    | "Event" -> 
      let e_name = List.tl s |> List.fold_left (fun acc s -> acc ^ s ^ " ") "" 
        |> String.trim in
      Event ((List.find (fun e -> e.name = e_name)) all_events)
    | "Store" -> 
      let str = List.nth lst 13 in
      let store = String.sub str 6 ((String.length str) - 6) in
      Store (string_to_store store)
    | "None" -> None
    | _ -> failwith "Invalid storage string"

let load_controller lst =
  {
    ship = get_ship lst;
    screen_type = string_to_screen_type lst;
    star_id = List.nth lst 11 |> i_of_s;
    galaxy = List.nth lst 12 |> string_to_galaxy;
    storage = string_to_storage lst;
    score = List.nth lst 14 |> i_of_s;
    jumps = List.nth lst 15 |> i_of_s;
    galaxies = List.nth lst 16 |> i_of_s;
    start_time = List.nth lst 17 |> float_of_string;
  }

let load_game = fun () -> load_controller load_file

