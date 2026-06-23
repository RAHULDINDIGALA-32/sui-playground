#[test_only]
module hello_world::greeting_tests {

    use std::unit_test::assert_eq;
    use std::string::{Self, String};
    use hello_world::greeting::{Self, Greeting};
    use sui::test_scenario::{Self as ts, Ctx};
    use sui::object;
    use sui::transfer;

    #[test]
    fun test_greeting_creation() {
        let mut scenario = ts::begin(@0x1);
        let ctx = ts::ctx(&mut scenario);

        // Call new to create a greeting
        greeting::new(ctx);

        // Verify the greeting was created and shared
        let greeting_obj = ts::take_shared<Greeting>(&scenario);
        assert_eq(greeting_obj.text, string::utf8(b"Hello World"));
        
        ts::return_shared(greeting_obj);
        ts::end(scenario);
    }

    #[test]
    fun test_greeting_initial_text() {
        let mut scenario = ts::begin(@0x1);
        let ctx = ts::ctx(&mut scenario);

        greeting::new(ctx);

        let greeting_obj = ts::take_shared<Greeting>(&scenario);
        let text = greeting_obj.text;
        
        // Verify the initial text is exactly "Hello World"
        assert_eq(text, string::utf8(b"Hello World"));
        
        ts::return_shared(greeting_obj);
        ts::end(scenario);
    }

    #[test]
    fun test_update_greeting_text() {
        let mut scenario = ts::begin(@0x1);
        let ctx = ts::ctx(&mut scenario);

        greeting::new(ctx);

        let mut greeting_obj = ts::take_shared<Greeting>(&scenario);
        
        // Update the greeting text
        let new_text = string::utf8(b"Sui is awesome!");
        greeting::update_text(&mut greeting_obj, new_text);
        
        // Verify the text was updated
        assert_eq(greeting_obj.text, string::utf8(b"Sui is awesome!"));
        
        ts::return_shared(greeting_obj);
        ts::end(scenario);
    }

    #[test]
    fun test_update_greeting_multiple_times() {
        let mut scenario = ts::begin(@0x1);
        let ctx = ts::ctx(&mut scenario);

        greeting::new(ctx);

        let mut greeting_obj = ts::take_shared<Greeting>(&scenario);
        
        // First update
        greeting::update_text(&mut greeting_obj, string::utf8(b"First update"));
        assert_eq(greeting_obj.text, string::utf8(b"First update"));
        
        // Second update
        greeting::update_text(&mut greeting_obj, string::utf8(b"Second update"));
        assert_eq(greeting_obj.text, string::utf8(b"Second update"));
        
        // Third update
        greeting::update_text(&mut greeting_obj, string::utf8(b"Final message"));
        assert_eq(greeting_obj.text, string::utf8(b"Final message"));
        
        ts::return_shared(greeting_obj);
        ts::end(scenario);
    }

    #[test]
    fun test_greeting_has_valid_id() {
        let mut scenario = ts::begin(@0x1);
        let ctx = ts::ctx(&mut scenario);

        greeting::new(ctx);

        let greeting_obj = ts::take_shared<Greeting>(&scenario);
        
        // Verify the greeting has a valid ID (non-zero address)
        // The ID should be properly initialized by object::new
        assert_eq(object::is_id_initialized(&greeting_obj.id), true);
        
        ts::return_shared(greeting_obj);
        ts::end(scenario);
    }

    #[test]
    fun test_update_with_empty_string() {
        let mut scenario = ts::begin(@0x1);
        let ctx = ts::ctx(&mut scenario);

        greeting::new(ctx);

        let mut greeting_obj = ts::take_shared<Greeting>(&scenario);
        
        // Update with an empty string
        let empty_string = string::utf8(b"");
        greeting::update_text(&mut greeting_obj, empty_string);
        assert_eq(greeting_obj.text, string::utf8(b""));
        
        ts::return_shared(greeting_obj);
        ts::end(scenario);
    }

    #[test]
    fun test_update_with_long_string() {
        let mut scenario = ts::begin(@0x1);
        let ctx = ts::ctx(&mut scenario);

        greeting::new(ctx);

        let mut greeting_obj = ts::take_shared<Greeting>(&scenario);
        
        // Update with a longer string
        let long_text = string::utf8(b"This is a longer greeting message for testing purposes");
        greeting::update_text(&mut greeting_obj, long_text);
        assert_eq(greeting_obj.text, string::utf8(b"This is a longer greeting message for testing purposes"));
        
        ts::return_shared(greeting_obj);
        ts::end(scenario);
    }

}