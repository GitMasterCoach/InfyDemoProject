import { LightningElement, wire, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { showToast } from 'c/util';

export default class searchRecentRecords extends LightningElement {
    @track objectOptions = [{label:'Account',value:'Account'}];
    @track selectedObject = 'Account';
    @track fields = null;

    @wire(getObjectInfo, {})
    objectInfo({ error, data }) {
        if (data) {
            alert(JSON.stringify(data));
            const objectInfos = Object.values(data);
            this.objectOptions = objectInfos.map(info => ({
                label: info.label,
                value: info.apiName
            }));
        } else if (error) {
            alert(JSON.stringify(error));
            showToast('Error', error.message, 'error');
        }
    }

    @wire(getObjectInfo, { objectApiName: '$selectedObject' })
    objectFields({ error, data }) {
        if (data) {
            this.fields = Object.keys(data.fields);
        } else if (error) {
            showToast('Error', error.message, 'error');
        }
    }

    handleObjectChange(event) {
        this.selectedObject = event.target.value;
    }

    handleFetchFields() {
        if (!this.selectedObject) {
            showToast('Error', 'Please select an object first.', 'error');
            return;
        }
    }
}