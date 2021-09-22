/**
 * Created by vladimirzhukovets on 22.09.21.
 */

@IsTest
private class ToDoDeleteScheduleTest {
    @IsTest
    static void ToDoDeleteScheduleTest() {
        Test.startTest();
        ToDoDeleteSchedule sched = new ToDoDeleteSchedule();
        Id jobId = System.schedule('Test', '0 0 * * * ?', sched);
        test.stopTest();

        System.assertNotEquals(null, jobId);
    }
}