open OUnit2
open Ship
open Event
open Galaxy
open Store

let test_galaxy = [{id = 10; event = End; reachable = []};
                    {id = 9; event = Store; reachable = [0; 3; 4; 10]};
                    {id = 8; event = Combat; reachable = [7; 9]};
                    {id = 7; event = Event; reachable = [2; 5; 8]};
                    {id = 6; event = Combat; reachable = [0; 3; 7]};
                    {id = 5; event = Nothing; reachable = [3; 6]};
                    {id = 4; event = Store; reachable = [5; 6; 8; 9]};
                    {id = 3; event = Event; reachable = [4; 5; 8; 9]};
                    {id = 2; event = Combat; reachable = [0; 1; 3; 4]};
                    {id = 1; event = Store; reachable = [2]}]

let galaxy_tests = [
  "init" >:: (fun _ -> assert_equal 10 (List.length (fst Galaxy.init)));
  "start_star" >:: (fun _ -> assert_equal 1 (snd Galaxy.init));

  "reachable" >:: (fun _ -> assert_equal [(Some Store, 4); (None, 5);
                                          (None, 8); (Some Store, 9)]
                                          (reachable test_galaxy 3));
  "reachable_none" >:: (fun _ -> assert_equal [] (reachable test_galaxy 10));

  "get_event" >:: (fun _ -> assert_equal Store (get_event test_galaxy 9));
  "get_event_nothing" >:: (fun _ -> assert_equal Nothing
                              (get_event test_galaxy 5));
  "get_event_end" >:: (fun _ -> assert_equal End (get_event test_galaxy 10));

  "get_end" >:: (fun _ -> assert_equal 10 (get_end test_galaxy));
  "get_end_random" >:: (fun _ -> assert_equal 10 (get_end (fst Galaxy.init)));
]

let store = Store.init Ship.init

let store_tests = [
  "init_weapons" >:: (fun _ -> assert_equal 3 (List.length store.weapons));
  "init_aug" >:: (fun _ -> assert_equal 3 (List.length store.augmentations));

  "get_augmentations" >:: 
    (fun _ -> assert_equal 3 (List.length (get_augmentations store)));
  
  "get_weapons" >:: 
    (fun _ -> assert_equal 3 (List.length (get_weapons store)));

  "buy_weap_no_scrap" >::
    (fun _ -> assert_equal 1 
      ((buy store (Ship.init) "Basic Laser").inventory |> List.length));
  "buy_aug_no_scrap" >::
    (fun _ -> assert_equal 0 
      ((buy store (Ship.init) "Automated Re-loader").augmentations 
        |> List.length));
]

let e = Event.init

let event_tests = [
  "init_name" >:: (fun _ -> assert_equal true (e.name<>""));
  "init_fst_choice_des" >::
    (fun _ -> assert_equal true (e.fst_choice.description<>""));
  "init_snd_choice_des" >::
    (fun _ -> assert_equal true (e.snd_choice.description<>""));
  "init_choice_fuel" >::
    (fun _ -> assert_equal true
      ((string_of_int e.fst_choice.delta_resources.fuel)<>""));
  "init_snd_choice_missiles" >::
    (fun _ -> assert_equal true
      ((string_of_int e.fst_choice.delta_resources.missiles)<>""));
  "init_snd_choice_scraps" >::
    (fun _ -> assert_equal true
      ((string_of_int e.fst_choice.delta_resources.scraps)<>""));
  "init_choice_description" >::
    (fun _ -> assert_equal
        e.fst_choice.description (choice_description e true));
  "init_get_name" >:: (fun _ -> assert_equal e.name (get_name e));
]

let tests = "test suite" >::: List.flatten [
  galaxy_tests;
  store_tests;
  event_tests;
]

let _ = run_test_tt_main tests
