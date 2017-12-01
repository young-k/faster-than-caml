type event_type = Store | Nothing | Event | Combat | End

type star = {
  id : int;
  event : event_type;
  reachable : int list;
}
type galaxy = star list

let rec random_nums r n acc =
  if n = 0 then List.sort_uniq Pervasives.compare acc
  else random_nums r (n-1) ((Random.int r)+1::acc)

let init =
  let rec create a n acc =
    if a = n then (({id = a; event = End; reachable = []})::acc, 1)
    else let e = match Random.int 4 with
      | 0 -> Store
      | 1 -> Nothing
      | 2 -> Event
      | _ -> Combat
      in let reach = random_nums n ((Random.int 6)+1) [a+1]
      in let filtered = List.filter (fun x -> x <> a) reach
      in create (a+1) n (({id = a; event = e; reachable = filtered})::acc)
  in create 1 10 []

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

let display (x, y) m = failwith "Unimplemented"
