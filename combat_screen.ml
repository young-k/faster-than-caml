open Char
open Lwt
open Lwt_react
open LTerm_widget
open Ship
open Combat

(* [in_frame w] is w wrapped in a frame *)
let in_frame w = let f = new frame in f#set w; f
let in_modal w = let f = new modal_frame in f#set w; f

(* [step t c] is the tuple (text, combat_event, winner) after stepping once. *)
let step t c =
  match Combat.step c with
  | (c, Text s) -> (t ^ "\n" ^ s, c, false)
  | (c, Winner Player) -> 
    ("You defeated the enemy! Press JUMP to continue!", c, true)
  | (c, Winner Enemy) -> 
    ("You suffer heavy losses... Press JUMP to continue!", c, true)
  | (c, _) -> (t, c, false)

let ship_ascii = "\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\166\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\164\226\149\144-\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\145&]\194\160\194\160\194\160\194\160\194\160\194\160]\194\160\194\160\194\160\194\172\226\137\136\226\137\136\226\137\136\226\137\136\226\149\166\194\160\194\160\194\160\226\140\144-\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\144 $&\226\150\144%;\226\150\132..\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160`````\194\160\194\160\194\160}\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\144 *\226\150\132\226\140\144;'#.\194\160\194\160\194\160\194\160-\194\160\194\160'\194\160\194\160\194\160/\194\160-\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\153\226\150\132\226\150\132\194\160,==\194\160,\226\149\148\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144-\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160,.\194\160\226\140\144\226\149\144\194\160'`\194\160\194\160\194\160\194\160\\\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160/\194\160'\194\160,~\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160,-**'\\\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160.......................\194\160\194\160\194\160\194\160\194\160\194\160\194\160`--~.......\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\226\149\145\194\160\194\160\194\160\194\160\194\160\194\160\194\160`-\194\160.-\194\160'\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160.\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160'''''`'\194\160.\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\226\149\145\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\148\130\194\160\194\160\194\160\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160,,, ---- ------\194\160- -\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160*\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\226\149\154\226\149\144\226\149\144\226\149\151\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\148\130\194\160\194\160\194\160\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\144\226\149\154\226\149\160\226\149\159\226\149\160\226\150\144\194\160\194\160:\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\226\149\144\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\226\149\148\226\149\144\226\149\144\226\149\157\194\160\194\160\194\160\194\160\194\160\194\160\194\160!\194\160\194\160\194\160\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\144\226\149\160\226\149\160\226\149\159\226\149\159\226\150\144\194\160\194\160:\194\160\194\160\194\160 \194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\226\149\144\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\226\149\145\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\148\130\194\160\194\160\194\160\194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160```~\194\160.....  ..\194\160\194\160...\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160 ^\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\226\149\145 \194\160\194\160\194\160\194\160\194\160\194\160-`\194\160\194\160`. \194\160\194\160\226\140\161\194\160\226\140\161\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160 .\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160...---- '\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160'**\226\140\144,/\194\160\194\160\194\160\194\160\194\160\194\160\194\160'......................'\194\160\194\160\194\160\194\160\194\160\194\160\194\160.\226\148\128\194\160`''''''''\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160''\194\160...z\226\137\164\194\172.\194\160\194\160\194\160/\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\\  .\194\160`\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\159%]\226\140\144\194\160\194\160\194\160\194\160 \226\149\154\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144-\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\144 #\226\149\148\226\150\144\226\149\153`\226\149\154\194\160\194\160\194\160\194\160\194\160#\194\160\194\160\226\137\136==\194\160-\194\160\194\160,\194\160.\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\144 #\226\149\153\226\150\140--\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160----\194\172\194\160\194\160\194\160\226\149\152\194\160`\194\160}\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\159\226\150\146#\194\160\194\160\226\149\146\194\160\194\160\194\160\226\149\146\194\160\194\160\194\160\194\160``'`'\194\160\194\160\194\160\194\160/\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144``\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n";;
let enemy_ascii = "\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\153\226\150\132\226\149\155\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160[\226\150\140\226\150\147\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\132\226\150\147  \226\149\165,,,\226\149\165\226\150\144\226\149\147\226\150\136\226\150\132\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160 \226\150\140\226\150\132\226\150\147\194\160,,\226\149\147m\195\134\226\150\147\226\150\147\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\226\150\132\226\150\128\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\128\226\150\136\226\150\136\194\160 \194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160 \226\150\136\226\150\136\226\150\136'\194\160\194\160\194\160\194\160\194\160\194\160\194\160'\226\149\171\226\140\144\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\226\150\132\226\149\153\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\128\226\150\136\226\150\140\194\160 \194\160\194\160\194\160\194\160\194\160\194\160\194\160 \226\150\136\226\150\136\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\153 \194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\226\150\147`\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\148\226\150\147 ***;\226\150\147\226\150\147\226\150\136\226\150\136, ****~,\226\150\136\226\150\136\226\150\147\226\150\132\226\149\157\226\150\140\194\160\194\160\194\160\194\160\194\160\226\150\147\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\226\150\147\226\149\157\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\172 \226\140\130\226\150\144\226\150\146\226\150\147\226\150\147\226\150\147\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\172\226\150\147\226\150\147\226\149\163\226\150\136\226\149\166\226\149\168\195\145\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\147 \194\160\194\160\n\194\160\194\160\226\150\147\226\150\140\194\160\194\160\194\160  \194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\153\226\150\136\226\150\147\226\150\147\226\149\144\194\160\194\160\194\160  \194\160\194\160\194\160\226\150\147\226\150\146\226\150\147\226\150\140`\194\160\194\160\194\160\194\160\194\160\194\160   \194\160\194\160\194\160\226\149\145\226\149\149\194\160\n\194\160\194\160\226\150\147\226\150\147\226\149\151  \194\160\194\160\194\160\194\160 \194\160\194\160\194\160\194\160\226\150\144\226\150\136\226\150\147\226\150\136\194\160\194\160 `````\194\160\194\160\226\150\144\226\150\147\226\150\147\226\150\136\194\160\194\160\194\160\194\160\194\160 \194\160\194\160\194\160\194\160   \226\150\147'\194\160\n\194\160\226\150\132\226\150\147\226\150\147\226\150\128\226\150\136\226\150\136\226\150\136\226\150\136\226\150\132\226\150\132\226\150\132,,,, \226\150\136\226\150\136\226\150\128 \194\160 \194\160\194\160\194\160\194\160 \194\160\226\150\128\226\150\136\226\150\136\226\150\128\226\150\140,,,,\226\150\132\226\150\132\226\150\132\226\150\136\226\150\136\226\150\128\226\150\128\226\150\128\226\150\147\226\150\136\226\140\144\n\194\160\226\149\153\226\150\128\194\160\194\160\194\160\194\160\194\160\194\172\194\160\226\150\128\226\150\128\226\150\132\226\149\150\226\148\164\194\160\194\160\194\160\194\160\194\160\226\150\144\226\150\140\226\150\132,..,.\226\150\147\194\160\194\160\194\160\194\160\194\160\194\160\226\150\147 \226\150\132\226\150\128\226\149\152\194\172`\194\160\194\160\194\160\194\160\194\160\226\150\128-\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\144\226\150\136\226\150\147\226\150\140\194\160\194\160\194\160\194\160\194\160\194\160\226\150\136\226\150\136\226\150\147\226\150\140\226\150\147\226\150\146\226\150\147\226\149\169\194\160\194\160\194\160\194\160\194\160\194\160\226\150\136\226\150\147\226\150\136\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\128\226\150\128\226\150\128\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\149\153\226\150\128\226\150\128\226\150\128\226\150\128\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\226\150\128\226\150\128'\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\194\160\n"


let get_components combat ship (m, h, s) (waiter, wakener) =
  let mainbox = new vbox in

  (* Setup JUMP button *)
  let mapbox = new hbox in
  let map = new button ("JUMP") in
  mapbox#add (new spacing ~cols:40 ());
  mapbox#add (in_frame map);
  mapbox#add (new spacing ~cols:40 ());

  (* Setup display of ship and enemy ship *)
  let ascii_box = new hbox in
  let ship_box = new vbox in
  let ship_ascii = new label ship_ascii in
  ship_box#add ship_ascii;

  let enemy_box = new vbox in
  let enemy_ascii = new label enemy_ascii in
  enemy_box#add enemy_ascii;

  ascii_box#add ship_box;
  ascii_box#add enemy_box;

  mainbox#add ~expand:false mapbox;
  mainbox#add ascii_box;

  (* Setup footer section *)

  (* Setup left side of footer *)
  let footer = new hbox in

  let footer_left = new vbox in

  (* Setting up systems section *)
  let systems_section = new vbox in
  let systems_label = new label "Systems" in
  let systems = new hbox in

  (* Used to generate display for shield/weapon systems *)
  let rec gen_lst_display lvl pow acc =
    if pow<>0 then gen_lst_display (lvl-1) (pow-1) ("*"::acc)
    else
      if lvl<> 0 then gen_lst_display (lvl-1) pow ("_"::acc)
      else acc
  in

  (* Takes list from gen_lst_display and generates the text *)
  let gen_display lst =
    let rev_lst = List.rev lst in
    List.fold_left (^) "" rev_lst
  in

  let engine_system = new vbox in
  let e_level = ship.systems.engine_level in
  let e_power = ship.systems.engine_power in
  let engine_display = gen_lst_display e_level e_power [] |> gen_display in
  let engine_lbl = new label ("Engine Level: " ^ engine_display) in
  engine_system#add engine_lbl;
  systems#add (new spacing ~cols:3 ());
  systems#add engine_system;
  systems#add (new spacing ~cols:3 ());
  systems#add ~expand:false new vline;

  let shield_system = new vbox in
  let s_level = ship.systems.shield_level in
  let s_power = ship.systems.shield_power in
  let shield_display = gen_lst_display s_level s_power [] |> gen_display in
  let shield_lbl = new label ("Shield: " ^ shield_display) in
  shield_system#add shield_lbl;
  systems#add (new spacing ~cols:3 ());
  systems#add shield_system;
  systems#add (new spacing ~cols:3 ());
  systems#add ~expand:false new vline;

  let weapons_system = new vbox in
  let w_level = ship.systems.weapons_level in
  let w_power = ship.systems.weapons_power in
  let weapons_display = gen_lst_display w_level w_power [] |> gen_display in
  let weapons_lbl = new label ("Weapons: " ^ weapons_display) in
  weapons_system#add weapons_lbl;
  systems#add (new spacing ~cols:3 ());
  systems#add weapons_system;
  systems#add (new spacing ~cols:3 ());

  systems_section#add systems_label;
  systems_section#add ~expand:false new hline;
  systems_section#add systems;

  (* Setting up weapons section *)
  let weapons_section = new vbox in
  let weapons_label = new label "Weapons" in
  let weapons = new hbox in
  let selected_weapon = ref 0 in
  for i = 0 to 3 do
    match (Ship.get_weapon ship i) with
    | Some w ->
      let label_box = new hbox in 
      let some = new label w.name in
      label_box#add ~expand:false some;
      weapons#add label_box;
      weapons#add ~expand:false new vline;
    | None ->
      let vbox = new vbox in
      let none = new label "None" in
      vbox#add none;
      weapons#add vbox;
      if i<>3 then weapons#add ~expand:false new vline
      else ()
  done;

  weapons_section#add weapons_label;
  weapons_section#add ~expand:false new hline;
  weapons_section#add weapons;

  let systems_frame = in_frame systems_section in
  let weapons_frame = in_frame weapons_section in

  footer_left#add systems_frame;
  footer_left#add weapons_frame;



  (* Setup middle of footer *)
  let footer_middle = new vbox in 
  
  let enemy_box = new vbox in 
  
  let stats_box = new hbox in
  let enemy_stats_label = new label "Enemy Stats:" in 
  stats_box#add (new spacing ~cols:3 ());
  stats_box#add ~expand:false enemy_stats_label;
  stats_box#add (new spacing ~cols:3 ());

  let hull_box = new hbox in 
  let hull_label = new label "Hull:" in
  hull_box#add (new spacing ~cols:3 ());
  hull_box#add ~expand:false hull_label;
  hull_box#add (new spacing ~cols:3 ());
  
  let enemy_weapons_box = new hbox in 
  let enemy_weapons_label = new label "Weapons:" in
  enemy_weapons_box#add (new spacing ~cols:3 ());
  enemy_weapons_box#add ~expand:false enemy_weapons_label;
  enemy_weapons_box#add (new spacing ~cols:3 ());

  let enemy_weapons_section = new vbox in 
  for i = 0 to 3 do
    let hbox = new hbox in 
    let label = new label ("Weapon " ^ (string_of_int i) ^ ":") in
    hbox#add (new spacing ~cols:3 ());
    hbox#add ~expand:false label;
    hbox#add (new spacing ~cols:3 ());
    enemy_weapons_section#add ~expand:false label;
  done;

  enemy_box#add ~expand:false stats_box;
  enemy_box#add new hline;
  enemy_box#add ~expand:false hull_box;
  enemy_box#add new hline;
  enemy_box#add ~expand:false enemy_weapons_box;
  enemy_box#add new hline;
  enemy_box#add ~expand:false enemy_weapons_section;

  let enemy_frame = in_frame enemy_box in
  footer_middle#add enemy_frame;




  (* Setup right side of footer *)
  let footer_right = new vbox in

  let textbox = new hbox in
  let text_label = new label "" in
  textbox#add text_label;
  textbox#add ~expand:false new hline;

  let textbox_frame = in_frame textbox in
  footer_right#add textbox_frame;

  let info_hbox = new hbox in 
  info_hbox#add ~expand:false footer_left;
  info_hbox#add ~expand:false footer_middle;
  footer#add ~expand:false info_hbox;
  footer#add footer_right;

  mainbox#add footer;

  let combat = ref combat in
  let text = ref "" in
  let winner = ref false in
  let event =  Lwt_engine.on_timer 0.7 true 
      (fun _ -> 
         if (not !winner) then
           let (f, se, th) = step (!text) (!combat) in
           text := f;
           combat := se;
           winner := th;
           let player = (!combat).player in
           let resources = Ship.get_resources player in 
           m#set_text ("Missiles: " ^ string_of_int resources.missiles);
           h#set_text ("Hull: " ^ string_of_int (Ship.get_hull player));
           s#set_text ("Shield Level: " ^ 
                       string_of_int (player.shield.layers));
           text_label#set_text (!text)) in

  ((map, mainbox), (selected_weapon, event), combat);
