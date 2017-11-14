(* [Event] contains all data and methods of randomly generated events *)
open Ship
open Parser

type choice = {
  description: string;
  delta_resources: Ship.resources;
}

type event = {
  name: string;
  fst_choice: choice;
  snd_choice: choice
}

let init =
  match (get_lines_from_f "events.txt" 1) with
  | [] -> failwith "File does not contain an event"
  | h::t ->
    try
      begin
        match (String.split_on_char ';' h) with
        | a::b::c::d::e::f::g::h::i::[] ->
          let c = int_of_string c in
          let d = int_of_string d in
          let e = int_of_string e in
          let g = int_of_string g in
          let h = int_of_string h in
          let i = int_of_string i in
          let delt1 = {fuel=c; missiles=d; scraps=e} in
          let delt2 = {fuel=g; missiles=h; scraps=i} in
          let choice1 = {description=b; delta_resources=delt1} in
          let choice2 = {description=f; delta_resources=delt2} in
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
        scraps = res.scraps + delt1.scraps;
      } in
    {s with resources=updated_resources}
  else
  let delt2 = e.snd_choice.delta_resources in
  let updated_resources =
    {
      fuel = res.fuel + delt2.fuel;
      missiles = res.missiles + delt2.missiles;
      scraps = res.scraps + delt2.scraps;
    } in
  {s with resources=updated_resources}

let choice_description e b =
  if b then e.fst_choice.description
  else e.snd_choice.description

let get_name e = e.name
