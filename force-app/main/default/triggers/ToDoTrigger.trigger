trigger ToDoTrigger on SOBJECT (after insert, after update, after delete) {
    new ToDoTriggerHandler().handleAction();
}