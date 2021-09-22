trigger SubToDoTrigger on SubToDo__c (after insert, after update, before delete) {
    
	if(!Test.isRunningTest()){
        if(Trigger.isBefore && Trigger.isDelete){
            
               SubToDoTriggerHandler.handleBeforeDelete(Trigger.oldMap);
        }
        if(Trigger.isAfter && Trigger.isInsert){
            
               SubToDoTriggerHandler.handleAfterInsert(Trigger.newMap);
        }
        if(Trigger.isAfter && Trigger.isUpdate){
           
               SubToDoTriggerHandler.handleAfterUpdate(Trigger.newMap);
        }
	}
}