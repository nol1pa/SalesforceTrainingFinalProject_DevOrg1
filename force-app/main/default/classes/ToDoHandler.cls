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
    @AuraEnabled(cacheable=true)
    public static ToDo__c updateTodo(ToDo__c todo){
        update todo;
        return todo;
    }
    @AuraEnabled(cacheable=true)
    public static SubToDo__c updateSubTodo(SubToDo__c subtodo){
        update subtodo;
        return subtodo;
    }
}
