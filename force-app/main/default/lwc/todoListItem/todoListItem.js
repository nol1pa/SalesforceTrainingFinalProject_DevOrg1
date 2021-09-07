import { api, LightningElement, track } from 'lwc';
import updateTodos from '@salesforce/apex/ToDoHandler.updateTodo'
export default class TodoListItem extends LightningElement {
    // @api
    // todo;
    @track
    _todo = {};
    @api
    get todo(){
        return this._todo;
    }
    set todo(value){
        this._todo.Id = value.Id;
        this._todo.Name = value.Name;
        this._todo.Is_Done__c = value.Is_Done__c;
        this._todo.SubToDos__r = 
        value.SubToDos__r ? JSON.parse(JSON.stringify(value.SubToDos__r)) : undefined;
    }
    handleTodoDoneChange(){
        this._todo.Is_Done__c = !this._todo.Is_Done__c;
        this._todo.SubToDos__r.forEach(element => {
            element.Is_Done__c = this._todo.Is_Done__c;
        });
    }
    handleSubTodoDoneChange(event){
        this._todo.SubToDos__r
        .find((item)=>{
            return item.Id === event.target.dataset.item;    
        }).Is_Done__c = 
        !this._todo.SubToDos__r
        .find((item)=>{
            return item.Id === event.target.dataset.item;    
        }).Is_Done__c;
        const allDone = this._todo.SubToDos__r.reduce((acc, cur)=>{
            return acc && cur.Is_Done__c;
        },true);
        if(this._todo.Is_Done__c){
            this._todo.Is_Done__c = false;

        }
        if(allDone){
            this._todo.Is_Done__c = true;
        }
    }
}