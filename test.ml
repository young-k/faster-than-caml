open OUnit2
open Ship
open Event

let galaxy_tests = [
  "init" >:: (fun _ -> assert_equal 10 (List.length (fst Galaxy.init)));
]

let e = init

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
  event_tests;
]

let _ = run_test_tt_main tests
