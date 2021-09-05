public with sharing class ToDoTriggerHandler {
    private static String context;
    public ToDoTriggerHandler() {
        setTriggerContext();
    }
    private void setTriggerContext(){
        if(Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert){
            context = 'after_insert';
        }
        if(Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate){
            context = 'after_update';
        }
        if(Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete){
            context = 'before_delete';
        }
    }
    public void handleAction(){
        if(!System.isFuture()){
        switch on context {
            when 'after_insert' {
                ToDoTriggerHandlerHelper.handleAfterInsert_future(
                    Trigger.newMap.keySet()
                );
            }
            when 'after_update' {
                ToDoTriggerHandlerHelper.handleAfterUpdate_future(
                    Trigger.newMap.keySet()
                );
            }
            when 'before_delete'{
                ToDoTriggerHandlerHelper.handleBeforeDelete_future(
                    Trigger.oldMap.keySet()
                );
            }
        }
    }
    }
}
