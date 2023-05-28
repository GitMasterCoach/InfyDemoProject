public with sharing class RecentRecordsController {
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getRecentRecords(String objectName, Integer strlimit, String userId, String[] selectedFields) {
        
        // Check if user has access to object
        DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        if (!objectDescribe.isAccessible()) {
            return new List<Map<String, Object>>();
        }
        
        // Check if user has read access to object
        Schema.DescribeSObjectResult objectResult = objectDescribe;
        if (!objectResult.isCreateable()) {
            return new List<Map<String, Object>>();
        }
        
        // Get fields to query
        String queryFields = '';
        if (selectedFields != null && selectedFields.size() > 0) {
            for (String field : selectedFields) {
                queryFields += ',' + field;
            }
        } else {
            queryFields = ',Name,CreatedDate,CreatedById';
        }
        
        // Query for records
        String query = 'SELECT Id' + queryFields + ' FROM ' + objectName + ' WHERE CreatedById = :userId ORDER BY CreatedDate DESC LIMIT :strlimit';
        List<sObject> records = Database.query(query);
        
        // Build list of record maps to return
        List<Map<String, Object>> recentRecords = new List<Map<String, Object>>();
        for (sObject record : records) {
            Map<String, Object> recordMap = new Map<String, Object>();
            recordMap.put('Id', record.Id);
            recordMap.put('Name', record.get('Name'));
            recordMap.put('CreatedDate', record.get('CreatedDate'));
            recordMap.put('CreatedById', record.get('CreatedById'));
            recordMap.put('EditLink', (objectResult.isUpdateable()) ? '/' + record.Id + '/e' : null);
            recentRecords.add(recordMap);
        }
        
        return recentRecords;
    }
}