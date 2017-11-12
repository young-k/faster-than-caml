open OUnit2

let galaxy_tests = [
  "init" >:: (fun _ -> assert_equal 10 (List.length (fst Galaxy.init)));
]

let tests = "test suite" >::: List.flatten [
  galaxy_tests;
]

let _ = run_test_tt_main tests