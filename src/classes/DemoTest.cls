@IsTest
public class DemoTest {
	@IsTest
    public static void testMet(){
        ToDo__c tod = new ToDo__c(name='f');
        insert tod;
        SubToDo__c sub = new SubToDo__c(name='uh elki', ToDo__C  = tod.id);
        
        Test.startTest();
        insert sub;
        Test.stopTest();
        
        
    }
}