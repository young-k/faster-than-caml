(* [Event] contains all data and methods of randomly generated events *)
open Ship
open Parser

type choice = {
  description: string;
  delta_resources: (int * int * int);
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
          let choice1 = {description=b; delta_resources=(c,d,e)} in
          let choice2 = {description=f; delta_resources=(g,h,i)} in
          {name=a; fst_choice=choice1; snd_choice=choice2}
        | _ -> failwith "Line does not contain number of necessary components"
      end
    with
    | _ -> failwith "Line does not describe a valid event."


let pick_choice s e b =
  let (f, m, s) = get_resources s in
  if b then
    let choice1 = e.fst_choice in
    let (delta_f,delta_m,delta_s) = choice1.delta_resources in
    let updated_resources = (f+delta_f, m+delta_m, s+delta_s) in
    {s with resources=updated_resources}
  else
    let choice2 = e.snd_choice in
    let (delta_f,delta_m,delta_s) = choice2.delta_resources in
    let updated_resources = (f+delta_f, m+delta_m, s+delta_s) in
    {s with resources=updated_resources}

  let choice_description e b =
    if b then e.fst_choice.description
    else e.snd_choice.description

  let get_description e = e.name
