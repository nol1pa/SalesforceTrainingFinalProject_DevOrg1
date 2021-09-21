import {LightningElement, wire, track, api} from 'lwc';
import findTodo from '@salesforce/apex/ToDoHandler.findTodosWithSubTodos';
import {getPicklistValues} from 'lightning/uiObjectInfoApi';
import {getObjectInfo} from 'lightning/uiObjectInfoApi';
import TODO_OBJECT from '@salesforce/schema/ToDo__c';
import Priority_FIELD from '@salesforce/schema/ToDo__c.Priority__c';
import {refreshApex} from "@salesforce/apex";

export default class TodoSearch extends LightningElement {

    @track nameKey = '';
    @track priorityKey = '';
    @track optionsForPriority = [];
    @track startDateKey = '2000-01-01T00:00:00Z';
    @track endDateKey = '';


    //@track key = { priorityFKey : '', nameFKey : '', startDateFKey : '2000-01-01T00:00:00Z', endDateFKey : ''};

    // @api
    // get key(){
    //     return this.key;
    // }
    // set key(value){
    //     this.key.priorityFKey = value.priorityFKey;
    //     this.key.nameFKey = value.nameFKey;
    //     this.key.startDateFKey = value.startDateFKey;
    //     this.key.endDateFKey = value.endDateFKey;
    // }

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
        const lwcEvent3 = new CustomEvent('eventname', {
            detail:{nameKey:this.nameKey}
        });
        window.clearTimeout(this.delayTimeout);
        const nameKey = event.target.value;
        //this.delayTimeout = setTimeout(() => {
            this.nameKey = nameKey;
        //}, 300);
        this.refresh();
        this.dispatchEvent(lwcEvent3);
    }

    connectedCallback(){
        const today = new Date();
        this.endDateKey=today.toISOString();
        console.log(today.toISOString());
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
        this.refresh();
    }


    handleChangeDate(event) {
        const lwcEvent2 = new CustomEvent('eventdate', {
            detail:{startDateKey:this.startDateKey, endDateKey:this.endDateKey}
        });
        this.dispatchEvent(lwcEvent2);
        window.clearTimeout(this.delayTimeout);
        const endDateKey = event.target.value;
        //this.startDateKey = setTimeout(() => {
            this.startDateKey = endDateKey + 'T00:00:00Z';
        //}, 300);
        //this.endDateKey = setTimeout(() => {
            this.endDateKey = endDateKey + 'T23:59:59Z';
        //}, 300);
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
        const lwcEvent1 = new CustomEvent('eventpriority', {
            detail:{priorityKey:this.priorityKey}
        });
        this.dispatchEvent(lwcEvent1);
        window.clearTimeout(this.delayTimeout);
        const priorityKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.priorityKey = priorityKey;
        }, 300);
        this.refresh();
    }
}