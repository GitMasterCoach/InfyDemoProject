import { LightningElement, api, wire } from 'lwc';
import getRecentRecords from '@salesforce/apex/RecentRecordsController.getRecentRecords';

export default class RecentRecords extends LightningElement {
    @api objectApiName='Account';
    @api numberOfRecords=10;
    
    @wire(getRecentRecords, { objectApiName: '$objectApiName', numberOfRecords: '$numberOfRecords' })
    recentRecords;
    
    get fieldApiNames() {
        console.log('Records==>:'+this.recentRecords.data );
        if (this.recentRecords.data && this.recentRecords.data.length > 0) {
            console.log('Records==>14:'+this.recentRecords.data );
            return Object.keys(this.recentRecords.data[0]);
        } else {
            console.log('else empty' );
            return [];
        }
    }
}