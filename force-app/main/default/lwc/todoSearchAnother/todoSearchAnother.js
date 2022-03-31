import {LightningElement} from 'lwc';

export default class todoSearchAnother extends LightningElement {

    nameKey = '';
    priorityKey = '';
    optionsForPriority = [
        {value: '', label: 'All'}, 
        {value: 'High', label: 'High'}, 
        {value: 'Medium', label: 'Medium'}, 
        {value: 'Low', label: 'Low'}, 
    ];

    handlePriorityChange(event){
        this.priorityKey = event.target.value;
        this.sendKeyChangeEvent();
    }

    handleNameKeyChange(event){
        this.nameKey = event.target.value;
        this.sendKeyChangeEvent();
    }

    sendKeyChangeEvent(){
        this.dispatchEvent(new CustomEvent('keychange', {
            detail: {
                nameKey: this.nameKey,
                priorityKey : this.priorityKey
            }
        }));
    }

}