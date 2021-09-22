@isTest
public class ToDoTriggerTest {
    @isTest
    public static void testBeforeUpdate() {
        ToDo__c[] todos = new List<ToDo__c>();
        for(Integer i = 0; i < 10; i++){
            todos.add(
                TestDataFactory.TODO.createDummyTodo('Todo' + i, '0125g000001qnSTAAY', false)
            );
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
        // ToDo__c[] newTodos = [SELECT Id, Connected_Org_Record_Id__c FROM ToDo__c];
        for(Integer i = 0; i < todos.size(); i++){
            System.assertEquals('SomeString' + i, todos.get(i).Connected_Org_Record_Id__c);
        }
    }
    @isTest
    public static void testAfterInsertFuture(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('TodosResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        ToDoTriggerHandlerHelper.handleAfterInsert_future(new Set<Id>());
        Test.stopTest();
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
