public with sharing class SubToDoHandler {

    @AuraEnabled(cacheable=true)
    public static List<SubToDo__c> getSubToDosOfTodo(Id todoId) {
        return [
                SELECT Name, Description__c, Priority__c, Connected_Org_Record_Id__c,
                        Image_URL__c, Is_Done__c, CreatedDate, ToDo__c, LastModifiedById
                FROM SubToDo__c
                WHERE ToDo__c =: todoId
        ];
    }
}