/**
 * Created by vladimirzhukovets on 22.09.21.
 */

@IsTest
private class ToDoDeleteBatchTest {
    @IsTest
    static void deleteOldToDoTest() {
        ToDo__c todo = TestDataFactory.TODO.createDummyTodo('Test todo', '0125g000001qnSTAAY', 'Low', false);

        insert todo;
        System.debug(todo);

        todo = [
                select CreatedDate,
                        Name
                from ToDo__c
                where Id = :todo.Id
        ];

        System.debug(todo);

        Datetime yesterday = Datetime.now().addMonths(-10);
        System.debug(yesterday);
        System.debug('before ' + todo.CreatedDate);

        Test.setCreatedDate(todo.Id, yesterday);

        todo = [
                select CreatedDate,
                        Name
                from ToDo__c
                where Id = :todo.Id
        ];

        System.debug('newT: ' + todo);

        system.debug(todo.CreatedDate + ' expected');

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('TodosResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        ToDoDeleteBatch tDeleteBatch = new ToDoDeleteBatch();
        Database.executeBatch(tDeleteBatch);
//        List<ToDo__c> expectedTodo = [SELECT Id, IsDeleted FROM ToDo__c WHERE Id = :todo.Id];
//        System.assertEquals(true, expectedTodo.get(0).IsDeleted);
        Test.stopTest();

        List<ToDo__c> expectedTodo = [SELECT Id, IsDeleted FROM ToDo__c WHERE Id = :todo.Id];
        System.assertEquals(true, expectedTodo.get(0).IsDeleted);
    }
}