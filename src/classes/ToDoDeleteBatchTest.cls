/**
 * Created by vladimirzhukovets on 22.09.21.
 */

@IsTest
private class ToDoDeleteBatchTest {
    @IsTest
    static void deleteOldToDoTest() {
        ToDo__c todo = TestDataFactory.TODO.createDummyTodo('Test todo', '0125g000001qnSTAAY','0055g00000CxaO8AAJ', true);

        Datetime yesterday = Datetime.now().addMonths(-5);
        Test.setCreatedDate(todo.Id, yesterday);

        Test.startTest();
        ToDoDeleteBatch tDeleteBatch = new ToDoDeleteBatch();
        Database.executeBatch(tDeleteBatch);
        ToDo__c expectedTodo = [SELECT Id, IsDeleted FROM ToDo__c WHERE Id = :todo.Id];
        System.assertEquals(expectedTodo.IsDeleted, true);
        Test.stopTest();
    }
}