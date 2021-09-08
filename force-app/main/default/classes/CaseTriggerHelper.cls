public class CaseTriggerHelper {

    //add SubToDo creating from ToDoHelper

    public static void addToDoFromEmail(List<Case> newCases){
        List<ToDo__c> newToDos = new List<ToDo__c>();
        
        for(Case newCase : newCases){
            if(newCase.Origin == 'Email') {
                ToDo__c todo = new ToDo__c();
                todo.Name = newCase.Subject;
                todo.Is_Done__c = false;
                todo.OwnerId = newCase.OwnerId;
                todo.Description_For_SubToDo__c = newCase.Description;
                newToDos.add(todo);
            }
        }
        if(!newToDos.isEmpty()){
            insert newToDos;
        }
    }
}