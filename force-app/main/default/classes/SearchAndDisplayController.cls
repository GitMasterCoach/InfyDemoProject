public with sharing class SearchAndDisplayController {
    
    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecords(String objectApiName, List<String> fields) {
        String soql = 'SELECT ' + String.join(fields, ',') + ' FROM ' + objectApiName + ' ORDER BY CreatedDate DESC LIMIT 10';
        return Database.query(soql);
    }
    
  //  @AuraEnabled(cacheable=true)
    public static List<Schema.DescribeSObjectResult> searchObjects(String searchTerm) {
        List<Schema.DescribeSObjectResult> objectResults = new List<Schema.DescribeSObjectResult>();
        for (Schema.SObjectType objectType : Schema.getGlobalDescribe().values()) {
            Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
            if (objectDescribe.isQueryable() && objectDescribe.getLabel().toLowerCase().contains(searchTerm.toLowerCase())) {
                objectResults.add(objectDescribe);
            }
        }
        return objectResults;
    }
}