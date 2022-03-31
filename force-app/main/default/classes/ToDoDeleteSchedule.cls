/**
 * Created by vladimirzhukovets on 21.09.21.
 */

public class ToDoDeleteSchedule implements Schedulable{

    public void execute(SchedulableContext schedulableContext){
        ToDoDeleteBatch tododeletebatch = new ToDoDeleteBatch();
        Database.executeBatch(tododeletebatch);
    }

}