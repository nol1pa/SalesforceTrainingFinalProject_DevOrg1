@IsTest
public class SubToDoHandlerTest {
	
    @IsTest(SeeAllData=false)
    public static void getSubtodosOfTodosTest(){
        
        ToDo__c expectedTodo1 = TestDataFactory.TODO.createDummyTodo('Test todo1', '0125g000001qnSTAAY','0055g00000CxaO8AAJ', true);
        ToDo__c expectedTodo2 = TestDataFactory.TODO.createDummyTodo('Test todo2', '0125g000001qnSTAAY','0055g00000CxaO8AAJ', true);
        SubToDo__c expectedSubTodo1 = TestDataFactory.SUBTODO.createDummySubTodo('Test subtodo1', false);
        SubToDo__c expectedSubTodo2 = TestDataFactory.SUBTODO.createDummySubTodo('Test subtodo2', false);
        expectedSubTodo1.ToDo__c = expectedTodo1.id;
        expectedSubTodo2.ToDo__c = expectedTodo1.id;
        insert expectedSubTodo1;
        insert expectedSubTodo2;
		 
        String aimTodo = [SELECT Id, Name FROM ToDo__c WHERE Name =: 'Test todo1'].get(0).id;
        Test.startTest();
        List<SubToDo__c> subs = SubToDoHandler.getSubToDosOfTodo(aimTodo);
        Test.stopTest();
        System.assertEquals(2, subs.size());
        System.assertEquals(0, subs.size());
        
    }
    
    
    
    
}