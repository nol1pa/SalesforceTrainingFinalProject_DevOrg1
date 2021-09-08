public with sharing class ToDoHandler {
    @AuraEnabled(cacheable=true)
    public static List<ToDo__c> getAllTodosWithSubTodos(){
        return [
            SELECT Name, Description__c, Priority__c, Connected_Org_Record_Id__c,
            Image_URL__c, Is_Done__c, CreatedDate, (
                SELECT Name, Description__c, Priority__c, Connected_Org_Record_Id__c,
                Image_URL__c, Is_Done__c, CreatedDate
                FROM SubToDos__r
                ORDER BY Name
            )
            FROM ToDo__c
            ORDER BY Name
        ];
    }
    @AuraEnabled
    public static ToDo__c updateTodoWithSubTodos(
        ToDo__c todo, List<SubToDo__c> subtodos
    ){
        update todo;
        update subtodos;
        return todo;
    }
    @AuraEnabled
    public static ToDo__c updateTodo(ToDo__c todo){
        update todo;
        return todo;
    }
}