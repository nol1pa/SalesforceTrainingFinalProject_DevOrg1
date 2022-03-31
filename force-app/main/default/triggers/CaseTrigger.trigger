trigger CaseTrigger on Case (
    	before insert,
		before update,
		before delete,
		after insert,
		after update,
		after delete,
		after undelete) {
        
//        if (Trigger.isBefore && Trigger.isInsert){
//            CaseTriggerHandler.handleBeforeInsert(Trigger.new);
//        }
//
//        if (Trigger.isBefore && Trigger.isUpdate){
//            CaseTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
//        }
//
//        if (Trigger.isBefore && Trigger.isDelete){
//            CaseTriggerHandler.handleBeforeDelete(Trigger.old, Trigger.oldMap);
//        }
        
        if (Trigger.isAfter && Trigger.isInsert){
            CaseTriggerHandler.handleAfterInsert(Trigger.new, Trigger.newMap);
        }
        
//        if (Trigger.isAfter && Trigger.isUpdate){
//            CaseTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
//        }
//
//        if (Trigger.isAfter && Trigger.isDelete){
//            CaseTriggerHandler.handleAfterDelete(Trigger.old, Trigger.oldMap);
//        }
//
//        if (Trigger.isAfter && Trigger.isUndelete){
//            CaseTriggerHandler.handleAfterUndelete(Trigger.new, Trigger.newMap);
//        }
}