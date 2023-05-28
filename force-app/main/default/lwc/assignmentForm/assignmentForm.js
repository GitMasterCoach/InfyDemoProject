import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AssignmentForm extends LightningElement {
    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;

        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess() {
        const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Assignment created/updated successfully.',
            variant: 'success'
        });
        this.dispatchEvent(toastEvent);

        // Refresh assignmentList component
        const refreshEvent = new CustomEvent('refresh');
        this.dispatchEvent(refreshEvent);
    }
}