/**
 * @description       : 
 * @author            : imrudrakarmakar
 * @group             : 
 * @last modified on  : 08-07-2025
 * @last modified by  : imrudrakarmakar
**/
public with sharing class AccountTriggerHandler {
    public static void beforeInsert(List<Account> accList) {

        if (UTL_TriggerControl.isTriggerDisabled('ACC001')) return;

        Set<String> newAccountNames = new Set<String>();
        for(Account acc : accList) {
            newAccountNames.add(acc.Name);
        }
        
        // Query existing accounts with matching names
        Map<String, Account> existingAccountsMap = new Map<String, Account>();
        for(Account acc : [SELECT Id, Name FROM Account WHERE Name IN :newAccountNames]) {
            existingAccountsMap.put(acc.Name, acc);
        }
        
        // Check for duplicates and add error if found
        for(Account newAcc : accList) {
            if(existingAccountsMap.containsKey(newAcc.Name)) {
                newAcc.addError('An account with the name "' + newAcc.Name + '" already exists. Please use a different name.');
            }
        }
    }
    public static void beforeUpdate(List<Account> accList, Map<Id, Account> oldMap) {}
    public static void beforeDelete(Map<Id, Account> oldMap) {}
    public static void afterInsert(List<Account> accList) {}
    public static void afterUpdate(List<Account> accList, Map<Id, Account> oldMap) {}
    public static void afterDelete(Map<Id, Account> oldMap) {}   
    public static void afterUndelete(List<Account> accList) {} 
}