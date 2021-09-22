/**
 * Created by vladimirzhukovets on 21.09.21.
 */
@IsTest
public class TestDataFactory {
    public static TestCaseFactory CASEOBJ = new TestCaseFactory();
    public static TestTodoFactory TODO = new TestTodoFactory();
    public static TestSubTodoFactory SUBTODO = new TestSubTodoFactory();

    public class TestCaseFactory{
        public Case createDummyCase(String subject, String description, String origin, Id ownerId, Boolean needInsert){
            Case caseObj = new Case();
            caseObj.Subject = subject;
            caseObj.Description = description;
            caseObj.Origin = origin;
            caseObj.OwnerId = ownerId;
            if(needInsert) insert caseObj;
            return caseObj;
        }
    }

    public class TestTodoFactory{
        public ToDo__c createDummyTodo(String name, Id recordTypeId, Boolean needInsert){
            ToDo__c todo = new ToDo__c();
            todo.Name = name;
            todo.RecordTypeId = recordTypeId;
            if(needInsert) insert todo;
            return todo;
        }
    }

    public class TestSubTodoFactory{
        public SubToDo__c createDummySubTodo(String name, Boolean needInsert){
            SubToDo__c subTodo = new SubToDo__c();
            subTodo.Name = name;
            if(needInsert) insert subTodo;
            return subTodo;
        }
    }
}