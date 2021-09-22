public with sharing class ToDoTriggerHandlerHelper {
        public static void handleBeforeUpdate(){
                for(ToDo__c todo : (List<ToDo__c>)Trigger.new){
                        todo.Connected_Org_Record_Id__c = 
                        ((Map<Id, ToDo__C>)Trigger.oldMap).get(todo.Id).Connected_Org_Record_Id__c;
                }
        }
    
   		public static void setAfterInsertQueueByRecordType(Set<Id> ids){
        	List<ToDo__c> todos = new List<ToDo__c>([
                SELECT Name, Description__c, Is_Done__c, Priority__c,
                        Image_URL__c, Connected_Org_Record_Id__c, RecordTypeId
                FROM ToDo__c
                WHERE Id IN :ids]);
            
            Map<String, Id> recTypeIds = new Map<String, Id>();
            recTypeIds.put('Management', Schema.SObjectType.ToDo__c.getRecordTypeInfosByName().get('Management').getRecordTypeId());
            recTypeIds.put('Administration', Schema.SObjectType.ToDo__c.getRecordTypeInfosByName().get('Administration').getRecordTypeId());
            recTypeIds.put('Development', Schema.SObjectType.ToDo__c.getRecordTypeInfosByName().get('Development').getRecordTypeId());
            //Да, да, трожки говнокод, но пока хз, как это норм и удобно в коллекции оформить да и онли 6 запросов идет в бдху на транзакцию ОТСЮДАВА
            Group qMan = [SELECT Id FROM Group WHERE Name = 'Managequeue' and Type='Queue'];
            Group qDev = [SELECT Id FROM Group WHERE Name = 'Devqueue' and Type='Queue'];
            Group qAdm = [SELECT Id FROM Group WHERE Name = 'Adminqueue' and Type='Queue'];
            for(ToDo__c todo : todos){
                if(todo.RecordTypeId == recTypeIds.get('Management')){
                    todo.OwnerId = qMan.id; 
                }
                if(todo.RecordTypeId == recTypeIds.get('Development')){
                    todo.OwnerId = qDev.id;
                }
                if(todo.RecordTypeId == recTypeIds.get('Administration')){
                    todo.OwnerId = qAdm.id;
                }
            }
            update todos;
          
    	}
    
    
        @future(callout = true)
        public static void handleAfterInsert_future(Set<Id> ids) {
        Map<Id, ToDo__c> todosMap = new Map<Id, ToDo__c>([
                SELECT Name, Description__c, Is_Done__c, Priority__c,
                        Image_URL__c, Connected_Org_Record_Id__c, RecordType.Name
                FROM ToDo__c
                WHERE Id IN :ids
        ]);
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:devorg_2_credential/services/apexrest/todoapi/');
        req.setMethod('POST');
        req.setHeader('Content-type', 'application/json;charset=UTF-8');
        req.setBody(JSON.serialize(todosMap.values()));
        Http http = new Http();
        HttpResponse resp = http.send(req);
        List<ToDo__c> syncedTodos =
                (List<ToDo__c>) JSON.deserialize(resp.getBody(), List<ToDo__c>.class);
        for (ToDo__c todo : syncedTodos) {
            todosMap.get(todo.Connected_Org_Record_Id__c).
                    Connected_Org_Record_Id__c = todo.Id;
        }
        update todosMap.values();
    }
    @future(callout = true)
    public static void handleAfterUpdate_future(Set<Id> ids) {
        List<ToDo__c> todos = [
                SELECT Name, Description__c, Is_Done__c, Priority__c,
                        Image_URL__c, Connected_Org_Record_Id__c
                FROM ToDo__c
                WHERE Id IN :ids
        ];
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:devorg_2_credential/services/apexrest/todoapi/');
        req.setMethod('PATCH');
        req.setHeader('Content-type', 'application/json;charset=UTF-8');
        req.setBody(JSON.serialize(todos));
        Http http = new Http();
        HttpResponse resp = http.send(req);
    }
    @future(callout = true)
    public static void handleBeforeDelete_future(Set<Id> ids) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:devorg_2_credential/services/apexrest/todoapi/');
        req.setMethod('DELETE');
        req.setHeader('Content-type', 'application/json;charset=UTF-8');
        req.setBody(JSON.serialize(ids));
        Http http = new Http();
        HttpResponse resp = http.send(req);
    }
}