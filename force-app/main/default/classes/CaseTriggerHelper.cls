public class CaseTriggerHelper {

    public static void addToDoFromEmail(List<Case> newCases){
        Map<Id, ToDo__c> cIdTodoMap = new Map<Id, ToDo__c>();
        for(Case newCase : newCases){
            if(newCase.Origin == 'Email') {
                List<String> recordTypesFromSubject = newCase.Subject.split(',');
                if (recordTypesFromSubject.size() > 1){
                    String recordType = recordTypesFromSubject.get(1).trim().toLowerCase();
                    switch on recordType{
                        when 'development'{
                            cIdTodoMap.put(newCase.Id, 
                			new ToDo__c(Name = recordTypesFromSubject.get(0), OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSTAAY'));
                        }
                        when 'administration'{
                            cIdTodoMap.put(newCase.Id, 
                			new ToDo__c(Name = recordTypesFromSubject.get(0), OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSYAAY'));
                        }
                        when 'management'{
                            cIdTodoMap.put(newCase.Id, 
                			new ToDo__c(Name = recordTypesFromSubject.get(0), OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSdAAI'));
                        }
                        when else{
                            cIdTodoMap.put(newCase.Id, 
                			new ToDo__c(Name = newCase.Subject, OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSdAAI'));
                        }
                    }
                } else {
                    cIdTodoMap.put(newCase.Id, 
                	new ToDo__c(Name = newCase.Subject, OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSdAAI'));
                }
                
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