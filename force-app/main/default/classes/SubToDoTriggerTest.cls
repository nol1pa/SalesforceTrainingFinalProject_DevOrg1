@IsTest
public with sharing class SubToDoTriggerTest {

    @isTest
    public static void testAfterInsertFuture(){
        
        //селектнуть существующую тудуху
        ToDo__c todo = new ToDo__c(Name='testTodo');
        insert todo;

        SubToDo__c[] subtodos = new List<SubToDo__c>();
        for(Integer i = 0; i < 5; i++){
            subtodos.add(
                new SubToDo__c(Name = 'SubTodo' + i, ToDo__c = todo.Id)
            );
        }
        insert subtodos;
        Map<Id, SubToDo__c> subtodoMap = new Map<Id, SubToDo__c>([SELECT Id FROM SubToDo__c]);
        Test.setMock(HttpCalloutMock.class, new SubTodoHttpMock());
        Test.startTest();
        SubToDoTriggerHandlerHelper.handleAfterInsert_future(subtodoMap.keySet());
        Test.stopTest();
        SubToDo__c[] newSubTodos = [SELECT Id, Connected_Org_Record_Id__c FROM SubToDo__c];
        for(SubToDo__c subtodo : newSubTodos){
            System.assertEquals(subtodo.Id, subtodo.Connected_Org_Record_Id__c);
        }
    }

    @isTest
    public static void testAfterUpdateFuture(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SubtodosResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        SubToDoTriggerHandlerHelper.handleAfterUpdate_future(new Set<Id>());
        Test.stopTest();
    }
    @isTest
    public static void testBeforeDeleteFuture(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SubtodosResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        SubToDoTriggerHandlerHelper.handleBeforeDelete_future(new Set<Id>());
        Test.stopTest();
    }
}