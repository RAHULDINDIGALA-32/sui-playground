/// Module: todo_list
module todo_list::todo_list;

/// List of todos. Can be managed by the owner and shared with others.
public struct TodoList has key, store {
    id: UID,
    items: vector<std::string::String>
}

/// Create a new todo list.
public fun new(ctx: &mut TxContext): TodoList {
    let list = TodoList {
        id: object::new(ctx),
        items: vector[]
    };

    (list)
}

/// Add a new todo item to the list.
public fun add(list: &mut TodoList, item: std::string::String) {
    list.items.push_back(item);
}

/// Remove a todo item from the list by index.
public fun remove(list: &mut TodoList, index: u64): std::string::String {
    list.items.remove(index)
}

/// Delete the list and the capability to manage it.
public fun delete(list: TodoList) {
    let TodoList { id, items: _ } = list;
    id.delete();
}

/// Get the number of items in the list.
public fun length(list: &TodoList): u64 {
    list.items.length()
}

#[test_only]
public fun item(list: &TodoList, index: u64): std::string::String {
    *list.items.borrow(index)
}

#[test_only]
public fun id(list: &TodoList): ID {
    list.id.uid_to_inner()
}
