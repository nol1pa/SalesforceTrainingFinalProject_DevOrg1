@isTest
public class ToDoTriggerTest {
    @isTest
    public static void testBeforeUpdate() {
        ToDo__c[] todos = new List<ToDo__c>();
        for(Integer i = 0; i < 10; i++){
            todos.add(
                TestDataFactory.TODO.createDummyTodo('Todo' + i, null, null, false)
            );
        }
        for(ToDo__c todo : todos){
            todo.Connected_Org_Record_Id__c = 'SomeString';
        }
        insert todos;
        for(ToDo__c todo : todos){
            todo.Connected_Org_Record_Id__c = 'AnotherString';
        }
        update todos;
        for(ToDo__c todo : todos){
            System.assertEquals('SomeString', todo.Connected_Org_Record_Id__c);
        }
    }
    @isTest
    public static void testAfterInsertFuture(){
        
    }
}
