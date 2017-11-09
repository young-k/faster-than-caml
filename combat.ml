(* types from ship.mli *)
type ship
type weapon_type

type ship_type = Player | Enemy

type combat_event = {
  player: ship;
  enemy: ship;
  turn_count: int;
  incoming: (int * (ship_type * (weapon_type * int))) list
}

type outcome = Nothing | Input | Text of string | Winner of ship_type

let init p =
  {player=p; enemy=p; turn_count=0; incoming=[]}

let step c = failwith "Unimplemented"

let parse_input c num = failwith "Unimplemented"
