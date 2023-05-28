import { LightningElement, wire } from 'lwc';
import getObjectOptions from '@salesforce/apex/ObjectController.getObjectOptions';
import getRecentlyCreatedRecords from '@salesforce/apex/RecentlyCreatedRecordsController.getRecentlyCreatedRecords';
export default class RecentlyCreatedRecordsForGivenObject extends LightningElement {
	  selectedObject;
    objectOptions = [];
		displayCount=10;

    @wire(getObjectOptions)
    wiredObjectOptions({error, data}) {
        if (data) {
            this.objectOptions = data;
        } else if (error) {
            console.log(error);
        }
    }

    handleChange(event) {
        this.selectedObject = event.detail.value;
        // handle selected object change here
				alert('selected object entity'+ this.selectedObject);
				//this.objectName = event.target.value;
        if (this.selectedObject) {
            getRecentlyCreatedRecords({ objectName: this.selectedObject,strlimit:this.displayCount})
                .then(result => {
                    this.fields = result;
                })
                .catch(error => {
                    console.error(error);
                });
        } else {
            this.fields = [];
        }
				console.log('Fields Records==>'+JSON.stringify(this.fields));
    }
		
}