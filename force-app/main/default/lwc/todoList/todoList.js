import { LightningElement, track, wire } from 'lwc';
import getAllTodosWithSubTodos from '@salesforce/apex/ToDoHandler.getAllTodosWithSubTodos';
import {refreshApex} from '@salesforce/apex'

export default class TodoList extends LightningElement {
    todos;
    res;
    progress = 0;
    isdisabled = false;
    @wire(getAllTodosWithSubTodos)
    getTodos(result){
        this.res = result;
        if(result.data){
            this.todos = result.data;
            this.countProgress();
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
    countProgress(){
        let todosCount = 0;
        let todosDone = 0;
        this.todos.forEach(element => {
            if(element.SubToDos__r){
                element.SubToDos__r.forEach(element=>{
                    todosCount++;
                    todosDone += element.Is_Done__c ? 1 : 0;
                });
            } else {
                todosCount++;
                todosDone += element.Is_Done__c ? 1 : 0; 
            }
        });
        this.progress = (todosDone/todosCount) * 100;
    }
}