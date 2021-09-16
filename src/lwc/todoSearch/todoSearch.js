import {LightningElement, wire, track} from 'lwc';
import findTodo from '@salesforce/apex/ToDoHandler.findTodosWithSubTodos';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import TODO_OBJECT from '@salesforce/schema/ToDo__c';
import Priority_FIELD from '@salesforce/schema/ToDo__c.Priority__c';
import isDone_FIELD from '@salesforce/schema/ToDo__c.Is_Done__c';

export default class TodoSearch extends LightningElement {
    nameKey = '';
    @track isDone = '';
    @track isDoneOptions = [];
    @track priorityKey = '';
    @track optionsForPriority = [];



    @wire(findTodo, {priorityKey: '$priorityKey', isDone: '$isDone', nameKey: '$nameKey'})
    todos;

    handleChange(event) {
        window.clearTimeout(this.delayTimeout);
        const nameKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.nameKey = nameKey;
        }, 300);
    }



    // object info using wire service
    @wire(getObjectInfo, { objectApiName: TODO_OBJECT })
    objectInfo;

    // Getting Account Type Picklist values using wire service
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Priority_FIELD})
    typePicklistValues({error, data}) {
        if(data) {
            let optionsValues = [];
            for(let i = 0; i < data.values.length; i++) {
                optionsValues.push({
                    label: data.values[i].label,
                    value: data.values[i].value
                })
            }
            this.optionsForPriority = optionsValues;
            window.console.log('optionsValues ===> '+JSON.stringify(optionsValues));
        }
        else if(error) {
            window.console.log('error ===> '+JSON.stringify(error));
        }
    }

    // handle the selected value
    handleChangePriority(event) {
        window.clearTimeout(this.delayTimeout);
        const priorityKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.priorityKey = priorityKey;
        }, 300);
        //this.priorityKey = event.detail.value;
    }

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: isDone_FIELD})
    typePicklistValues({error, data}) {
        if(data) {
            let optionsValues = [];
            for(let i = 0; i < data.values.length; i++) {
                optionsValues.push({
                    label: data.values[i].label,
                    value: data.values[i].value
                })
            }
            this.isDoneOptions = optionsValues;
            window.console.log('optionsValues ===> '+JSON.stringify(optionsValues));
        }
        else if(error) {
            window.console.log('error ===> '+JSON.stringify(error));
        }
    }

    handleChangeisDone(event) {
        window.clearTimeout(this.delayTimeout);
        const isDone = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.isDone = isDone;
        }, 300);
        //this.priorityKey = event.detail.value;
    }

    /*handleChangePriority(event) {
        window.clearTimeout(this.delayTimeout);
        const priorityKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.priorityKey = priorityKey;
        }, 300);
    }

    get optionsForPriority() {
        return [
            {label: 'High', priorityKey: 'High'},
            {label: 'Medium', priorityKey: 'Medium'},
            {label: 'Low', priorityKey: 'Low'},
            {label: 'All', priorityKey: ''},
        ];
    }

    get optionsForDone() {
        return [
            {label: 'Done', isDone: 'TRUE'},
            {label: 'Not done', isDone: 'FALSE'},
            {label: 'All', isDone: ''},
        ];
    }*/
}