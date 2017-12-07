open OUnit2
open Ship
open Event
open Galaxy
open Store
open State

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

let random_galaxy = Galaxy.init () |> fst

let galaxy_tests = [
  "init" >:: (fun _ -> assert_equal 10 (List.length random_galaxy));
  "start_star" >:: (fun _ -> assert_equal 1 (snd (Galaxy.init ())));

  "reachable" >:: (fun _ -> assert_equal [(Some Store, 4); (None, 5);
                                          (None, 8); (Some Store, 9)]
                                          (reachable test_galaxy 3));
  "reachable_none" >:: (fun _ -> assert_equal [] (reachable test_galaxy 10));

  "get_event_store" >:: (fun _ -> assert_equal Store (get_event test_galaxy 9));
  "get_event_combat" >:: (fun _ -> assert_equal Combat 
                                    (get_event test_galaxy 2));
  "get_event_event" >:: (fun _ -> assert_equal Event (get_event test_galaxy 7));
  "get_event_nothing" >:: (fun _ -> assert_equal Nothing
                                    (get_event test_galaxy 5));

  "get_event_end" >:: (fun _ -> assert_equal End (get_event test_galaxy 10));
  "get_event_end_random" >:: (fun _ -> assert_equal End (get_event 
                                                         random_galaxy 10));

  "get_end" >:: (fun _ -> assert_equal 10 (get_end test_galaxy));
  "get_end_random" >:: (fun _ -> assert_equal 10 (get_end random_galaxy));
]

let store = Store.init Ship.init

let test_weapon =
{
  name = "Test Weapon";
  cost = 0;
  damage = 1;
  capacity = 10;
  charge = 10;
  wtype = Laser;
}

let test_aug =
{
  name = "Test Augmentation";
  cost = 0;
  aug_type = Damage;
  stat = 1;
  description = "Increase damage of all weapons by 1";
}

let new_store : store = {
  weapons = test_weapon::store.weapons;
  augmentations = test_aug::store.augmentations;
  fuel = 5;
  missiles = 5;
}

let ship_with_no_scrap = 
    {Ship.init with resources={fuel = 0; missiles = 0; scrap = 0}}

let ship_with_weap = (buy new_store (Ship.init) "Test Weapon")
let ship_with_aug = (buy new_store ship_with_weap "Test Augmentation")

let store_tests = [
  "init_weapons" >:: (fun _ -> assert_equal 3 (List.length store.weapons));
  "init_aug" >:: (fun _ -> assert_equal 3 (List.length store.augmentations));
  "init_fuel" >:: (fun _ -> assert_equal 5 store.fuel);
  "init_missiles" >:: (fun _ -> assert_equal 5 store.missiles);

  "parse_weapon" >:: (fun _ -> assert_equal test_weapon 
                                (parse_weapon "Test Weapon;0;1;10;10;Laser"));

  "parse_augmentation" >:: (fun _ -> assert_equal test_aug (parse_augmentation 
    "Test Augmentation;0;Damage;1;Increase damage of all weapons by 1"));

  "get_augmentations" >::
    (fun _ -> assert_equal 3 (List.length (get_augmentations store)));

  "get_weapons" >::
    (fun _ -> assert_equal 3 (List.length (get_weapons store)));

  "apply_augmentation" >::
    (fun _ -> assert_equal ((List.hd Ship.init.inventory).damage + 1)
            (List.hd (apply_augmentation Ship.init test_aug).inventory).damage);

  "buy_weap_no_scrap" >::
    (fun _ -> assert_equal 1
      ((buy store (ship_with_no_scrap) (List.hd store.weapons).name).inventory 
        |> List.length));
  "buy_aug_no_scrap" >::
    (fun _ -> assert_equal 0
      ((buy store (ship_with_no_scrap) 
        (List.hd store.augmentations).name).augmentations
        |> List.length));

  "buy_weap" >::
    (fun _ -> assert_equal 2 (ship_with_weap.inventory |> List.length));

  "before_aug" >::
    (fun _ -> assert_equal 2 (List.fold_left (fun acc w -> acc + w.damage) 0
                              ship_with_weap.inventory));
  "buy_aug" >::
    (fun _ -> assert_equal 4 (List.fold_left (fun acc w -> acc + w.damage) 0
                              ship_with_aug.inventory));
  
  "can_buy_false" >:: (fun _ -> assert_equal false (can_buy store 
                      ship_with_no_scrap (List.hd store.weapons).name));
  
  "can_buy_true" >:: (fun _ -> assert_equal true (can_buy new_store 
                      ship_with_no_scrap "Test Weapon"));
]

let e = Event.init ()

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
  "init_snd_choice_scrap" >::
    (fun _ -> assert_equal true
      ((string_of_int e.fst_choice.delta_resources.scrap)<>""));
  "init_get_description" >::
    (fun _ -> assert_equal
        e.fst_choice.description (get_description e true));
  "init_get_name" >:: (fun _ -> assert_equal e.name (get_name e));
]

let ship = Ship.init
let shield0 = {
  layers = 0;
  charge = 5;
  capacity = 5;
}
let shield1 = {
  layers = 1;
  charge = 5;
  capacity = 5;
}
let init_rcs = {fuel = 5; missiles = 1; scrap = 100;}
let new_rcs = {fuel = 4; missiles = 3; scrap = 103;}
let new_rcs1 = {fuel = 6; missiles = 1; scrap = 100;}
let new_rcs2 = {fuel = 5; missiles = 2; scrap = 100;}
let new_rcs3 = {fuel = 5; missiles = 1; scrap = 3;}
let ion = {
    name = "Ion cannon";
    cost = 10;
    damage = 1;
    capacity = 2;
    charge = 0;
    wtype = Ion;
  }
let weap = {
    name = "Ion cannon2";
    cost = 20;
    damage = 3;
    capacity = 3;
    charge = 0;
    wtype = Ion;
  }
let damaged_ship = {ship with systems = {
    shield_level = 1;
    shield_power = 0;
    engine_level = 1;
    engine_power = 0;
    weapons_level = 1;
    weapons_power = 0;
    }
  }
let dude = {
  name = "O Camel";
  skills = (1,1,1)
}

let ship_tests = [
  "evade" >:: (fun _ -> assert_equal 20 (evade ship));
  "get_hull" >:: (fun _ -> assert_equal 30 (get_hull ship));
  "charge_shield0" >:: (fun _ -> assert_equal ship (charge_shield ship));
  "charge_shield1" >:: (fun _ -> assert_equal ship 
    (charge_shield {ship with shield = shield0}));
  "charge_shield2" >:: (fun _ -> assert_equal {ship with shield = shield1} 
    (charge_shield {ship with shield = shield1}));

(*----------------------resources get/set functions----------------*)

  "get_resources" >:: (fun _ -> assert_equal init_rcs 
                                (Ship.get_resources ship));
  "set_resources" >:: (fun _ -> assert_equal {ship with resources = new_rcs}
    (set_resources ship (-1,2,3)));
  "get_fuel" >:: (fun _ -> assert_equal 5 (get_fuel ship));
  "set_fuel" >:: (fun _ -> assert_equal {ship with resources = new_rcs1}
    (set_fuel ship 6));
  "get_missiles" >:: (fun _ -> assert_equal 1 (get_missiles ship));
  "set_missiles" >:: (fun _ -> assert_equal {ship with resources = new_rcs2}
    (set_missiles ship 2));
  "get_scrap" >:: (fun _ -> assert_equal 100 (get_scrap ship));
  "set_scrap" >:: (fun _ -> assert_equal {ship with resources = new_rcs3}
    (set_scrap ship 3));

(*----------------------weapon/hull functions----------------------*)

  "damage0" >:: (fun _ -> assert_equal 
    {ship with shield = {ship.shield with layers = 0}}
    (damage ship 1 Laser));
  "damage1" >:: (fun _ -> assert_equal 
    {ship with shield = {ship.shield with layers = 0}; hull = 28}
    (damage ship 3 Laser));
  "damage2" >:: (fun _ -> assert_equal {ship with hull = 29}
    (damage ship 1 Missile));
  "repair" >:: (fun _ -> assert_equal 31 (repair_hull ship 1).hull);
  "get_weapon0" >:: (fun _ -> assert_equal (Some ion)
    (get_weapon ship 0));
  "get_weapon1" >:: (fun _ -> assert_equal None
    (get_weapon ship 2));
  "add_weapon" >:: (fun _ -> assert_equal
    {ship with inventory = weap::ship.inventory}
    (add_weapon ship weap));
  "equip" >:: (fun _ -> assert_equal
    {ship with inventory = weap::ship.inventory; equipped =weap::ship.equipped}
    (equip (add_weapon ship weap) 0 0));
  "unequip" >:: (fun _ -> assert_equal
    {ship with equipped = []} (unequip ship 0));
  "charge_weapons" >:: (fun _ -> assert_equal
    {ship with equipped = [{ion with charge = 1}]} (charge_weapons ship));
  "weapon_ready0" >:: (fun _ -> assert_equal false (weapon_ready ship 0));
  "weapon_ready1" >:: (fun _ -> assert_equal true
    (weapon_ready (charge_weapons ship |> charge_weapons) 0));
  "fire_weapon0" >:: (fun _ -> assert_equal ship (fire_weapon ship 0));
  "fire_weapon1" >:: (fun _ -> assert_equal ship 
    (fire_weapon (charge_weapons ship |> charge_weapons) 0));

(*----------------------system functions---------------------------*)

  "set_shield_power" >:: (fun _ -> assert_equal 2
    (set_shield_power ship 2).systems.shield_power);
  "set_engine_power" >:: (fun _ -> assert_equal 2
    (set_engine_power ship 2).systems.engine_power);
  "set_weapons_power" >:: (fun _ -> assert_equal 2
    (set_weapons_power ship 2).systems.weapons_power);
  "set_shield_level" >:: (fun _ -> assert_equal 2
    (set_shield_level ship 2).systems.shield_level);
  "set_engine_level" >:: (fun _ -> assert_equal 2
    (set_engine_level ship 2).systems.engine_level);
  "set_weapons_level" >:: (fun _ -> assert_equal 2
    (set_weapons_level ship 2).systems.weapons_level);
  "repair_systems" >:: (fun _ -> assert_equal ship
    (repair_systems damaged_ship));

(*----------------------augmentation functions---------------------*)

  "add_augmentation" >:: (fun _ -> assert_equal
    {ship with augmentations = test_aug::[]}
    (add_augmentation ship test_aug));
  "get_augmentation0" >:: (fun _ -> assert_equal (Some test_aug)
    (get_augmentation (add_augmentation ship test_aug) 0));
  "get_augmentation1" >:: (fun _ -> assert_equal None
    (get_augmentation ship 0));

(*----------------------crew functions-----------------------------*)

  "get_person0" >:: (fun _ -> assert_equal (Some dude)
    (get_person ship 0));
  "get_person1" >:: (fun _ -> assert_equal None
    (Ship.get_person ship 1));

]

let tests = "test suite" >::: List.flatten [
  galaxy_tests;
  store_tests;
  event_tests;
  ship_tests;
]

let _ = run_test_tt_main tests
