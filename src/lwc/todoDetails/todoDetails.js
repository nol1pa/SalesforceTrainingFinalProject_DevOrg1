import { LightningElement, api, wire, track } from 'lwc';
import getSubtodosOfTodo from '@salesforce/apex/SubToDoHandler.getSubToDosOfTodo';

export default class TodoDetails extends LightningElement {
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