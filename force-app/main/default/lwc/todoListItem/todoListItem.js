import { api, LightningElement, track } from 'lwc';
import updateTodoWithSubTodos from '@salesforce/apex/ToDoHandler.updateTodoWithSubTodos';
import updateTodo from '@salesforce/apex/ToDoHandler.updateTodo';
export default class TodoListItem extends LightningElement {
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

    renderedCallback(){
        this.setBackground();
    }

    handleTodoDoneChange(){
        this._todo.Is_Done__c = !this._todo.Is_Done__c;
        if(this._todo.SubToDos__r){
            this._todo.SubToDos__r.forEach(element => {
                element.Is_Done__c = this._todo.Is_Done__c;
            });
        }
        const prom = new Promise((resolve)=>{
            if(this._todo.SubToDos__r){
                resolve(updateTodoWithSubTodos({todo : this._todo, subtodos : this._todo.SubToDos__r}));
            } else {
                resolve(updateTodo({todo : this._todo}));
            }
        })
        prom.then(()=>{
            this.dispatchEvent(new CustomEvent('refreshreq'));
            this.setBackground();
        })    
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

        const prom = new Promise((resolve)=>{
            resolve(updateTodoWithSubTodos({todo : this._todo, subtodos : this._todo.SubToDos__r}));
        })
        prom.then(()=>{
            this.dispatchEvent(new CustomEvent('refreshreq'));
            this.setBackground();
        })
    }

    setBackground(){
        if(this._todo.SubToDos__r){
            const somethingDone = this._todo.SubToDos__r.reduce((acc, cur)=>{
                return acc || cur.Is_Done__c;
            },false);
            this.template.querySelector('div').style.backgroundColor = 
            this._todo.Is_Done__c ? "lightgreen" : 
            somethingDone ? "khaki" : "lightpink";
        } else {
            this.template.querySelector('div').style.backgroundColor =
            this._todo.Is_Done__c ? "lightgreen" : "lightpink";
        }
    }
}