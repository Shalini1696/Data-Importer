import { LightningElement } from 'lwc';

export default class ObjectTypeSelection extends LightningElement {

    get options() {
        return [
            { label: 'Single', value: 'option1' },
            { label: 'Parent-Child', value: 'option2' },
        ];
    }

    get labelName(){
        if(isParentChild){
            return "Select Parent Object";
        }
        else{
            return "Select Object";
        }
    }

   handleRadioButtonChange(event) {
       const selectedRadioButtonValue =  event.detail.value;
       const selectedEvent = new CustomEvent('radiobuttonclick', { detail: selectedRadioButtonValue});
       this.dispatchEvent(selectedEvent);
   }
}