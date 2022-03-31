/**
 * Created by vladimirzhukovets on 21.09.21.
 */

@IsTest
private class CaseTriggerHelperTest {
    @IsTest
    static void addToDoFromEmailTest() {
        List<Case> cases = new List<Case>();
        Case caseObj = TestDataFactory.CASEOBJ.createDummyCase('Test todo, dEVelopment', 'Low', 'Email', '0055g00000CxaO8AAJ', true);
        ToDo__c expectedTodo = TestDataFactory.TODO.createDummyTodo('Test todo', '0125g000001qnSTAAY', 'Low', false);
        cases.add(caseObj);

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('TodosResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        CaseTriggerHelper.addToDoFromEmail(cases);
        Test.stopTest();

        ToDo__c actualTodo = [SELECT Id, Name, RecordTypeId, OwnerId, Priority__c FROM ToDo__c WHERE Name LIKE '%Test todo%' LIMIT 1];
        System.assertEquals(expectedTodo.Name, actualTodo.Name);
        System.assertEquals(expectedTodo.RecordTypeId, actualTodo.RecordTypeId);
        System.assertEquals(expectedTodo.Priority__c, actualTodo.Priority__c);
    }

    @IsTest
    static void addToDoFromEmailManagementTest(){
        List<Case> cases = new List<Case>();
        Case caseObj = TestDataFactory.CASEOBJ.createDummyCase('Test todo, managemeNt', 'Low', 'Email', '0055g00000CxaO8AAJ', true);
        ToDo__c expectedTodo = TestDataFactory.TODO.createDummyTodo('Test todo', '0125g000001qnSdAAI', 'Low', false);
        cases.add(caseObj);

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('TodosResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        CaseTriggerHelper.addToDoFromEmail(cases);
        Test.stopTest();

        ToDo__c actualTodo = [SELECT Id, Name, RecordTypeId, OwnerId, Priority__c FROM ToDo__c WHERE Name LIKE '%Test todo%' LIMIT 1];
        System.assertEquals(expectedTodo.Name, actualTodo.Name);
        System.assertEquals(expectedTodo.RecordTypeId, actualTodo.RecordTypeId);
        System.assertEquals(expectedTodo.Priority__c, actualTodo.Priority__c);
    }

    @IsTest
    static void addToDoFromEmailAdministrationTest(){
        List<Case> cases = new List<Case>();
        Case caseObj = TestDataFactory.CASEOBJ.createDummyCase('Test todo, adminisTRation', 'Low', 'Email', '0055g00000CxaO8AAJ', true);
        ToDo__c expectedTodo = TestDataFactory.TODO.createDummyTodo('Test todo', '0125g000001qnSYAAY', 'Low', false);
        cases.add(caseObj);

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('TodosResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        CaseTriggerHelper.addToDoFromEmail(cases);
        Test.stopTest();

        ToDo__c actualTodo = [SELECT Id, Name, RecordTypeId, OwnerId, Priority__c FROM ToDo__c WHERE Name LIKE '%Test todo%' LIMIT 1];
        System.assertEquals(expectedTodo.Name, actualTodo.Name);
        System.assertEquals(expectedTodo.RecordTypeId, actualTodo.RecordTypeId);
        System.assertEquals(expectedTodo.Priority__c, actualTodo.Priority__c);
    }
}