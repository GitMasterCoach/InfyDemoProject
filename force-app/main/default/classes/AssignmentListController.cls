public with sharing class AssignmentListController {
    @AuraEnabled(cacheable=true)
    public static List<Assignment__c> getAssignments(String titleFilter, String priorityFilter) {
        String query = 'SELECT Id, Title__c, Description__c, DueDate__c, Status__c, Priority__c ' +
                       'FROM Assignment__c ' +
                       'WHERE Title__c LIKE \'%' + titleFilter + '%\' ' +
                       'AND Priority__c = \'' + priorityFilter + '\' ' +
                       'ORDER BY DueDate__c ASC ' +
                       'LIMIT 10';
        return Database.query(query);
    }
}