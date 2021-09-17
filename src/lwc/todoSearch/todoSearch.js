import {LightningElement, wire, track} from 'lwc';
import findTodo from '@salesforce/apex/ToDoHandler.findTodosWithSubTodos';
import {getPicklistValues} from 'lightning/uiObjectInfoApi';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import TODO_OBJECT from '@salesforce/schema/ToDo__c';
import Priority_FIELD from '@salesforce/schema/ToDo__c.Priority__c';
import isDone_FIELD from '@salesforce/schema/ToDo__c.Is_Done__c';

export default class TodoSearch extends LightningElement {
    nameKey = '';
    today = new Date();
    @track isDone = '';
    @track isDoneOptions = [];
    @track priorityKey = '';
    @track optionsForPriority = [];
    @track dateValue = '2020-09-07T00:00:00Z'
    @track startDateKey = '2000-01-01T00:00:00Z';
    @track endDateKey = '2021-09-17T23:59:59Z';

    @wire(findTodo, {priorityKey: '$priorityKey', nameKey: '$nameKey', startDateKey: '$startDateKey', endDateKey: '$endDateKey'})
    todos;

    handleChange(event) {
        window.clearTimeout(this.delayTimeout);
        const nameKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.nameKey = nameKey;
        }, 300);
    }

    connectedCallback(){
        const today = new Date();
        this.endDateKey=today.toISOString();
        console.log(today.toISOString())
    }


    show = false;

    handleChangeShow(event) {
        this.show = event.target.checked;
    }

    handleClick(){
        const today = new Date();
        this.endDateKey=today.toISOString();
        console.log(today.toISOString())
        this.startDateKey = '2000-01-01T00:00:00Z';
    }


    handleChangeDate(event) {
        window.clearTimeout(this.delayTimeout);
        const endDateKey = event.target.value;
        this.startDateKey = setTimeout(() => {
            this.startDateKey = endDateKey + 'T00:00:00Z';
        }, 300);
        this.endDateKey = setTimeout(() => {
            this.endDateKey = endDateKey + 'T23:59:59Z';
        }, 300);
    }


    @wire(getObjectInfo, {objectApiName: TODO_OBJECT})
    objectInfo;

    @wire(getPicklistValues, {recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Priority_FIELD})
    typePicklistValuesDone({error, data}) {
        if (data) {
            let optionsValues = [];
            for (let i = 0; i < data.values.length; i++) {
                optionsValues.push({
                    label: data.values[i].label,
                    value: data.values[i].value
                })
            }
            optionsValues.push({
                label: 'All',
                value: ''
            })
            this.optionsForPriority = optionsValues;
            window.console.log('optionsValues ===> ' + JSON.stringify(optionsValues));
        } else if (error) {
            window.console.log('error ===> ' + JSON.stringify(error));
        }
    }

    handleChangePriority(event) {
        window.clearTimeout(this.delayTimeout);
        const priorityKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.priorityKey = priorityKey;
        }, 300);
        //this.priorityKey = event.detail.value;
    }


    //rework this for isDone checkbox

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