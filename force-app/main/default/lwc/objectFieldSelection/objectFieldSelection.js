import { LightningElement, wire, api, track } from 'lwc';
import getObjectFields from '@salesforce/apex/SObjectFieldsInfo.getObjectFields';
import getsObjectNames from '@salesforce/apex/SObjectFieldsInfo.getsObjectNames';
import getRequiredFields from '@salesforce/apex/SObjectFieldsInfo.getRequiredFields';
import getFieldType from '@salesforce/apex/SObjectFieldsInfo.getFieldType';

export default class ObjectFieldSelection extends LightningElement {
    selectedObject; //Selected Object from ComboBox
    @api comboBoxLabelName = 'Select Object Name';
    @api isParentChild = false;
    @api nextPage = false;
   
    objNames; //Holds all Standard & Custom object Names
    fieldNames = []; //Holds all the fields of an object

    //lightning dual-list box variables
    selected = [];
    values = [];
    requiredOptions = [];
    
    @track mapOfFieldTypes = [];

     handleObjectNameChange(event) {
        this.selectedObject = event.detail.value;
    }

    selectedOptionHandler(event) {
        this.selected = event.detail.value; 
    }

    get selectedFields() {
        return this.selected.length ? this.selected : 'none';
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

    @wire(getObjectFields, { objectName: '$selectedObject' })
    wiredObjectFields({ data, error }) {
        if (data) {
            const fnames = [];
            data.forEach(element => {
                const fieldName = {};
                fieldName.label = element;
                fieldName.value = element;
                fnames.push(fieldName);
            });
            this.fieldNames = fnames.slice();          
            this.fieldNames.sort( ( a, b )=> {
                a = a.label.toLowerCase();
                b = b.label.toLowerCase();            
                return a < b ? -1 : a > b ? 1 : 0;
            });
        }
    }

    @wire(getRequiredFields, { objectName: '$selectedObject' })
    wiredRequiredFields({ data, error }) {
        if (data) {
            const reqField = [];
            data.forEach(element => {
                reqField.push(element);
            });
            this.requiredOptions = reqField.slice();
            this.values = this.requiredOptions;
           }
    }
 
    @wire(getFieldType, { objectName: '$selectedObject', selectedFieldNames: '$selected'})
    wiredFieldTypes({data, error}){
        if(data){   
            const fieldTypes = [];
            for(let key in data) {
                if (data.hasOwnProperty(key)) { 
                    fieldTypes.push({value:data[key], key:key});
                }
            }
            this.mapOfFieldTypes = fieldTypes.slice();
        }
        else if(error){
            console.log(JSON.stringify(error));
        }
    }
    
    downloadTemplateHandler(event) {
        let header = this.selected + "\n"; 
        let csvFile = document.createElement('a');
     //   csvFile.href = 'data:application/excel;base64,' + encodeURI(header);
        csvFile.href = 'data:text/csv;charset=utf-8,' + encodeURI(header);
        csvFile.target = '_blank';
        csvFile.download = `${this.selectedObject}.csv`;
        csvFile.click();
    }

    

    handleNext(event){
        this.dispatchEvent(new CustomEvent('nextbuttonclick'));
    }
    
    get validateNextButton(){
        return (this.isParentChild==true && this.nextPage==false) ? true : false;
    }

}