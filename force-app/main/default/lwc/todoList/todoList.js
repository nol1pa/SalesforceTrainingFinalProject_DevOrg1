import { LightningElement, track, wire } from 'lwc';
import getAllTodosWithSubTodos from '@salesforce/apex/ToDoHandler.getAllTodosWithSubTodos';
import {refreshApex} from '@salesforce/apex'

export default class TodoList extends LightningElement {
    todos;
    res;
    @wire(getAllTodosWithSubTodos)
    getTodos(result){
        this.res = result;
        if(result.data){
            this.todos = result.data;
        }
    }
    refresh(){
        refreshApex(this.res);
    }
}