import {LightningElement, track, wire, api} from 'lwc';
import findTodosWithSubTodos from '@salesforce/apex/ToDoHandler.findTodosWithSubTodos';
import {refreshApex} from '@salesforce/apex'

export default class TodoListSandbox extends LightningElement {


    priorityKey='';
    nameKey='';
    startDateKey = '';
    endDateKey = '';
    @wire(findTodosWithSubTodos,{
        priorityKey:'$priorityKey',
        nameKey:'$nameKey',
        startDateKey:'$startDateKey',
        endDateKey:'$endDateKey'
    })
    getTodos(result){
        this.res = result;
        if(result.data){
            this.todos = result.data;
            this.countProgress();
        }
    }
    handleKeyChange(event){
        console.log(event.detail.nameKey);
        console.log(event.detail.priorityKey);
        console.log(event.detail.startDateKey + ' start');
        console.log(event.detail.endDateKey + ' end');
        this.nameKey = event.detail.nameKey;
        this.priorityKey = event.detail.priorityKey;
        this.startDateKey = event.detail.startDateKey;
        this.endDateKey = event.detail.endDateKey;
        console.log(event.detail.endDateKey + 'end');
        console.log(event.detail.startDateKey + 'start');
    }

    handleResetDate(event){
        console.log(event.detail.startDateKey + ' start click');
        console.log(event.detail.endDateKey + ' end click');
        this.nameKey = event.detail.nameKey;
        this.priorityKey = event.detail.priorityKey;
        this.startDateKey = event.detail.startDateKey;
        this.endDateKey = event.detail.endDateKey;
    }


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
        this.startDateKey = '2000-01-01T00:00:00Z';
        const today = new Date();
        this.endDateKey=today.toISOString();
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



    //
//     nameKey = '';
//     priorityKey = '';
//     startDateKey = '';
//     endDateKey = '';
//
//     showsubtodos = false;
//     todos;
//     res;
//     progress = 0;
//     isdisabled = false;
//     creationModalOpened = false;
//     recordTypeModalOpened = false;
//     recordTypeId = '0125g000001qnSTAAY';
//     get recordTypeOptions(){
//         return [
//             {label:'Development', value:'0125g000001qnSTAAY'},
//             {label:'Administration', value:'0125g000001qnSYAAY'},
//             {label:'Management', value:'0125g000001qnSdAAI'}
//         ];
//     }
//     connectedCallback() {
//         this.nameKey = '';
//         this.priorityKey = '';
//         this.startDateKey = '2000-01-01T00:00:00Z';
//         const today = new Date();
//         this.endDateKey=today.toISOString();
//         console.log(today.toISOString());
//     }
//
//     handleKeyChange(event){
//         console.log(event.detail.nameKey);
//         console.log(event.detail.priorityKey);
//         console.log(event.detail.startDateKey);
//         console.log(event.detail.endDateKey);
//         this.nameKey = event.detail.nameKey;
//         this.priorityKey = event.detail.priorityKey;
//         this.startDateKey = event.detail.startDateKey;
//         this.endDateKey = event.detail.endDateKey;
//     }
//
//     handlename(event){
//         this.nameKey = event.detail.nameKey;
//         console.log('name: ' + this.nameKey);
//     }
//     // clickforclear(event){
//     //     this.startDateKey = '2000-01-01T00:00:00Z';
//     //     this.endDateKey = event.detail.endDateKey;
//     // }
//     handlepriority(event){
//         this.priorityKey = event.detail.priorityKey;
//     }
//     handledate(event){
//         this.startDateKey = event.detail.startDateKey;
//         this.endDateKey = event.detail.endDateKey;
//         console.log('starrtDatettete ' + this.startDateKey + ' enddate ' + this.endDateKey);
//     }
//     @wire(findTodo, {
//             priorityKey: '$priorityKey',
//             nameKey: '$nameKey',
//             startDateKey: '$startDateKey',
//             endDateKey: '$endDateKey'
//     })
//     getTodos(result){
//         this.res = result;
//         if(result.data){
//             this.todos = result.data;
//             this.countProgress();
//         }
//     }
//
//     renderedCallback(){
//         this.refresh();
//     }
//     refresh(){
//         refreshApex(this.res);
//     }
//     enableBtns(){
//         this.isdisabled = false;
//     }
//     disableBtns(){
//         this.isdisabled = true;
//     }
//     countProgress(){
//         let todosCount = 0;
//         let todosDone = 0;
//         this.todos.forEach(element => {
//             if(element.SubToDos__r){
//                 element.SubToDos__r.forEach(element=>{
//                     todosCount++;
//                     todosDone += element.Is_Done__c ? 1 : 0;
//                 });
//             } else {
//                 todosCount++;
//                 todosDone += element.Is_Done__c ? 1 : 0;
//             }
//         });
//         this.progress = (todosDone/todosCount) * 100;
//     }
//     closeRecordTypeModal(){
//         this.recordTypeModalOpened = false;
//     }
//     openRecordTypeModal(){
//         this.recordTypeModalOpened = true;
//     }
//     openCreationModal(){
//         this.recordTypeModalOpened = false;
//         this.creationModalOpened = true;
//     }
//     closeCreationModal(){
//         this.creationModalOpened = false;
//         this.refresh();
//     }
//     changeRecordTypeId(event){
//         this.recordTypeId = event.target.value;
//     }
//     handleShowSubtodos(){
//         this.showsubtodos = !this.showsubtodos;
//     }
//
//
//
// }