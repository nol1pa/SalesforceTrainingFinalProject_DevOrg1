public class CaseTriggerHelper {
    public static void addToDoFromEmail(List<Case> newCases){
        Map<Id, ToDo__c> cIdTodoMap = new Map<Id, ToDo__c>();
        for(Case newCase : newCases){
            String priority = newCase.Description;
            if(newCase.Origin == 'Email') {
                List<String> recordTypesFromSubject = newCase.Subject.split(',');
                if (recordTypesFromSubject.size() > 1){
                    String recordType = recordTypesFromSubject.get(1).trim().toLowerCase();
                    switch on recordType{
                        when 'development'{
                            cIdTodoMap.put(newCase.Id, 
                			new ToDo__c(Name = recordTypesFromSubject.get(0), OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSTAAY', Priority__c = priority));
                        }
                        when 'administration'{
                            cIdTodoMap.put(newCase.Id, 
                			new ToDo__c(Name = recordTypesFromSubject.get(0), OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSYAAY', Priority__c = priority));
                        }
                        when 'management'{
                            cIdTodoMap.put(newCase.Id, 
                			new ToDo__c(Name = recordTypesFromSubject.get(0), OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSdAAI', Priority__c = priority));
                        }
                        when else{
                            cIdTodoMap.put(newCase.Id, 
                			new ToDo__c(Name = newCase.Subject, OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSdAAI', Priority__c = priority));
                        }
                    }
                } else {
                    cIdTodoMap.put(newCase.Id, 
                	new ToDo__c(Name = newCase.Subject, OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSdAAI', Priority__c = priority));
                }
            }
        }
        insert cIdTodoMap.values();
    }
}