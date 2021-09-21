import {LightningElement, wire, track, api} from 'lwc';
import findTodo from '@salesforce/apex/ToDoHandler.findTodosWithSubTodos';
import {getPicklistValues} from 'lightning/uiObjectInfoApi';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import TODO_OBJECT from '@salesforce/schema/ToDo__c';
import Priority_FIELD from '@salesforce/schema/ToDo__c.Priority__c';
import {refreshApex} from "@salesforce/apex";

export default class TodoSearch extends LightningElement {

    // nameKey = '';
    // @track priorityKey = '';
    // @track optionsForPriority = [];
    // @track startDateKey = '2000-01-01T00:00:00Z';
    // @track endDateKey = '';

    @track key = { priorityFKey : '', nameFKey : '', startDateFKey : '2000-01-01T00:00:00Z', endDateFKey : ''};

    @api
    get key(){
        return this.key;
    }
    set key(value){
        this.key.priorityFKey = value.priorityFKey;
        this.key.nameFKey = value.nameFKey;
        this.key.startDateFKey = value.startDateFKey;
        this.key.endDateFKey = value.endDateFKey;
    }

    // @wire(findTodo, {
    //     priorityKey: '$priorityKey',
    //     nameKey: '$nameKey',
    //     startDateKey: '$startDateKey',
    //     endDateKey: '$endDateKey',
    // })
    // todos;

    refresh(){
        refreshApex(this.refresh);
    }

    handleChange(event) {
        const nameKey = event.target.value;
        const eventDetail = new CustomEvent('getname',{
                detail:{
                    // nameKey : this.key.nameFKey;
                }
            });
        // window.clearTimeout(this.delayTimeout);
        // const nameKey = event.target.value;
        // this.delayTimeout = setTimeout(() => {
        //     this.key.nameFKey = nameKey;
        // }, 300);
        // this.refresh();
    }

    connectedCallback(){
        const today = new Date();
        this.key.endDateFKey=today.toISOString();
        console.log(today.toISOString());
    }


    show = false;

    handleChangeShow(event) {
        this.show = event.target.checked;
    }

    handleClick(){
        const today = new Date();
        this.key.endDateFKey=today.toISOString();
        console.log(today.toISOString())
        this.key.startDateFKey = '2000-01-01T00:00:00Z';
        this.refresh();
    }


    handleChangeDate(event) {
        this.dispatchEvent(new CustomEvent('getdate'));
        window.clearTimeout(this.delayTimeout);
        const endDateKey = event.target.value;
        this.key.startDateFKey = setTimeout(() => {
            this.key.startDateFKey = endDateKey + 'T00:00:00Z';
        }, 300);
        this.key.endDateFKey = setTimeout(() => {
            this.key.endDateFKey = endDateKey + 'T23:59:59Z';
        }, 300);
        this.refresh();
    }


    @wire(getObjectInfo, {objectApiName: TODO_OBJECT})
    objectInfo;

    @wire(getPicklistValues, {fieldApiName: Priority_FIELD, recordTypeId: '$objectInfo.data.defaultRecordTypeId'})
    typePicklistValuesPriority({error, data}) {
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
        this.dispatchEvent(new CustomEvent('getpriority'));
        window.clearTimeout(this.delayTimeout);
        const priorityKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.key.priorityFKey = priorityKey;
        }, 300);
        this.refresh();
    }
}