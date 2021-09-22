// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

ToDo__c[] todos = new List<ToDo__c>();
for(Integer i = 0; i < 15; i++){
    todos.add(new ToDo__c(Name = 'ToDo' + i, 
    Priority = 
    (Math.mod(i, 3) == 0 ? 'High' : (Math.mod(i , 3) == 1 ? 'Medium' : 'Low')),
    RecordTypeId = 
    (Math.mod(i, 3) == 0 ? '0125g000001qnSTAAY' : (Math.mod(i , 3) == 1 ? '0125g000001qnSYAAY' : '0125g000001qnSdAAI'))));
}
insert todos;
SubToDo__c[] subs = new List<SubToDo__c>();
for(ToDo__c todo : todos){
    subs.add(new SubToDo__c(ToDo__c = todo.Id, Name = 'Subtodo for ' + todo.Name + 1, Priority = 'Low'));
    subs.add(new SubToDo__c(ToDo__c = todo.Id, Name = 'Subtodo for ' + todo.Name + 2, Priority = 'Low'));
}
insert subtodos;