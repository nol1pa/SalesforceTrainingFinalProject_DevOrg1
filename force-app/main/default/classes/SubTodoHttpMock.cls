@isTest
global class SubTodoHttpMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-type', 'application/json;charset=UTF-8');
        
        Map<Id, SubToDo__c> subtodoMap = new Map<Id, SubToDo__c>([SELECT Id FROM SubToDo__c]);
        for(SubToDo__c subtodo : subtodoMap.values()){
            subtodo.Connected_Org_Record_Id__c = subtodo.Id;
        }
        res.setBody(JSON.serialize(subtodoMap.values()));
        res.setStatusCode(200);
        return res;
    }
}