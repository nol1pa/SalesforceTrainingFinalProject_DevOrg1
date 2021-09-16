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
    }
    @AuraEnabled(Cacheable=true)
    public static List<ToDo__c> findTodosWithSubTodos(String priorityKey, Boolean isDone) {
        String priorityKey = '%' + priorityKey + '%';
        Boolean isDone = isDone;
        return [
                SELECT Name, Description__c, Priority__c, Connected_Org_Record_Id__c,
                        Image_URL__c, Is_Done__c, CreatedDate, RecordTypeId, (
                        SELECT Name, Description__c, Priority__c, Connected_Org_Record_Id__c,
                                Image_URL__c, Is_Done__c, CreatedDate, ToDO__c
                        FROM SubToDos__r
                        ORDER BY CreatedDate
                )
                FROM ToDo__c
                WHERE Priority__c LIKE :priorityKey OR Is_Done__c = :isDone
                ORDER BY CreatedDate
        ];
    }

    @AuraEnabled
    public static ToDo__c updateTodoWithSubTodos(
            ToDo__c todo, List<SubToDo__c> subtodos
    ) {
        update todo;
        update subtodos;
        return todo;
    }
    @AuraEnabled
    public static ToDo__c updateTodo(ToDo__c todo) {
        update todo;
        return todo;
    }
}