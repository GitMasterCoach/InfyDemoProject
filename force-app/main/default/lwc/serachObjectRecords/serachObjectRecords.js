import { LightningElement, wire, track } from 'lwc';
import { getObjectInfo, getRecord } from 'lightning/uiRecordApi';
import { showToast } from 'c/utils';

export default class SearchAndDisplayRecords extends LightningElement {
    @track objectName;
    @track objectFields;
    @track selectedFields = [];
    @track objectRecords;

    handleObjectNameChange(event) {
        this.objectName = event.target.value;
        this.selectedFields = [];
        this.objectRecords = null;
    }

    handleFieldsChange(event) {
        this.selectedFields = event.target.value;
        this.objectRecords = null;
    }

    @wire(getObjectInfo, { objectApiName: '$objectName' })
    wiredObjectInfo({ error, data }) {
        if (data) {
            this.objectFields = Object.values(data.fields).map(field => {
                return {
                    label: field.label,
                    value: field.apiName
                };
            });
        } else if (error) {
            showToast('Error', error.body.message, 'error');
        }
    }

    @wire(getRecord, { recordId: '$objectId', fields: '$selectedFields' })
    wiredRecord({ error, data }) {
        if (data) {
            this.objectRecords = [data.fields];
        } else if (error) {
            showToast('Error', error.body.message, 'error');
        }
    }

    get objectId() {
        let result = null;
        if (this.objectName) {
            result = `SELECT Id FROM ${this.objectName} ORDER BY CreatedDate DESC LIMIT 1`;
        }
        return result;
    }
}