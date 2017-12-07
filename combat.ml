open Ship

type ship = Ship.ship
type weapon_type = Ship.weapon_type
type ship_type = Player | Enemy
type fired_weapon = {
  turns: int;
  ship_target: ship_type;
  room_target: int;
  name: string;
  w_type: weapon_type;
  damage: int;
}
type combat_event = {
  player: ship;
  enemy: ship;
  turn_count: int;
  incoming: fired_weapon list
}

type outcome = Nothing | Input of int | Text of string | Winner of ship_type

(* [num_weapons i] returns the number of weapons for an enemy ship if
 * the player has [i] weapons. The number is generated fairly, but 
 * randomly, depending on [i]. *)
let num_weapons i = 
  let _ = Random.self_init () in
  if i=1 then match Random.int 2 with
    | 0 -> 1
    | _ -> 2
  else if i=2 then match Random.int 5 with
    | 0 -> 1
    | 1 -> 3
    | _ -> 2
  else if i=3 then match Random.int 5 with
    | 0 -> 2
    | 1 -> 4
    | _ -> 3
  else match Random.int 2 with
    | 0 -> 3
    | _ -> 4

let parse_weapon s : weapon =
  let w = String.split_on_char ';' s in
  let typ = (match (List.nth w 5) with
    | "Ion" -> Ion
    | "Laser" -> Laser
    | "Beam" -> Beam
    | "Missile" -> Missile
    | _ -> failwith "Invalid weapon type!"
  ) in
  {
    name = List.nth w 0;
    cost = List.nth w 1 |> int_of_string;
    damage = List.nth w 2 |> int_of_string;
    capacity = List.nth w 3 |> int_of_string;
    charge = 0;
    wtype = typ;
  }

let init p =
  fun () -> let _ = Random.self_init () in
  let pnum_weapons = List.length p.equipped in (* num player weapons *)
  let enum_weapons = num_weapons pnum_weapons in (* enemy num weapons *)
  let e_weapons = ref [] in
  for i=0 to enum_weapons do
    let weapon = Parser.get_lines_from_f "./game_data/weapons.txt" 1 in
    e_weapons := !e_weapons @ [parse_weapon (List.hd weapon)];
  done;
  let e_hull = Random.int 4 + 5 in
  {player=p; 
   enemy={p with equipped=(!e_weapons); 
                 hull=e_hull; max_hull=e_hull}; 
   turn_count=0; 
   incoming=[]}

(* [weapon_outcome s fw b] is the tuple (text, ship [s]) after ship [s] dodges
 * or is hit by fired_weapon [fw]. If [b] is true, then [s] is the player, and
 * if [b] is false, then [s] is the enemy. The returned text depends on whether
 * the dodge was successful or not. *)
let weapon_outcome s fw b =
  let _ = Random.self_init () in
  match (b, Random.int 100 < Ship.evade s) with
  | (true, true) -> ("Player succesfully dodged " ^ fw.name, s)
  | (true, false) ->
    ("Player was hit by " ^ fw.name, Ship.damage s fw.damage fw.w_type)
  | (false, true) -> ("Enemy succesfully dodged " ^ fw.name, s)
  | (false, false) ->
    ("Enemy was hit by " ^ fw.name, Ship.damage s fw.damage fw.w_type)

(* [fire_weapons s b] fires all weapons that are ready for s, and returns 
 * s, a list of weapons that will be appended to incoming, and a string
 * of the weapons that were fired. [b] is whether or not the ship is the
 * player. *)
let fire_weapons s b = 
  let iterator = [0;1;2;3] in
  List.fold_left 
    (fun a i ->
       let (s, lst, str) = a in
       match get_weapon s i with
       | Some weapon ->
         if weapon_ready s i then
           let ship = Ship.fire_weapon s i in
           if b then 
             let elem = {
               turns=3;
               ship_target=Enemy;
               room_target=0;
               name=weapon.name;
               w_type=weapon.wtype;
               damage=weapon.damage;
             } in
             let str = "Your ship fired " in
             (ship, 
              elem::lst, 
              "\n" ^ str ^ weapon.name)
           else
             let elem = {
               turns=3;
               ship_target=Player;
               room_target=0;
               name=weapon.name;
               w_type=weapon.wtype;
               damage=weapon.damage;
             } in
             let str = "Enemy ship fired " in
             (ship, 
              elem::lst, 
              "\n" ^ str ^ weapon.name)
         else (s, lst, str)
       | None -> (s, lst, str))
    (s, [], "")
    iterator

let step c =
  let incoming =
    List.map (fun fw -> {fw with turns=fw.turns - 1}) c.incoming in
  let firing = List.filter (fun fw -> fw.turns=0) incoming in
  let new_ships =
    List.fold_left
      (fun acc fw ->
         if fw.ship_target=Player
         then
           let outcome = weapon_outcome c.player fw true in
           (fst acc ^ "\n" ^ fst outcome, (snd outcome, snd (snd acc)))
         else
           let outcome = weapon_outcome c.enemy fw false in
           (fst acc ^ "\n" ^ fst outcome, (fst (snd acc), snd outcome)))
      ("", (c.player, c.enemy))
      firing in
  let text = fst new_ships in
  let new_player = Ship.step (fst (snd new_ships)) in
  let new_enemy = Ship.step (snd (snd new_ships)) in
  let new_incoming = List.filter (fun fw -> fw.turns<>0) incoming in

  let (new_enemy, s, t) = fire_weapons new_enemy false in
  let new_incoming = new_incoming @ s in
  let text = text ^ t in

  let (new_player, s, t) = fire_weapons new_player true in
  let new_incoming = new_incoming @ s in
  let text = text ^ t in

  (* TODO: check new_player if they need to fire anything *)
  let winner = ref None in
  if (get_hull new_player)=0 then winner := Some Enemy;
  if (get_hull new_enemy)=0 then winner := Some Player;

  match (!winner, text) with
  | Some Enemy, _ -> (c, Winner Enemy)
  | Some Player, _ -> (c, Winner Player) 
  | _, "" -> 
    ({c with
        incoming=new_incoming;
        player=new_player;
        enemy=new_enemy},
    Nothing) 
  | _, _ ->
    ({c with
        incoming=new_incoming;
        player=new_player;
        enemy=new_enemy},
    Text text) 

let parse_input c num = failwith "Unimplemented"
