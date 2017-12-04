open Controller
open Ship
open Galaxy
open Store

type state = controller

let s_of_i = string_of_int

let skills_to_string (x, y, z) = s_of_i x ^ "." ^ s_of_i y ^ "." ^ s_of_i z

let ship_to_string s = 
  let resources = (s_of_i s.resources.fuel) ^ " " ^ 
    (s_of_i s.resources.missiles) ^ " " ^ (s_of_i s.resources.scrap) in
  let persons = List.fold_left 
    (fun acc p -> acc ^ p.name ^ "." ^ skills_to_string p.skills ^ ";") "" 
      s.crew in
  let hull = s_of_i s.hull in
  let max_hull = s_of_i s.max_hull in
  let evade = s_of_i s.evade in
  let equipped = List.fold_left (fun acc (w:weapon) -> acc ^ w.name ^ ";") 
    "" s.equipped in
  let shield = s_of_i s.shield.layers ^ " " ^ s_of_i s.shield.charge ^ " " 
    ^ s_of_i s.shield.capacity in
  let inventory = List.fold_left (fun acc (w:weapon) -> acc ^ w.name ^ ";") 
    "" s.inventory in
  let augmentations = List.fold_left (fun acc (a:augmentation) -> acc ^ a.name ^ ";") 
    "" s.augmentations in
  let systems = s_of_i s.systems.shield_level ^ " " ^ s_of_i s.systems.shield_power ^ " "
    ^ s_of_i s.systems.engine_level ^ " " ^ s_of_i s.systems.engine_power ^ " "
    ^ s_of_i s.systems.weapons_level ^ " " ^ s_of_i s.systems.weapons_power in
  resources ^ "\n" ^ persons ^ "\n" ^ hull ^ "\n" ^ max_hull ^ "\n" ^ evade ^
    "\n" ^ equipped ^ "\n" ^ shield ^ "\n" ^ inventory ^ "\n" ^ augmentations ^  
    "\n" ^ systems

let store_to_string (s : store) = 
  let weapons = List.fold_left (fun acc (w:weapon) -> acc ^ w.name ^ ".") 
  "" s.weapons in
  let augmentations = List.fold_left (fun acc (a:augmentation) -> acc ^ a.name ^ ".") 
  "" s.augmentations |> String.trim in
  weapons ^ ";" ^ augmentations ^ ";" ^ s_of_i s.fuel ^ ";" ^ s_of_i s.missiles

let event_type_to_string = function
  | Start -> "Start"
  | Store -> "Store"
  | Nothing -> "Nothing"
  | Event -> "Event"
  | Combat -> "Combat"
  | End -> "End"

let galaxy_to_string g =
  let reachable_to_string r = List.fold_right (fun i acc -> acc ^ " " ^ s_of_i i) 
    r "" in
  let lst = List.map (fun s -> s_of_i s.id ^ " " ^ event_type_to_string s.event ^ 
    reachable_to_string   s.reachable) g in
  List.fold_left (fun acc x -> acc ^ x ^ ";") "" lst

let screen_type_to_string = function
  | HomeScreen -> "HomeScreen"
  | Instructions -> "Instructions"
  | GalaxyScreen (i, g) -> "GalaxyScreen " ^ s_of_i i ^ " " ^ galaxy_to_string g
  | StartScreen -> "StartScreem"
  | Resting -> "Resting"
  | Event e -> "Event " ^ e.name
  | Store s -> "Store " ^ store_to_string s
  | Notification (r, s) -> "Notification " ^ s_of_i r.fuel ^ " " ^ s_of_i r.missiles
                            ^ " " ^ s_of_i r.scrap ^ " " ^ s
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
  List.map (fun s -> Store.parse_weapon s) strs

let all_augmentations = 
  let strs = Parser.get_lines_from_f "./game_data/augmentations.txt" 20 in
  List.map (fun s -> Store.parse_augmentation s) strs

let get_ship lst = 
  let resources = 
    let r = List.nth lst 0 |> String.split_on_char ' ' |> 
            List.map (fun s -> int_of_string s) in
    {fuel = List.nth r 0; missiles = List.nth r 1; scrap = List.nth r 2} in
  let crew = 
    List.nth lst 1 |> String.split_on_char ';' |>
      List.map 
      (fun person -> let p_fields = String.split_on_char '.' person in
        {
          name = List.nth p_fields 0;
          skills = (List.nth p_fields 1 |> int_of_string, 
                    List.nth p_fields 2 |> int_of_string,
                    List.nth p_fields 3 |> int_of_string)
        }
      ) in
  let hull = List.nth lst 2 |> int_of_string in
  let max_hull = List.nth lst 3 |> int_of_string in
  let evade = List.nth lst 4 |> int_of_string in
  let equipped = 
    let e = List.nth lst 5 |> String.split_on_char ';' in
      List.filter (fun (a:weapon) -> List.mem a.name e) all_weapons in
  let shield = 
    let s = List.nth lst 6 |> String.split_on_char ' ' |> 
            List.map (fun i -> int_of_string i) in
    {layers = List.nth s 0; charge = List.nth s 1; capacity = List.nth s 2} in
  let inventory = 
    let i = List.nth lst 7 |> String.split_on_char ';' in
      List.filter (fun (a:weapon) -> List.mem a.name i) all_weapons in 
  let augmentations = 
    let a = List.nth lst 8 |> String.split_on_char ';' in
      List.filter (fun (g:augmentation) -> List.mem g.name a) all_augmentations in
  let systems = 
    let s = List.nth lst 9 |> String.split_on_char ' ' |>
            List.map (fun i -> int_of_string i) in
    {shield_level = List.nth s 0; shield_power = List.nth s 1;
      engine_level = List.nth s 2; engine_power = List.nth s 3;
      weapons_level = List.nth s 4; weapons_power = List.nth s 5} in
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
  }

let load_game = Controller.init

