(* [Combat] represents a combat event *)
module type Combat = sig
  (* types from ship.mli *)
  type ship
  type weapon_type

  type ship_type = Player | Enemy

  type combat_event = {
    player: ship;
    enemy: ship;
    (* current turn number that combat has been going on for *)
    turn_count: int;
    (* list of weapons that have fired but have not hit yet *)
    (* (number of turns, ship that will be hit, weapon_type, damage) *)
    incoming: (int * ship_type * weapon_type * int)
  }

  (* [outcome] represents possible outcomes from increasing turn_count by one.
   * Nothing means nothing has happened on the current turn, Input means
   * player input is required, Text represents text to display on screen,
   * and Winner is Player if the player has won, and Enemy if the player has
   * lost. *)
  type outcome = Nothing | Input | Text of string | Winner of ship_type

  (* [init d p] generates a combat_event, where ship1 is generated from the
   * player's ship [p]. ship2 is generated with stats dependent on [d], where
   * [d] represents the difficulty.
   * requires: d is a number in range [0, 10] *)
  val init : int -> ship-> combat_event

  (* [step c] returns the outcome after increasing [turn_count] by one.
   * All outcomes are documented above in the type definition. *)
  val step : combat_event -> outcome

  (* [parse_input c i] takes the weapon number that the player wants to fire
   * and fires that weapon. *)
  val parse_input : combat_event -> int -> combat_event
end
