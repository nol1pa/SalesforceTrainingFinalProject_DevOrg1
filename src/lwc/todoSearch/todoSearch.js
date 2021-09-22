import {LightningElement, wire, track, api} from 'lwc';
import findTodo from '@salesforce/apex/ToDoHandler.findTodosWithSubTodos';
import {getPicklistValues} from 'lightning/uiObjectInfoApi';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import TODO_OBJECT from '@salesforce/schema/ToDo__c';
import Priority_FIELD from '@salesforce/schema/ToDo__c.Priority__c';
import {refreshApex} from "@salesforce/apex";

export default class TodoSearch extends LightningElement {

    nameKey = '';
    priorityKey = '';
    optionsForPriority = [
        {value: '', label: 'All'},
        {value: 'High', label: 'High'},
        {value: 'Medium', label: 'Medium'},
        {value: 'Low', label: 'Low'},
    ];
    startDateKey = '';
    endDateKey = '';

    handlePriorityChange(event){
        const priority = event.target.value
        this.priorityKey = priority;
        this.sendKeyChangeEvent();
    }

    handleNameKeyChange(event){
        this.nameKey = event.target.value;
        this.sendKeyChangeEvent();
    }

    handleDateKeyChange(event){
        const endDateKey = event.target.value;
        this.startDateKey = endDateKey + 'T00:00:00Z';
        this.endDateKey = endDateKey + 'T23:59:59Z';
        this.sendKeyChangeEvent();
    }

    sendKeyChangeEvent(){
        this.dispatchEvent(new CustomEvent('keychange', {
            detail: {
                nameKey: this.nameKey,
                priorityKey : this.priorityKey,
                startDateKey: this.startDateKey,
                endDateKey: this.endDateKey
            }
        }));
    }

    handleClick(){
        const today = new Date();
        this.nameKey = '';
        this.priorityKey = '';
        this.startDateKey = '2000-01-01T00:00:00Z';
        this.endDateKey = today.toISOString();
        this.dispatchEvent(new CustomEvent('resetdate', {
            detail: {
                nameKey: '',
                priorityKey: '',
                startDateKey: '2000-01-01T00:00:00Z',
                endDateKey: today.toISOString()
            }
        }));
    }

    connectedCallback(){
        const today = new Date();
        this.startDateKey = '2000-01-01T00:00:00Z'
        this.endDateKey=today.toISOString();
        this.priorityKey = '';
        console.log(today.toISOString());
    }

}