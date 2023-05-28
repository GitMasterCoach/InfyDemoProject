import { LightningElement, api, wire } from 'lwc';
import getRecentRecords from '@salesforce/apex/RecentRecordsController.getRecentRecords';

export default class RecentRecords extends LightningElement {
    @api objectApiName='Account';
    @api numberOfRecords=10;
    
    @wire(getRecentRecords, { objectApiName: '$objectApiName', numberOfRecords: '$numberOfRecords' })
    recentRecords;
    
    get fieldApiNames() {
        console.log('inside lwc fields');
        if (this.recentRecords.data && this.recentRecords.data.length > 0) {
            return Object.keys(this.recentRecords.data[0]);
        } else {
            return [];
        }
    }
}