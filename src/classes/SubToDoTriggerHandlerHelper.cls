public with sharing class SubToDoTriggerHandlerHelper {
    
     /*public static Map<Id, ToDo__c> getMapOfSubtodosTodos(List<SubToDo__c> subtodos){
        List<Id> todoIds = new List<Id>();
        for(SubToDo__C sub : subtodos){
            todoIds.add(sub.ToDo__c);
        }
        //select todos which have subtodos from request
        List<ToDo__c> todosOfSubtodos = 
            new List<ToDo__c>([select id, Connected_Org_Record_Id__c from ToDo__c where Connected_Org_Record_Id__c in: todoIds]);
        
        Map<Id, ToDo__c> mapTodos = new Map<Id, ToDo__c>();
       	for(ToDo__c tod : todosOfSubtodos){
               mapTodos.put(tod.Connected_Org_Record_Id__c, tod);
        }
        return mapTodos;
    }*/
    

    @future(callout=true)
    public static void handleAfterInsert_future(Set<Id> ids){
        Map<Id, SubToDo__c> subtodosMap = new Map<Id, SubToDo__c>([
                SELECT Name, Description__c, Is_Done__c, Priority__c,
                        Image_URL__c, Connected_Org_Record_Id__c, ToDo__c
                FROM SubToDo__c
                WHERE Id IN :ids
        ]);
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:devorg_2_credential/services/apexrest/subtodoapi/');
        req.setMethod('POST');
        req.setHeader('Content-type', 'application/json;charset=UTF-8');
        req.setBody(JSON.serialize(subtodosMap.values()));
        Http http = new Http();
        HttpResponse resp = http.send(req);
        List<SubToDo__c> syncedSubtodos =
                (List<SubToDo__c>) JSON.deserialize(resp.getBody(), List<SubToDo__c>.class);
        for (SubToDo__c subtodo : syncedSubtodos) {
            subtodosMap.get(subtodo.Connected_Org_Record_Id__c).
            Connected_Org_Record_Id__c = subtodo.Id;
        }
        update subtodosMap.values();
    }
     
    @future(callout = true)
    public static void handleAfterUpdate_future(Set<Id> ids) {
        List<SubToDo__c> subtodos = [
                SELECT Name, Description__c, Is_Done__c, Priority__c,
                        Image_URL__c, Connected_Org_Record_Id__c, ToDo__c
                FROM SubToDo__c
                WHERE Id IN :ids
        ];
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:devorg_2_credential/services/apexrest/subtodoapi/');
        req.setMethod('PATCH');
        req.setHeader('Content-type', 'application/json;charset=UTF-8');
        req.setBody(JSON.serialize(subtodos));
        Http http = new Http();
        HttpResponse resp = http.send(req);
    }
    
	@future(callout = true)
    public static void handleBeforeDelete_future(Set<Id> ids) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:devorg_2_credential/services/apexrest/subtodoapi/');
        req.setMethod('DELETE');
        req.setHeader('Content-type', 'application/json;charset=UTF-8');
        req.setBody(JSON.serialize(ids));
        Http http = new Http();
        HttpResponse resp = http.send(req);
    }    
	    
}