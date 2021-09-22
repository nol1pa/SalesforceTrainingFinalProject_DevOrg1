/**
 * Created by vladimirzhukovets on 15.09.21.
 */

public with sharing class ToDoDeleteBatch implements Database.Batchable<sObject>, Database.Stateful{

    public Database.QueryLocator start(Database.BatchableContext batchableContext){
        List<Lifetime__mdt> lifetimes = Lifetime__mdt.getAll().values();
        Integer quantity = Integer.valueOf(lifetimes.get(0).Quantity__c);
        String unitOfTime = lifetimes.get(0).Unit_of_time__c;
        Datetime nowTime = Datetime.now();
        Datetime lifetime;
        switch on unitOfTime.toLowerCase(){
            when 'year'{
                lifetime = nowTime.addYears(-quantity);
                //lifetime = quantity * 12L * 30L * 24L * 60L * 60L * 1000L;
            }
            when 'month'{
                lifetime = nowTime.addMonths(quantity);
                //lifetime = quantity * 30L * 24L * 60L * 60L * 1000L;
            }
            when 'day'{
                lifetime = nowTime.addDays(-quantity);
                //lifetime = quantity * 24L * 60L * 60L * 1000L;
            }
            when 'hour'{
                lifetime = nowTime.addHours(-quantity);
//                lifetime = quantity * 60L * 60L * 1000L;
            }
            when 'minute'{
                lifetime = nowTime.addMinutes(-quantity);
                //lifetime = quantity * 60L * 1000L;
            }
        }
        //Long diffTimeInMilliseconds = nowTime.getTime() - lifetime;
        //Datetime diffTime = Datetime.newInstance(diffTimeInMilliseconds);
        return Database.getQueryLocator('SELECT Id, CreatedDate FROM ToDo__c WHERE CreatedDate < :lifetime');
    }

    public void execute(Database.BatchableContext batchableContext, List<ToDo__c> todos){
        delete todos;
    }

    public void finish(Database.BatchableContext batchableContext){
        System.debug('finish batch');
    }

}