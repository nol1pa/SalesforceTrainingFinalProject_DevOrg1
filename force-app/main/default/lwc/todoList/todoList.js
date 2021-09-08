import { LightningElement, track, wire } from 'lwc';
import getAllTodosWithSubTodos from '@salesforce/apex/ToDoHandler.getAllTodosWithSubTodos';
import {refreshApex} from '@salesforce/apex'

export default class TodoList extends LightningElement {
    todos;
    res;
    isdisabled = false;
    @wire(getAllTodosWithSubTodos)
    getTodos(result){
        this.res = result;
        if(result.data){
            this.todos = result.data;
        }
    }
    renderedCallback(){
        this.refresh();
    }
    refresh(){
        refreshApex(this.res);
    }
    enableBtns(){
        this.isdisabled = false;
    }
    disableBtns(){
        this.isdisabled = true;
    }
}