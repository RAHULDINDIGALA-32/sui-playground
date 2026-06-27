#[test_only]
module todo_list::todo_list_tests;

use todo_list::todo_list;
use std::string;
use sui::test_scenario::{Self as ts};

const OWNER: address = @0xA;

#[test]
fun new_creates_empty_list() {
    let mut scenario = ts::begin(OWNER);

    let list = todo_list::new(scenario.ctx());

    assert!(list.length() == 0);

    todo_list::delete(list);
    scenario.end();
}

#[test]
fun add_appends_items_in_order() {
    let mut scenario = ts::begin(OWNER);
    let mut list = todo_list::new(scenario.ctx());

    list.add(b"Write Move tests".to_string());
    list.add(b"Run Sui test suite".to_string());
    list.add(string::utf8(b"Ship package"));

    assert!(list.length() == 3);
    assert!(list.item(0) == b"Write Move tests".to_string());
    assert!(list.item(1) == b"Run Sui test suite".to_string());
    assert!(list.item(2) == string::utf8(b"Ship package"));

    todo_list::delete(list);
    scenario.end();
}

#[test]
fun remove_returns_item_and_shifts_remaining_items() {
    let mut scenario = ts::begin(OWNER);
    let mut list = todo_list::new(scenario.ctx());

    list.add(b"first".to_string());
    list.add(b"second".to_string());
    list.add(b"third".to_string());

    let removed = list.remove(1);

    assert!(removed == b"second".to_string());
    assert!(list.length() == 2);
    assert!(list.item(0) == b"first".to_string());
    assert!(list.item(1) == b"third".to_string());

    todo_list::delete(list);
    scenario.end();
}

#[test]
fun mutations_preserve_list_identity() {
    let mut scenario = ts::begin(OWNER);
    let mut list = todo_list::new(scenario.ctx());
    let list_id = list.id();

    list.add(b"draft".to_string());
    list.add(b"review".to_string());
    list.remove(0);
    list.add(b"publish".to_string());

    assert!(list.id() == list_id);
    assert!(list.length() == 2);
    assert!(list.item(0) == b"review".to_string());
    assert!(list.item(1) == b"publish".to_string());

    todo_list::delete(list);
    scenario.end();
}

#[test]
fun delete_consumes_empty_and_non_empty_lists() {
    let mut scenario = ts::begin(OWNER);

    let empty_list = todo_list::new(scenario.ctx());
    todo_list::delete(empty_list);

    let mut populated_list = todo_list::new(scenario.ctx());
    populated_list.add(b"can be deleted".to_string());
    todo_list::delete(populated_list);

    scenario.end();
}
