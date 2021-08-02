import { LightningElement, api, wire } from 'lwc';
import getsObjectNames from '@salesforce/apex/SObjectFieldsInfo.getsObjectNames';
import uploadCSVFile from '@salesforce/apex/SingleObjectDataCreation.uploadCSVFile';

export default class FileUploadComponent extends LightningElement {
  
    @api isParentChild = false;
    @api comboBoxLabelName = 'Select Object Name';
    @api nextPage = false;
    @api successRecordIdString = '';
    @api parentObjectName;
    isFileUploaded = false;
    objNames;
    selectedObject;    

    // Variables used to track data load progress
    totalNumOfRecords = 0;
    successCount = 0;
    errorCount = 0;
    isErrorOccurred = false;
    csvErrorLog;
    successRecordIDs='';
    jsonObject;
    
    get acceptedFormats() {
        return ['.csv'];
    }
    handleObjectNameChange(event) {       
        this.selectedObject = event.detail.value;  
    }
    
    @wire(getsObjectNames)
    wiredObjectNames({ data, error }) {
        if (data) {
            this.objNames = [{ value: '', label: '--Object Names--' }];
             data.forEach(element => {
                const objName = {};
                objName.label = element;
                objName.value = element;
                this.objNames.push(objName);
            });
            this.objNames.sort( ( a, b )=> {
                a = a.label.toLowerCase();
                b = b.label.toLowerCase();            
                return a < b ? -1 : a > b ? 1 : 0;
            });
        }
    }
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        this.jsonObject = {
            'parentObjectName' : this.parentObjectName,
            'isParentChild' : this.isParentChild,
            'recordIDs' : this.successRecordIdString            
        };
       
        uploadCSVFile({idContentDocument: uploadedFiles[0].documentId, objectName : this.selectedObject, jsonObject: JSON.stringify(this.jsonObject)})
            .then(result => {
                this.totalNumOfRecords = result[0];
                this.successCount = result[1];
                this.errorCount = result[2];
                this.csvErrorLog = result[3];    
                this.successRecordIDs = result[4];  
                this.isFileUploaded = true;             
                if(this.successRecordIDs != ''){
                    this.dispatchEvent(new CustomEvent('createrecord',{detail: this.successRecordIDs}));
                }
                if(this.errorCount > 0){
                    this.isErrorOccurred = true;
                }
            })
            .catch(error => {
                console.log(JSON.stringify(error));
            })
    }

    downloadErrorLogHandler(event){
        let csvData = this.csvErrorLog;  
        let hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvData);
        hiddenElement.target = '_blank';
        hiddenElement.download = `${this.selectedObject}_ErrorLog.csv`;
        hiddenElement.click();       
    }

    handleNext(event){
        this.dispatchEvent(new CustomEvent('nextbuttonclick', {detail: {'parentObjectName':this.selectedObject}}));
    }

    get validateNextButton(){
        return (this.isParentChild==true && this.nextPage==false) ? true : false;
    }   
}