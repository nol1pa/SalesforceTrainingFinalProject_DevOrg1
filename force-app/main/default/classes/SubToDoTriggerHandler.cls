public with sharing class SubToDoTriggerHandler {
    //call future methods from helper 
    
    public static void handleBeforeDelete(Map<Id,SubToDo__c> oldSubToDoMap){
        if(!System.isFuture()){
           SubToDoTriggerHandlerHelper.handleBeforeDelete_future(oldSubToDoMap.keySet());
        }
    }

    public static void handleAfterInsert(Map<Id,SubToDo__c> newSubToDoMap) {
        if(!System.isFuture()){ 
            SubToDoTriggerHandlerHelper.handleAfterInsert_future(newSubToDoMap.keySet());
        }
    }

    public static void handleAfterUpdate(Map<Id,SubToDo__c> newSubToDoMap) {
        if(!System.isFuture()){ 
           SubToDoTriggerHandlerHelper.handleAfterUpdate_future(newSubToDoMap.keySet());
        }
    }

  
}