@isTest
global class TodoHttpMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-type', 'application/json;charset=UTF-8');
        Map<Id, ToDo__c> todoMap = new Map<Id, ToDo__c>([SELECT Id FROM ToDo__c]);
        for(ToDo__c todo : todoMap.values()){
            todo.Connected_Org_Record_Id__c = todo.Id;
        }
        res.setBody(JSON.serialize(todoMap.values()));
        res.setStatusCode(200);
        return res;
    }
}