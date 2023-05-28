public class MyApexClass {
    
    public void postToChatter(String recordId) {
        Invocable.Action action = Invocable.Action.createStandardAction('chatterPost');
        action.setInvocationParameter('text', 'This is an example Chatter post.');
        action.setInvocationParameter('subjectNameOrId', recordId);
        List<Invocable.Action.Result> results = action.invoke();
        if (results.size() > 0 && results[0].isSuccess()) {
            System.debug('Created feed item with ID: ' +
            results[0].getOutputParameters().get('feedItemId'));
        }
    }
    
     public void doubler (Double input) {
        Invocable.Action action = Invocable.Action.createCustomAction('apex', 'Doubler');
        action.setInvocationParameter('input', 1);
        List<Invocable.Action.Result> results = action.invoke();                                          
        if (results.size() > 0 && results[0].isSuccess()) {
            System.debug('Result is: ' + results[0].getOutputParameters().get('output'));
        }
    }

}