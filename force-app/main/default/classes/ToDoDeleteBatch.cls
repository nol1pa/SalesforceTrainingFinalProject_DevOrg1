/**
 * Created by vladimirzhukovets on 15.09.21.
 */

public with sharing class ToDoDeleteBatch implements Database.Batchable<sObject>, Database.Stateful{

    public Database.QueryLocator start(Database.BatchableContext batchableContext){
        List<Lifetime__mdt> lifetimes = Lifetime__mdt.getAll().values();
        Integer quantity = Integer.valueOf(lifetimes.get(0).Quantity__c);
        String unitOfTime = lifetimes.get(0).Unit_of_time__c;
        Datetime nowTime = Datetime.now();
        Long lifetime = 0L;
        switch on unitOfTime.toLowerCase(){
            when 'year'{
                lifetime = quantity * 12L * 30L * 24L * 60L * 60L * 1000L;
            }
            when 'month'{
                lifetime = quantity * 30L * 24L * 60L * 60L * 1000L;
            }
            when 'day'{
                lifetime = quantity * 24L * 60L * 60L * 1000L;
            }
            when 'hour'{
                lifetime = quantity * 60L * 60L * 1000L;
            }
            when 'minute'{
                lifetime = quantity * 60L * 1000L;
            }
        }
        Long diffTimeInMilliseconds = nowTime.getTime() - lifetime;
        Datetime diffTime = Datetime.newInstance(diffTimeInMilliseconds);
        return Database.getQueryLocator('SELECT Id, CreatedDate FROM ToDo__c WHERE CreatedDate < :diffTime');
    }

    public void execute(Database.BatchableContext batchableContext, List<ToDo__c> todos){
        delete todos;
    }

    public void finish(Database.BatchableContext batchableContext){
        System.debug('finish batch');
    }

}