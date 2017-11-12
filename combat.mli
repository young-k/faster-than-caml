(* [Combat] represents a combat event *)

(* types from ship.mli *)
type ship
type weapon_type

type ship_type = Player | Enemy

type fired_weapon = {
  turns: int; (* number of turns until [target] is hit *)
  ship_target: ship_type;
  room_target: int;
  name: string;
  w_type: weapon_type; (* type of weapon *)
  damage: int; (* damage done *)
}

type combat_event = {
  player: ship;
  enemy: ship;
  (* current turn number that combat has been going on for *)
  turn_count: int;
  (* list of weapons that have fired but have not hit yet *)
  incoming: fired_weapon list
}

(* [outcome] represents possible outcomes from increasing turn_count by one.
 * Nothing means nothing has happened on the current turn, Input means
 * player input is required, Text represents text to display on screen,
 * and Winner is Player if the player has won, and Enemy if the player has
 * lost. *)
type outcome = Nothing | Input | Text of string | Winner of ship_type

(* [init p] generates a combat_event, where ship1 is generated from the
 * player's ship [p]. ship2 is generated with stats dependent on [p], with
 * random changes made to the stats from [p]. *)
val init : ship -> combat_event

(* [step c] returns the outcome after increasing [turn_count] by one.
 * All outcomes are documented above in the type definition. *)
val step : combat_event -> outcome

(* [parse_input c i] takes the weapon number that the player wants to fire
 * and fires that weapon. *)
val parse_input : combat_event -> int -> combat_event
