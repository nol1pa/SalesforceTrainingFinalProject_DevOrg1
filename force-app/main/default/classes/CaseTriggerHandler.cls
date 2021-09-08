public class CaseTriggerHandler {
    
    public static void handleBeforeInsert(List<Case> newList){
		
    }
    
    public static void handleBeforeUpdate(List<Case> newList, Map<Id, Case> newMap, List<Case> oldList, Map<Id, Case> oldMap){

    }
    
    public static void handleBeforeDelete(List<Case> oldList, Map<Id, Case> oldMap){

    }
    
    public static void handleAfterInsert(List<Case> newList, Map<Id, Case> newMap){
		CaseTriggerHelper.addToDoFromEmail(newList);
    }
    
    public static void handleAfterUpdate(List<Case> newList, Map<Id, Case> newMap, List<Case> oldList, Map<Id, Case> oldMap){

    }
    
    public static void handleAfterDelete(List<Case> oldList, Map<Id, Case> oldMap){

    }
    
    public static void handleAfterUndelete(List<Case> newList, Map<Id, Case> newMap){

    }

}