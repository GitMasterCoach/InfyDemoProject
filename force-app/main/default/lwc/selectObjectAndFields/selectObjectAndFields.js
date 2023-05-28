import { LightningElement, track, wire } from 'lwc';
    import getObjectInfo from '@salesforce/apex/MyController.getObjectInfo';

    export default class SelectObjectAndFields extends LightningElement {
        @track selectedObject;
        @track selectedFields;
        @track objectOptions = [];
        @track fieldOptions = [];
        @track isFieldsDisabled = true;

        @wire(getObjectInfo)
        wiredObjectInfo({ error, data }) {
            if (data) {
                this.objectOptions = data.map(obj => ({
                    label: obj.label,
                    value: obj.apiName
                }));
            } else if (error) {
                console.error(error);
            }
        }

        handleObjectChange(event) {
            this.selectedObject = event.target.value;
            this.isFieldsDisabled = true;
            this.fieldOptions = [];
            if (this.selectedObject) {
                getObjectInfo({ objectApiName: this.selectedObject })
                    .then(result => {
                        this.fieldOptions = result.fields.map(field => ({
                            label: field.label,
                            value: field.apiName
                        }));
                        this.isFieldsDisabled = false;
                    })
                    .catch(error => {
                        console.error(error);
                    });
            }
        }

        handleFieldsChange(event) {
            this.selectedFields = event.target.value;
        }
    }