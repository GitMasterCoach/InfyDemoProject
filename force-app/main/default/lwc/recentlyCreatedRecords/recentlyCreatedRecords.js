import { LightningElement, wire } from 'lwc';
import getRecentlyCreatedRecords from '@salesforce/apex/RecentlyCreatedRecordsController.getRecentlyCreatedRecords';

const DEFAULT_LIMIT = 10;

export default class RecentlyCreatedRecords extends LightningElement {
    selectedObject;
    recordLimit = DEFAULT_LIMIT;
    tableColumns;
    tableData;

    @wire(getRecentlyCreatedRecords, { objectName: '$selectedObject', limit: '$recordLimit' })
    wiredRecords({ error, data }) {
        if (data) {
            this.tableData = data.map(record => ({ ...record, hasEditAccess: record.hasEditAccess ? true : false }));
            this.tableColumns = Object.keys(data[0]).map(field => ({
                label: field.endsWith('__c') ? field.slice(0, -3) : field,
                fieldName: field,
                type: field.endsWith('__c') ? 'text' : field.endsWith('Date') ? 'date-local' : field.endsWith('Id') ? 'url' : 'text'
            }));
        } else if (error) {
            console.error(error);
        }
    }

    get objectOptions() {
        return [
            { label: 'Account', value: 'Account' },
            { label: 'Contact', value: 'Contact' },
            { label: 'Opportunity', value: 'Opportunity' }
            // add more objects here as needed
        ];
    }

    handleObjectChange(event) {
        this.selectedObject = event.target.value;
    }

    handleLimitChange(event) {
        this.recordLimit = event.target.value;
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'edit':
                this.editRecord(row.Id);
                break;
            default:
                break;
        }
    }

    editRecord(recordId) {
        // navigate to the record edit page
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'edit'
            }
        });
    }
}