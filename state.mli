(* [State] contains the functions that are responsible for saving and loading
 * the current game state (controller) *)

(* [save_game c] takes a controller which acts as the current game state, 
 * converts it to a textual representation, and then writes it to
 * 'game_data/save.txt' 
 * returns: a unit *)
val save_game : Controller.controller -> unit

(* [load_game ()] reads the file 'game_data/save.txt' and translates the text
 * into a controller which acts as the current game state and returns it
 * returns: a controller *)
val load_game : unit -> Controller.controller