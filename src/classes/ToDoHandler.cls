public with sharing class ToDoHandler {
    @AuraEnabled(cacheable=true)
    public static List<ToDo__c> getAllTodosWithSubTodos() {
        return [
                SELECT Name, Description__c, Priority__c, Connected_Org_Record_Id__c,
                        Image_URL__c, Is_Done__c, CreatedDate, RecordTypeId, (
                        SELECT Name, Description__c, Priority__c, Connected_Org_Record_Id__c,
                                Image_URL__c, Is_Done__c, CreatedDate, ToDO__c
                        FROM SubToDos__r
                        ORDER BY CreatedDate
                )
                FROM ToDo__c
                ORDER BY CreatedDate
        ];
        // return new List<ToDo__c>();
    }
    @AuraEnabled(Cacheable=true)
    public static List<ToDo__c> findTodosWithSubTodos(String priorityKey, String nameKey, Datetime startDateKey, Datetime endDateKey) {
        //String getQuery = query;
        String keyForPriority = '%' + priorityKey + '%';
        Datetime keyForStartDate = startDateKey;
        Datetime keyForEndDate = endDateKey;
        String keyForName = '%' + nameKey + '%';

        return [
                SELECT Name, Description__c, Priority__c, Connected_Org_Record_Id__c,
                        Image_URL__c, Is_Done__c, CreatedDate, RecordTypeId, (
                        SELECT Name, Description__c, Priority__c, Connected_Org_Record_Id__c,
                                Image_URL__c, Is_Done__c, CreatedDate, ToDO__c
                        FROM SubToDos__r
                        ORDER BY CreatedDate
                )
                FROM ToDo__c
                WHERE Priority__c LIKE :keyForPriority AND
                      Name LIKE :keyForName AND
                      CreatedDate >= :keyForStartDate AND
                      CreatedDate <= :keyForEndDate
                ORDER BY CreatedDate
        ];
        // return new List<ToDo__c>();

        //return Database.query(getQuery);
    }

    @AuraEnabled(Cacheable=true)
    public static ToDo__c getTodoById(String todoId) {
        return [
                SELECT Name, Description__c, Priority__c, Connected_Org_Record_Id__c,
                        Image_URL__c, Is_Done__c, CreatedDate, RecordTypeId, RecordType.Name, Owner.Name
                FROM ToDo__c
                WHERE Id =: todoId 
                limit 1
        ];
        // return new ToDo__c();
    }



    @AuraEnabled
    public static ToDo__c updateTodoWithSubTodos(
            ToDo__c todo, List<SubToDo__c> subtodos
    ) {
        update todo;
        update subtodos;
        return todo;
        // return new ToDo__c();
    }
    @AuraEnabled
    public static ToDo__c updateTodo(ToDo__c todo) {
        update todo;
        return todo;
        // return new ToDo__c();
    }
}