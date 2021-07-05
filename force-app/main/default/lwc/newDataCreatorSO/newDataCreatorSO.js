import { LightningElement, track, wire } from 'lwc';
import parseCSVFileData from '@salesforce/apex/SObjectFieldsInfo.parseCSVFileData';

export default class newDataCreatorSO extends LightningElement {

    currentStep = 'step-1';
    disableNextButton1 = true;
    disableNextButton2 = true;
    disableFinishButton = true;
    isParentChild = false;
    isErrorOccurred = false;
   
     // Variables used to track data load progress
     totalNumOfRecords = 0;
     successCount = 0;
     errorCount = 0;
     csvErrorLog;
 
     selectedObj1;
     //selectedObj2;
     selectedRadioButton = '';

     get options() {
         return [
             { label: 'Single', value: 'option1' },
             { label: 'Parent-Child', value: 'option2' },
         ];
     }

    handleRadioButtonChange(event) {
        this.selectedRadioButton = event.detail.value;
        this.disableNextButton1 = false;
        if(this.selectedRadioButton == 'option2'){
            this.isParentChild = true;
        }
        else{
            this.isParentChild = false;
        }
    }
  
    get validateStep1(){
        return (this.currentStep=='step-1');
    }

    get validateStep2(){
        return (this.currentStep=='step-2');
    }    

    get validateStep2a(){
        return (this.currentStep=='step-2a');
    }  

    get validateStep3(){
        return (this.currentStep=='step-3');
    }

    getObjectFieldsHandler(event){
        this.disableNextButton2 = false;
        this.selectedObj1 = event.detail.selectedObj;
    }

    downloadErrorLogHandler(event){
        let csvData = this.csvErrorLog;  
        let hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvData);
        hiddenElement.target = '_blank';
        hiddenElement.download = `${this.selectedObj1}_ErrorLog.csv`;
        hiddenElement.click();
        this.disableSubmitButton = false;
    }
    
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        this.disableFinishButton = false;
        parseCSVFileData({idContentDocument : uploadedFiles[0].documentId, objectName: this.selectedObj1})
            .then(result => {
                this.totalNumOfRecords = result[0];
                this.successCount = result[1];
                this.errorCount = result[2];
                this.csvErrorLog = result[3];    
                
                if(this.errorCount > 0){
                    this.isErrorOccurred = true;
                }
            })
            .catch(error => {
                console.log(JSON.stringify(error));
            })
    }

    handleNext(){
        let curStep = this.currentStep;
        if(curStep === 'step-1'){
            this.currentStep = 'step-2';
        }
        else if(curStep === 'step-2' && this.isParentChild == false){
            this.currentStep = 'step-3';
        }
        else if(curStep === 'step-2' && this.isParentChild == true){
            this.currentStep = 'step-2a';
        }
        else if(curStep === 'step-2a'){
            this.currentStep = 'step-3';
        }
        else if(curStep === 'step-3'){
            this.currentStep = 'step-1';
            this.disableNextButton1 = false;
            this.disableNextButton2 = true;  
            this.disableFinishButton = true;
            this.isErrorOccurred = false;
        }      
    }   
}