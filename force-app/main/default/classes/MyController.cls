public with sharing class MyController {
    @AuraEnabled(cacheable=true)
    public static List<ObjectInfo> getObjectInfo() {
        List<ObjectInfo> objectInfos = new List<ObjectInfo>();
        for (Schema.SObjectType objectType : Schema.getGlobalDescribe().values()) {
            Schema.DescribeSObjectResult describeResult = objectType.getDescribe();
            if (describeResult.isQueryable()) {
                ObjectInfo obj = new ObjectInfo();
                obj.apiName = describeResult.getName();
                obj.label = describeResult.getLabel();
                objectInfos.add(obj);
            }
        }
        return objectInfos;
    }

    @AuraEnabled(cacheable=true)
    public static ObjectInfo getFieldInfo(String objectApiName) {
        ObjectInfo objInfo = new ObjectInfo();
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName);
        if (objectType != null) {
            Schema.DescribeSObjectResult describeResult = objectType.getDescribe();
            if (describeResult.isQueryable()) {
                objInfo.apiName = describeResult.getName();
                objInfo.label = describeResult.getLabel();
                objInfo.fields = new List<FieldInfo>();
                for (Schema.SObjectField field : describeResult.fields.getMap().values()) {
                    Schema.DescribeFieldResult fieldResult = field.getDescribe();
                    FieldInfo fieldInfo = new FieldInfo();
                    fieldInfo.apiName = fieldResult.getName();
                    fieldInfo.label = fieldResult.getLabel();
                    objInfo.fields.add(fieldInfo);
                }
            }
        }
        return objInfo;
    }

    public class ObjectInfo {
        @AuraEnabled public String apiName { get; set; }
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public List<FieldInfo> fields { get; set; }
    }

    public class FieldInfo {
        @AuraEnabled public String apiName { get; set; }
        @AuraEnabled public String label { get; set; }
    }
}