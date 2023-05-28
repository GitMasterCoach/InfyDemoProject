public with sharing class AssignmentTreeController {
    @AuraEnabled(cacheable=true)
    public static List<AssignmentGroupWrapper> getAssignmentGroupsWithAssignments() {
        List<AssignmentGroupWrapper> assignmentGroupWrappers = new List<AssignmentGroupWrapper>();

        // Query AssignmentGroup__c records with related Assignments__r
        List<AssignmentGroup__c> assignmentGroups = [SELECT Id, GroupName__c, GroupDescription__c,
                                                      (SELECT Id, Title__c, Description__c, DueDate__c, Status__c, Priority__c
                                                       FROM Assignments__r
                                                       ORDER BY DueDate__c)
                                                     FROM AssignmentGroup__c
                                                     ORDER BY GroupName__c];

        // Create assignment group wrapper objects
        for (AssignmentGroup__c assignmentGroup : assignmentGroups) {
            AssignmentGroupWrapper wrapper = new AssignmentGroupWrapper();
            wrapper.assignmentGroup = assignmentGroup;

            // Add assignments to the assignment group wrapper
            for (Assignment__c assignment : assignmentGroup.Assignments__r) {
                wrapper.assignments.add(assignment);
            }

            assignmentGroupWrappers.add(wrapper);
        }

        return assignmentGroupWrappers;
    }

    public class AssignmentGroupWrapper {
        @AuraEnabled
        public AssignmentGroup__c assignmentGroup;
        @AuraEnabled
        public List<Assignment__c> assignments;

        public AssignmentGroupWrapper() {
            assignments = new List<Assignment__c>();
        }
    }
}