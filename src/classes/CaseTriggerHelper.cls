public class CaseTriggerHelper {
    // public class ToDoCreator_Queueable implements Queueable{
    //     public Map<Id, ToDo__c> cIdTodoMap = new Map<Id, ToDo__c>();
    //     public List<Case> newCases = new List<Case>();
    //     public ToDoCreator_Queueable(List<Case> cases){
    //         this.newCases = cases;
    //     }
    //     public void execute(QueueableContext context){
    //         for(Case newCase : newCases){
    //             if(newCase.Origin == 'Email') {
    //                 List<String> recordTypesFromSubject = newCase.Subject.split(',');
    //                 if (recordTypesFromSubject.size() > 1){
    //                     String recordType = recordTypesFromSubject.get(1).trim().toLowerCase();
    //                     switch on recordType{
    //                         when 'development'{
    //                             cIdTodoMap.put(newCase.Id, 
    //                             new ToDo__c(Name = recordTypesFromSubject.get(0), OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSTAAY'));
    //                         }
    //                         when 'administration'{
    //                             cIdTodoMap.put(newCase.Id, 
    //                             new ToDo__c(Name = recordTypesFromSubject.get(0), OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSYAAY'));
    //                         }
    //                         when 'management'{
    //                             cIdTodoMap.put(newCase.Id, 
    //                             new ToDo__c(Name = recordTypesFromSubject.get(0), OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSdAAI'));
    //                         }
    //                         when else{
    //                             cIdTodoMap.put(newCase.Id, 
    //                             new ToDo__c(Name = newCase.Subject, OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSdAAI'));
    //                         }
    //                     }
    //                 } else {
    //                     cIdTodoMap.put(newCase.Id, 
    //                     new ToDo__c(Name = newCase.Subject, OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSdAAI'));
    //                 }
                    
    //             }
    //         }
    //         insert cIdTodoMap.values();
    //         System.enqueueJob(new SubToDoCreator_Queueable(cIdTodoMap, newCases));
    //     }
    // }
    // public class SubToDoCreator_Queueable implements Queueable{
    //     public Map<Id, ToDo__c> cIdTodoMap = new Map<Id, ToDo__c>();
    //     public List<Case> newCases = new List<Case>();
    //     public SubToDoCreator_Queueable(Map<Id, ToDo__c> somemap, List<Case> cases){
    //         this.cIdTodoMap = somemap;
    //         this.newCases = cases;
    //     }
    //     public void execute(QueueableContext context){
    //         SubToDo__c[] subtodos = new List<SubToDo__c>();
    //         for(Case newCase : newCases){
    //             if(newCase.Origin == 'Email'){
    //                 for(String str : newCase.Description.split(',')){
    //                     subtodos.add(new SubToDo__c(
    //                         Name = str, 
    //                         ToDo__c = cIdTodoMap.get(newCase.Id).Id
    //                     ));
    //                 }
    //             }
    //         }
    //         insert subtodos;
    //     }
    // }

    public static void addToDoFromEmail(List<Case> newCases){
        // System.enqueueJob(new ToDoCreator_Queueable(newCases));
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
                			new ToDo__c(Name = recordTypesFromSubject.get(0), OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSTAAY', Priority__c = priority/*, Description__c = descriptions.get(0), Priority__c = descriptions.get(1)*/));
                        }
                        when 'administration'{
                            cIdTodoMap.put(newCase.Id, 
                			new ToDo__c(Name = recordTypesFromSubject.get(0), OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSYAAY', Priority__c = priority/*, Description__c = descriptions.get(0), Priority__c = descriptions.get(1)*/));
                        }
                        when 'management'{
                            cIdTodoMap.put(newCase.Id, 
                			new ToDo__c(Name = recordTypesFromSubject.get(0), OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSdAAI', Priority__c = priority/*, Description__c = descriptions.get(0), Priority__c = descriptions.get(1)*/));
                        }
                        when else{
                            cIdTodoMap.put(newCase.Id, 
                			new ToDo__c(Name = newCase.Subject, OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSdAAI', Priority__c = priority/*, Description__c = descriptions.get(0), Priority__c = descriptions.get(1)*/));
                        }
                    }
                } else {
                    cIdTodoMap.put(newCase.Id, 
                	new ToDo__c(Name = newCase.Subject, OwnerId = newCase.OwnerId, RecordTypeId = '0125g000001qnSdAAI', Priority__c = priority));
                }
            }
        }
        insert cIdTodoMap.values();
//        SubToDo__c[] subtodos = new List<SubToDo__c>();
//        for(Case newCase : newCases){
//            if(newCase.Origin == 'Email'){
//                for(String str : newCase.Description.split(',')){
//                    subtodos.add(new SubToDo__c(
//                        Name = str,
//                        ToDo__c = cIdTodoMap.get(newCase.Id).Id
//                    ));
//                }
//            }
//        }
//        insert subtodos;
    }
}