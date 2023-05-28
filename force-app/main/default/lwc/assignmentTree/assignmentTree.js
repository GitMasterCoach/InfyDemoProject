import { LightningElement, wire, track } from 'lwc';
import getAssignmentGroupsWithAssignments from '@salesforce/apex/AssignmentTreeController.getAssignmentGroupsWithAssignments';

export default class AssignmentTree extends LightningElement {
    @track assignmentGroups = [];
    @track columns = [
        { label: 'Group Name', fieldName: 'GroupName__c', type: 'text' },
        { label: 'Group Description', fieldName: 'GroupDescription__c', type: 'text' },
    ];
    @track expandedRows = [];

    @wire(getAssignmentGroupsWithAssignments)
    wiredAssignmentGroups({ error, data }) {
        if (data) {
            this.assignmentGroups = data;
            // Expand the first level of assignment groups by default
            this.expandedRows = this.assignmentGroups.map(group => group.Id);
        } else if (error) {
            // Handle error
            console.error('Error fetching assignment groups:', error);
        }
    }
}