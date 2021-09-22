/**
 * Created by vladimirzhukovets on 22.09.21.
 */

@IsTest
private class ToDoHandlerTest {
    @IsTest
    static void findTodosWithSubTodosTest() {
        Todo__c todo = new Todo__c(Name = 'Test todo', Priority__c = 'Low');
        insert todo;

        todo = [
                SELECT CreatedDate,
                        Name,
                        Priority__c
                FROM ToDo__c
                WHERE Id = :todo.Id
        ];

        Datetime yesterday = Datetime.now().addMonths(-1);

        Test.setCreatedDate(todo.Id, yesterday);

        todo = [
                SELECT CreatedDate,
                        Name,
                        Priority__c
                FROM ToDo__c
                WHERE Id = :todo.Id
        ];

        String nameKey = 'Test todo';
        String priorityKey = 'Low';
        Datetime startDateKey = Datetime.now().addMonths(-2);
        Datetime endDateKey = Datetime.now().addMonths(1);
        System.debug(nameKey + ' ' + priorityKey + ' ' + startDateKey + ' ' + endDateKey);

        List<ToDo__c> todos = ToDoHandler.findTodosWithSubTodos(nameKey, priorityKey, startDateKey, endDateKey);

        Todo__c td = [SELECT Id, Priority__c, CreatedDate, Name FROM ToDo__c WHERE Id = :todo.Id ALL ROWS];

        System.assertEquals(todo.Name, td.Name);
        System.assertEquals(todo.Priority__c, td.Priority__c);
        System.assertEquals(todo.CreatedDate, td.CreatedDate);
    }
}