trigger ToDoTrigger on ToDo__c (
    after insert, 
    after update, 
    before update, 
    before delete
) {
    new ToDoTriggerHandler().handleAction();
}