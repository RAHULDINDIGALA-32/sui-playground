#[test_only]
module hello_world::greetings_tests;

use hello_world::greeting::{Self, Greeting};
use std::string;
use sui::test_scenario::{Self as ts};

const ADMIN: address = @0xA;
const USER: address = @0xB;

#[test]
fun new_creates_shared_greeting_with_default_text() {
    let mut scenario = ts::begin(ADMIN);

    greeting::new(scenario.ctx());

    scenario.next_tx(ADMIN);
    {
        assert!(ts::has_most_recent_shared<Greeting>());

        let greeting = scenario.take_shared<Greeting>();
        assert!(greeting.text() == b"Hello World".to_string());

        ts::return_shared(greeting);
    };

    scenario.end();
}

#[test]
fun shared_greeting_can_be_updated() {
    let mut scenario = ts::begin(ADMIN);

    greeting::new(scenario.ctx());

    scenario.next_tx(USER);
    {
        let mut greeting = scenario.take_shared<Greeting>();

        greeting.update_text(b"GM, Sui!".to_string());
        assert!(greeting.text() == b"GM, Sui!".to_string());

        ts::return_shared(greeting);
    };

    scenario.next_tx(ADMIN);
    {
        let greeting = scenario.take_shared<Greeting>();
        assert!(greeting.text() == b"GM, Sui!".to_string());

        ts::return_shared(greeting);
    };

    scenario.end();
}

#[test]
fun update_preserves_object_identity() {
    let mut scenario = ts::begin(ADMIN);

    greeting::new(scenario.ctx());

    scenario.next_tx(ADMIN);
    let greeting_id;
    {
        let mut greeting = scenario.take_shared<Greeting>();
        greeting_id = greeting.id();

        greeting.update_text(string::utf8(b"Updated without replacing object"));

        ts::return_shared(greeting);
    };

    scenario.next_tx(USER);
    {
        let greeting = scenario.take_shared_by_id<Greeting>(greeting_id);

        assert!(greeting.id() == greeting_id);
        assert!(greeting.text() == string::utf8(b"Updated without replacing object"));

        ts::return_shared(greeting);
    };

    scenario.end();
}
