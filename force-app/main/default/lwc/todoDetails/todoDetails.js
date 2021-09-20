import { LightningElement, api, wire, track } from 'lwc';
import getSubtodosOfTodo from '@salesforce/apex/SubToDoHandler.getSubToDosOfTodo';

import { subscribe, MessageContext } from 'lightning/messageService';
import TODO_SELECTED_CHANNEL from '@salesforce/messageChannel/Todo_Selected__c';

export default class TodoDetails extends LightningElement {
    /*dobavlennyi kod*/
    selectedTodoId;//получается из message channel
    subscribtion = null;
    @wire(MessageContext)
    messageContext;
    subscribeToMessageChannel(){
        this.subscribtion = subscribe(
            this.messageContext,
            TODO_SELECTED_CHANNEL,
            (message)=>this.handleMessage(message)
        );
    }
    handleMessage(message){
        this.selectedTodoId = message.selectedTodoId;
    }
    connectedCallback(){
        this.subscribeToMessageChannel();
    }
    /*dobavlennyi kod(end)*/


    @api todo;
    recordSubtodosModalOpened = false;
    subtodos = '';
    todoId = '';

    @wire(getSubtodosOfTodo, {todoId : '$todoId'}) 
    getSubTodos(result){
        this.res = result;
        if(result.data){
            this.subtodos = result.data;
        }
    }
    
    /*connectedCallback(event){
        this.todoId = event.data.todo.Id;
    }*/

    closeSubtodosModal(){
        this.recordSubtodosModalOpened = false;
    }
    openSubtodosModal(){
        this.recordSubtodosModalOpened = true;
    }
}