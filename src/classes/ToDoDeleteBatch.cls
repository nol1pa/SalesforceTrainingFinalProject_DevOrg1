/**
 * Created by vladimirzhukovets on 15.09.21.
 */

public with sharing class ToDoDeleteBatch implements Database.Batchable<sObject>, Database.Stateful{

    public Database.QueryLocator start(Database.BatchableContext batchableContext){
        return Database.getQueryLocator('SELECT Id, Name, CreatedDate, Lifetime_Value__c FROM ToDo__c');
    }

    public void execute(Database.BatchableContext batchableContext, List<ToDo__c> todos){
        List<ToDo__c> todosForDelete;
        for(ToDo__c todo : todos){
            List<String> lifetime = todo.Lifetime_Value__c.split(' ');
            Integer quantity = Integer.valueOf(lifetime.get(0));
            String unitOfTime = lifetime.get(1);
            switch on unitOfTime.toLowerCase(){
                when 'year'{
                    DateTime myDateTime = DateTime.newInstance(quantity, 0, 0, 0, 0, 0);
                    if((Datetime.now().getTime() - todo.CreatedDate.getTime()) > myDateTime.getTime()){
                        todosForDelete.add(todo);
                    }
                }
                when 'month'{
                    DateTime myDateTime = DateTime.newInstance(0, quantity, 0, 0, 0, 0);
                    if((Datetime.now().getTime() - todo.CreatedDate.getTime()) > myDateTime.getTime()){
                        todosForDelete.add(todo);
                    }
                }
                when 'day'{
                    DateTime myDateTime = DateTime.newInstance(0, 0, quantity, 0, 0, 0);
                    if((Datetime.now().getTime() - todo.CreatedDate.getTime()) > myDateTime.getTime()){
                        todosForDelete.add(todo);
                    }
                }
                when 'hour'{
                    DateTime myDateTime = DateTime.newInstance(0, 0, 0, quantity, 0, 0);
                    if((Datetime.now().getTime() - todo.CreatedDate.getTime()) > myDateTime.getTime()){
                        todosForDelete.add(todo);
                    }
                }
                when 'minute'{
                    DateTime myDateTime = DateTime.newInstance(0, 0, 0, 0, quantity, 0);
                    if((Datetime.now().getTime() - todo.CreatedDate.getTime()) > myDateTime.getTime()){
                        todosForDelete.add(todo);
                    }
                }
            }
        }
        delete todosForDelete;
    }

    public void finish(Database.BatchableContext batchableContext){
        System.debug('finish batch');
    }

}