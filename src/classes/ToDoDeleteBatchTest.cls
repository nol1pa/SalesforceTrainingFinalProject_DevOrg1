/**
 * Created by vladimirzhukovets on 22.09.21.
 */

@IsTest
private class ToDoDeleteBatchTest {
    @IsTest
    static void deleteOldToDoTest() {
        ToDo__c todo = TestDataFactory.TODO.createDummyTodo('Test todo', '0125g000001qnSTAAY', 'Low', false);

        insert todo;

        todo = [
                SELECT CreatedDate,
                        Name
                FROM ToDo__c
                WHERE Id = :todo.Id
        ];

        System.debug(todo);

        Datetime yesterday = Datetime.now().addMonths(-10);
        System.debug(yesterday);
        System.debug('before ' + todo.CreatedDate);

        Test.setCreatedDate(todo.Id, yesterday);

        todo = [
                SELECT CreatedDate,
                        Name
                FROM ToDo__c
                WHERE Id = :todo.Id
        ];

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('TodosResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        ToDoDeleteBatch tDeleteBatch = new ToDoDeleteBatch();
        Database.executeBatch(tDeleteBatch);
        Test.stopTest();

        ToDo__c expectedTodo = [SELECT Id, IsDeleted FROM ToDo__c WHERE Id = :todo.Id ALL ROWS];
        System.assertEquals(true, expectedTodo.IsDeleted);
    }
}