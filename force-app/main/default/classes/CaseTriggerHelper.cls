public class CaseTriggerHelper {
    public static void addToDoFromEmail(List<Case> newCases){
        Map<Id, ToDo__c> cIdTodoMap = new Map<Id, ToDo__c>();
        for(Case newCase : newCases){
            if(newCase.Origin == 'Email') {
                cIdTodoMap.put(newCase.Id, 
                new ToDo__c(Name = newCase.Subject, OwnerId = newCase.OwnerId));
            }
        }
        insert cIdTodoMap.values();
        SubToDo__c[] subtodos = new List<SubToDo__c>();
        for(Case newCase : newCases){
            if(newCase.Origin == 'Email'){
                for(String str : newCase.Description.split(',')){
                    subtodos.add(new SubToDo__c(
                        Name = str, 
                        ToDo__c = cIdTodoMap.get(newCase.Id).Id
                    ));
                }
            }
        }
        insert subtodos;
    }
}