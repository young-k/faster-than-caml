type event_type = Start | Store | Nothing | Event | Combat | End

type star = {
  id : int;
  event : event_type;
  reachable : int list;
}
type galaxy = star list

let _ = Random.self_init ()

let init =
  fun () -> let random_event () =
    match Random.int 8 with
    | 0 -> Store
    | 1 | 2 -> Nothing
    | 3 | 4 -> Event
    | _ -> Combat in
  let ret = [
    {id = 2; event = End; reachable = [1;3;4;5]};
    {id = 3; event = End; reachable = [1;2;5;6]};
    {id = 4; event = End; reachable = [2;7;8]};
    {id = 5; event = End; reachable = [2;3;7;9]};
    {id = 6; event = End; reachable = [3;8;9]};
    {id = 7; event = End; reachable = [4;5;10]};
    {id = 8; event = End; reachable = [4;6;10]};
    {id = 9; event = End; reachable = [5;6;10]};
  ] in
  let ret = List.map (fun x -> {x with event=random_event()}) ret in
  (* add ids 1 & 10; edge cases *)
  let ret = 
    [{id = 1; event = Start; reachable = [2;3]}] @ ret  
    @ [{id = 10; event = End; reachable = []}] in
  (ret, 1)

(* [find_star m i] returns the star in galaxy [m] with id [i]
 * requires: galaxy [m], valid star id [i] *)
let find_star m id = List.find (fun s -> s.id = id) m

let reachable m id =
  let star = find_star m id in
    List.map (fun s ->
      let s' = find_star m s in
        match s'.event with
        | Store -> (Some Store, s'.id)
        | End -> (Some End, s'.id)
        | _ -> (None, s'.id)
    ) star.reachable

let get_event m id =
  let star = find_star m id in star.event

let get_end m =
  let star = List.find (fun s ->
    match s.event with
    | End -> true
    | _ -> false
  ) m in
  star.id
