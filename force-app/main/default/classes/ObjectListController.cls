public with sharing class ObjectListController {
    
    // Get a list of all objects in the org
    @AuraEnabled(cacheable=true)
    public static List<sObject> getObjectInfo() {
        List<sObject> objects = new List<sObject>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        for (String s : schemaMap.keySet()) {
            if(objects.size()<10){
                objects.add(schemaMap.get(s).newSObject()); 
                break;
            }
        }
        System.debug('objects==>:'+objects);
        return objects;
    }
    
    // Get a list of fields for the specified object
    @AuraEnabled(cacheable=true)
    public static List<FieldDescribe> getObjectFields(String objectName) {
        List<FieldDescribe> fields = new List<FieldDescribe>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType objectType = schemaMap.get(objectName);
        if (objectType != null) {
            Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();
            for (String fieldName : fieldMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
                fields.add(new FieldDescribe(fieldName, fieldDescribe.getLabel(), fieldDescribe.getType().name()));
            }
        }
        System.debug('Fields:'+fields);
        return fields; 
    }
    
    // Inner class to represent a field description
    public class FieldDescribe {
        @AuraEnabled public String apiName;
        @AuraEnabled public String label;
        @AuraEnabled public String type;
        
        public FieldDescribe(String apiName, String label, String type) {
            this.apiName = apiName;
            this.label = label;
            this.type = type;
        }
    }
    
}