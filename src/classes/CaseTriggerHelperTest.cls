/**
 * Created by vladimirzhukovets on 21.09.21.
 */

@IsTest
private class CaseTriggerHelperTest {
    @IsTest(SeeAllData=true)
    static void addToDoFromEmailTest() {
        List<Case> cases = new List<Case>();
        Case caseObj = TestDataFactory.CASEOBJ.createDummyCase('Test todo, dEVelopment', 'Test subtodo', 'Email', '0055g00000CxaO8AAJ', true);
        ToDo__c expectedTodo = TestDataFactory.TODO.createDummyTodo('Test todo', '0125g000001qnSTAAY','0055g00000CxaO8AAJ', false);
        SubToDo__c expectedSubTodo = TestDataFactory.SUBTODO.createDummySubTodo('Test subtodo', false);
        cases.add(caseObj);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ToDoTriggerHandlerHelper());
        caseObj.Subject = 'Test todo, dEVelopment';
        update caseObj;
        CaseTriggerHelper.addToDoFromEmail(cases);
        Test.stopTest();

        ToDo__c actualTodo = [SELECT Id, Name, RecordTypeId, OwnerId FROM ToDo__c WHERE Name LIKE '%Test todo%' LIMIT 1];
        SubToDo__c actualSubTodo = [SELECT Name, Todo__c FROM SubToDo__c WHERE Name LIKE '%Test subtodo%' LIMIT 1];
        System.assertEquals(expectedTodo.Name, actualTodo.Name);
        System.assertEquals(expectedTodo.RecordTypeId, actualTodo.RecordTypeId);
        System.assertEquals(expectedTodo.OwnerId, actualTodo.OwnerId);
        System.assertEquals(expectedSubTodo.Name, actualSubTodo.Name);
        System.assertEquals(actualTodo.Id, actualSubTodo.ToDo__c);
    }
}