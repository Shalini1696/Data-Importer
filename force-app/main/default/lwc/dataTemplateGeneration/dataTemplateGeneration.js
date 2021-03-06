import { LightningElement } from 'lwc';

export default class DataTemplateGeneration extends LightningElement {
    
    comboBoxLabelName = 'Select Object Name';
    selectedOption = 'option1';
    isParentChild = false;    
    parentObjectName;
    firstPageDataTemplate = true;
    nextPageDataTemplate = false; 
    successRecordIDString = '';

    selectedRadioButtonHandler(event){
        this.selectedOption = event.detail; 
        if(this.selectedOption == 'option2'){
            this.isParentChild = true;           
            this.comboBoxLabelName = 'Select Parent Object';
        }   
        else{
            this.isParentChild = false;           
            this.comboBoxLabelName = 'Select Object Name';
        }               
    }

    createRecordHandler(event){
        this.successRecordIDString = event.detail;
    }

    nextButtonHandlerDataTemplate(){
        this.nextPageDataTemplate = true;
        this.firstPageDataTemplate = false;
    }
}