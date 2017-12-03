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

type outcome = Nothing | Input of string | Text of string | Winner of ship_type

let init p =
  {player=p; enemy=p; turn_count=0; incoming=[]}

(* [weapon_outcome s fw b] is the tuple (text, ship [s]) after ship [s] dodges
 * or is hit by fired_weapon [fw]. If [b] is true, then [s] is the player, and
 * if [b] is false, then [s] is the enemy. The returned text depends on whether
 * the dodge was successful or not. *)
let weapon_outcome s fw b =
  match (b, Random.int 100 < Ship.evade s) with
  | (true, true) -> ("Player succesfully dodged " ^ fw.name, s)
  | (true, false) ->
    ("Player was hit by " ^ fw.name, Ship.damage s fw.damage fw.w_type)
  | (false, true) -> ("Enemy succesfully dodged " ^ fw.name, s)
  | (false, false) ->
    ("Enemy was hit by " ^ fw.name, Ship.damage s fw.damage fw.w_type)

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
  let new_player = fst (snd new_ships) in
  let new_enemy = snd (snd new_ships) in
  let new_incoming = List.filter (fun fw -> fw.turns<>0) incoming in

  (* TODO: check new_enemy if they need to fire *)
  (* TODO: check new_player if they need to fire anything *)

  match text with
  | "" -> (c, Nothing)
  | _ ->
    ({c with
        incoming=new_incoming;
        player=new_player;
        enemy=new_enemy},
    Text text) 

let parse_input c num = failwith "Unimplemented"
