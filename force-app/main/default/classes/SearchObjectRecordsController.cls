public with sharing class SearchObjectRecordsController {
    @AuraEnabled(cacheable=true)
    public static List<sObject> searchObjectRecords(String searchObject, List<String> selectedFields) {
        String soql = 'SELECT Id, LastModifiedDate, LastModifiedById, ' + String.join(selectedFields, ',') + ' FROM ' + searchObject + ' ORDER BY LastModifiedDate DESC LIMIT 10';
        return Database.query(soql);
    }
}