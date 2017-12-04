(* [Event] contains all data and methods of randomly generated events *)
open Ship
open Parser

type choice = {
  description: string;
  delta_resources: Ship.resources;
  follow_up: string;
}

type event = {
  name: string;
  fst_choice: choice;
  snd_choice: choice
}

let init =
  fun () -> match (get_lines_from_f "./game_data/events.txt" 1) with
  | [] -> failwith "File does not contain an event"
  | h::t ->
    try
      begin
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
        | _ -> failwith "Line does not contain number of necessary components"
      end
    with
    | _ -> failwith "Line does not describe a valid event."


let pick_choice s e b =
  let res = s.resources in
  if b then
    let delt1 = e.fst_choice.delta_resources in
    let updated_resources =
      {
        fuel = res.fuel + delt1.fuel;
        missiles = res.missiles + delt1.missiles;
        scrap = res.scrap + delt1.scrap;
      } in
    {s with resources=updated_resources}
  else
  let delt2 = e.snd_choice.delta_resources in
  let updated_resources =
    {
      fuel = res.fuel + delt2.fuel;
      missiles = res.missiles + delt2.missiles;
      scrap = res.scrap + delt2.scrap;
    } in
  {s with resources=updated_resources}

let get_description e b =
  if b then e.fst_choice.description
  else e.snd_choice.description

let get_resources e b =
  if b then e.fst_choice.delta_resources
  else e.snd_choice.delta_resources

let get_followup e b =
  if b then e.fst_choice.follow_up
  else e.snd_choice.follow_up

let get_name e = e.name
