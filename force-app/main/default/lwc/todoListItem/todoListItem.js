import { api, LightningElement, track, wire } from 'lwc';
import updateTodoWithSubTodos from '@salesforce/apex/ToDoHandler.updateTodoWithSubTodos';
import updateTodo from '@salesforce/apex/ToDoHandler.updateTodo';
import { deleteRecord } from 'lightning/uiRecordApi';

import { publish, MessageContext } from 'lightning/messageService';//-
import TODO_SELECTED_CHANNEL from '@salesforce/messageChannel/Todo_Selected__c';//-

export default class TodoListItem extends LightningElement {
    @wire(MessageContext)//-
    messageContext;//-

    todoEditingModalOpened = false;
    subtodoEditingModalOpened = false;
    subtodoCreationModalOpened = false;
    @api
    showsubtodos;
    curSubtodoId = '';
    @api
    isdisabled;
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
        this._todo.RecordTypeId = value.RecordTypeId;
        this._todo.SubToDos__r = 
        value.SubToDos__r ? JSON.parse(JSON.stringify(value.SubToDos__r)) : undefined;
        this.recheckStatus();
    }

    renderedCallback(){
        this.setStyles();
    }

    handleTodoDoneChange(){
        this.dispatchEvent(new CustomEvent('disablebtns'));
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
            this.setStyles();
            this.dispatchEvent(new CustomEvent('enablebtns'));
        })    
    }

    handleSubTodoDoneChange(event){
        this.dispatchEvent(new CustomEvent('disablebtns'));
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
            this.setStyles();
            this.dispatchEvent(new CustomEvent('enablebtns'));
        })
    }

    setStyles(){
        this.template.querySelector('lightning-icon').iconName = 
        this._todo.RecordTypeId === '0125g000001qnSTAAY' ? 'utility:custom_apps' : 
        this._todo.RecordTypeId === '0125g000001qnSYAAY' ? 'utility:company' : 
        this._todo.RecordTypeId === '0125g000001qnSdAAI' ? 'utility:currency' : 'utility:question';
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
    deleteTodo(){
        this.dispatchEvent(new CustomEvent("disablebtns"));
        deleteRecord(this._todo.Id).then(()=>{
            this.dispatchEvent(new CustomEvent("enablebtns"));
        });
    }
    deleteSubtodo(event){
        this.dispatchEvent(new CustomEvent("disablebtns"));
        deleteRecord(event.target.dataset.item).then(()=>{
            this.dispatchEvent(new CustomEvent("enablebtns"));
        });
        
    }
    editTodo(){
        this.todoEditingModalOpened = true;
    }
    closeTodoEditingModal(){
        this.dispatchEvent(new CustomEvent('refreshreq'));
        this.todoEditingModalOpened = false;
    }
    editSubtodo(event){
        this.curSubtodoId = event.target.dataset.item;
        this.subtodoEditingModalOpened = true;
    }
    closeSubtodoEditingModal(){
        this.dispatchEvent(new CustomEvent('refreshreq'));
        this.subtodoEditingModalOpened = false;
    }
    createSubtodo(){
        this.subtodoCreationModalOpened = true;
    }
    closeSubtodoCreationModal(){
        this.dispatchEvent(new CustomEvent('refreshreq'));
        this.subtodoCreationModalOpened = false;
    }
    recheckStatus(){
        if(this._todo.SubToDos__r){
            const allDone = this._todo.SubToDos__r.reduce((acc, curr)=>{
                return acc && curr.Is_Done__c;
            },true);
            if(this._todo.Is_Done__c != allDone){
                this._todo.Is_Done__c = allDone;
                updateTodo({todo : this._todo});
            }
        }
        
    }
    selectTodo(){
        const payload = { selectedTodoId : this._todo.Id};
        publish(this.messageContext, TODO_SELECTED_CHANNEL, payload);
    }
}