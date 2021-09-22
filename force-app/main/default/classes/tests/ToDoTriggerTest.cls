@isTest
public class ToDoTriggerTest {
    @isTest
    public static void testBeforeUpdate() {
        ToDo__c[] todos = new List<ToDo__c>();
        for(Integer i = 0; i < 10; i++){
            todos.add(new ToDo__c(Name = 'Todo' + i));
        }
        for(Integer i = 0; i < todos.size(); i++){
            todos.get(i).Connected_Org_Record_Id__c = 'SomeString' + i;
        }
        insert todos;
        for(Integer i = 0; i < todos.size(); i++){
            todos.get(i).Connected_Org_Record_Id__c = 'AnotherString' + i;
        }
        Test.startTest();
        update todos;
        Test.stopTest();
        ToDo__c[] newTodos = [SELECT Id, Connected_Org_Record_Id__c FROM ToDo__c];
        for(Integer i = 0; i < newTodos.size(); i++){
            System.assertEquals('SomeString' + i, newTodos.get(i).Connected_Org_Record_Id__c);
        }
    }
    @isTest
    public static void testAfterInsertFuture(){
        ToDo__c[] todos = new List<ToDo__c>();
        for(Integer i = 0; i < 5; i++){
            todos.add(
                new ToDo__c(Name = 'Todo' + i, RecordTypeId = '0125g000001qnSTAAY')
            );
        }
        insert todos;
        Map<Id, ToDo__c> todoMap = new Map<Id, ToDo__c>([SELECT Id FROM ToDo__c]);
        Test.setMock(HttpCalloutMock.class, new TodoHttpMock());
        Test.startTest();
        ToDoTriggerHandlerHelper.handleAfterInsert_future(todoMap.keySet());
        Test.stopTest();
        ToDo__c[] newTodos = [SELECT Id, Connected_Org_Record_Id__c FROM ToDo__c];
        for(ToDo__c todo : newTodos){
            System.assertEquals(todo.Id, todo.Connected_Org_Record_Id__c);
        }
    }
    @isTest
    public static void testAfterUpdateFuture(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('TodosResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        ToDoTriggerHandlerHelper.handleAfterUpdate_future(new Set<Id>());
        Test.stopTest();
    }
    @isTest
    public static void testBeforeDeleteFuture(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('TodosResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        ToDoTriggerHandlerHelper.handleBeforeDelete_future(new Set<Id>());
        Test.stopTest();
    }
}