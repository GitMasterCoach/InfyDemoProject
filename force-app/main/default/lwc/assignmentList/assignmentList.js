import { LightningElement, wire, api, track } from 'lwc';
import getAssignments from '@salesforce/apex/AssignmentListController.getAssignments';

export default class AssignmentList extends LightningElement {
    @track assignments = [];
    @track columns = [
        { label: 'Title', fieldName: 'Title__c', type: 'text' },
        { label: 'Description', fieldName: 'Description__c', type: 'text' },
        { label: 'Due Date', fieldName: 'DueDate__c', type: 'date' },
        { label: 'Status', fieldName: 'Status__c', type: 'text' },
        { label: 'Priority', fieldName: 'Priority__c', type: 'text' },
    ];
    @track currentPage = 1;
    @track disablePrevious = true;
    @track disableNext = false;
    @track titleFilter = '';
    @track priorityFilter = '';
    @api
    refreshData() {
        this.fetchAssignments();
    }
    handleTitleChange(event) {
        this.titleFilter = event.target.value;
        this.currentPage = 1;
        this.fetchAssignments();
    }
    handlePriorityChange(event) {
        this.priorityFilter = event.target.value;
        this.currentPage = 1;
        this.fetchAssignments();
    }
    previousPage() {
        this.currentPage--;
        this.fetchAssignments();
    }
    nextPage() {
        this.currentPage++;
        this.fetchAssignments();
    }
    fetchAssignments() {
        getAssignments({ titleFilter: this.titleFilter, priorityFilter: this.priorityFilter })
            .then(result => {
                this.assignments = result;
                this.disablePrevious = this.currentPage === 1;
                this.disableNext = result.length < 10;
            })
            .catch(error => {
                // Handle error
                console.error('Error fetching assignments:', error);
            });
    }
}