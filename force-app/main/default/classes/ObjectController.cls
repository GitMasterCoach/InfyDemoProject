public with sharing class ObjectController {
   @AuraEnabled(cacheable=true)
    public static List<ObjectOption> getObjectOptions() {
        List<ObjectOption> options = new List<ObjectOption>();
        for (Schema.SObjectType objectType : Schema.getGlobalDescribe().Values()) {
            String objectLabel = objectType.getDescribe().getLabel();
            String objectName = objectType.getDescribe().getName();
            options.add(new ObjectOption(objectName, objectLabel));
        }
      //  options.sort((options a, options b) => a.label.localeCompare(b.label));
      //  Set<>
        return options;
    }
    
    public class ObjectOption {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;

        public ObjectOption(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }
}