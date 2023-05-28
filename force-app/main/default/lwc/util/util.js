import { ShowToastEvent } from 'lightning/platformShowToastEvent';

/**
 * Displays a toast message with the specified title, message, and variant.
 * @param {string} title - The title of the toast message.
 * @param {string} message - The message to display in the toast.
 * @param {string} variant - The variant of the toast (e.g. success, error, warning).
 */
export function showToast(title, message, variant) {
    const event = new ShowToastEvent({
        title,
        message,
        variant
    });
    dispatchEvent(event);
}