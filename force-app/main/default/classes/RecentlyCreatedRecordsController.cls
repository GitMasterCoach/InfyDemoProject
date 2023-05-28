public with sharing class RecentlyCreatedRecordsController {
    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecentlyCreatedRecords(String objectName, Integer strlimit) {
        System.debug('objectName===>:'+objectName); 
          System.debug('strlimit===>:'+strlimit);
        // Get the SObjectType for the selected object
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        
        // Check if the user has access to the selected object
        if (objType == null || !objType.getDescribe().isAccessible()) {
            throw new AuraHandledException('Invalid object selection');
        }
        
        // Get the fields to display from custom metadata
        List<RecentlyCreatedRecordsMetadata__mdt> metadataList = [SELECT Id, DeveloperName, Display_Fields__c FROM RecentlyCreatedRecordsMetadata__mdt  WHERE Object__c = :objectName];
         System.debug('metadataList===>:'+metadataList);
        List<String> fieldsList = new List<String>();
        if (metadataList.size() == 0) {
            // Default fields to display if no metadata record is found
            fieldsList = new List<String>{'Name', 'CreatedDate', 'CreatedBy.Name'};
        } else {
            // Parse the fields from the metadata record
            String[] fieldsArr = metadataList[0].Display_Fields__c.split(',');
            for (String field : fieldsArr) {
                fieldsList.add(field.trim());
            }
        }
        System.debug('fieldsList===>:'+fieldsList);
        // Build the SOQL query to get the recently created records
        String query = 'SELECT ' + String.join(fieldsList, ',') + ' FROM ' + objectName + ' LIMIT '+strlimit;
        System.debug('query'+query);
        List<SObject> records = Database.query(query);
        System.debug('records===.>>'+records);
        // Check if the user has edit access to each record
      /*  for (SObject record : records) {
            Id recordId = record.Id;
            if (recordId != null ) {//&& record.sObjectType.getDescribe().isUpdateable()
                record.put('hasEditAccess', true);
            } else {
                record.put('hasEditAccess', false);
            }
        }
        System.debug('records===>:'+records);*/
        return records;
    }
}