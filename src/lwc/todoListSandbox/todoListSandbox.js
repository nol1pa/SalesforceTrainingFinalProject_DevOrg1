import {LightningElement, track, wire, api} from 'lwc';
import findTodo from '@salesforce/apex/ToDoHandler.findTodosWithSubTodos';
import {refreshApex} from '@salesforce/apex'

export default class TodoListSandbox extends LightningElement {

    @track nameKey;
    @track priorityKey;
    @track startDateKey;
    @track endDateKey;

    showsubtodos = false;
    todos;
    res;
    progress = 0;
    isdisabled = false;
    creationModalOpened = false;
    recordTypeModalOpened = false;
    recordTypeId = '0125g000001qnSTAAY';
    get recordTypeOptions(){
        return [
            {label:'Development', value:'0125g000001qnSTAAY'},
            {label:'Administration', value:'0125g000001qnSYAAY'},
            {label:'Management', value:'0125g000001qnSdAAI'}
        ];
    }
    connectedCallback() {
        this.nameKey = '';
        this.priorityKey = '';
        this.startDateKey = '2000-01-01T00:00:00Z';
        const today = new Date();
        this.endDateKey=today.toISOString();
        console.log(today.toISOString());
    }

    handlename(event){
        const nameKey = event.detail.nameKey;
        this.delayTimeout = setTimeout(() => {
        this.nameKey = nameKey;
        }, 300);
        //this.nameKey = event.detail.nameKey;
    }
    handlepriority(event){
        this.priorityKey = event.detail.priorityKey;
    }
    handledate(event){
        this.startDateKey = event.detail.startDateKey;
        this.endDateKey = event.detail.endDateKey;
        console.log('starrtDatettete ' + this.startDateKey + ' enddate ' + this.endDateKey);
    }
    @wire(findTodo, {
            priorityKey: '$priorityKey',
            nameKey: '$nameKey',
            startDateKey: '$startDateKey',
            endDateKey: '$endDateKey'
    })
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
    closeRecordTypeModal(){
        this.recordTypeModalOpened = false;
    }
    openRecordTypeModal(){
        this.recordTypeModalOpened = true;
    }
    openCreationModal(){
        this.recordTypeModalOpened = false;
        this.creationModalOpened = true;
    }
    closeCreationModal(){
        this.creationModalOpened = false;
        this.refresh();
    }
    changeRecordTypeId(event){
        this.recordTypeId = event.target.value;
    }
    handleShowSubtodos(){
        this.showsubtodos = !this.showsubtodos;
    }



}