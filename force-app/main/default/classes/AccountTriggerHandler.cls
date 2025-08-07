/**
 * @description       : 
 * @author            : imrudrakarmakar
 * @group             : 
 * @last modified on  : 08-08-2025
 * @last modified by  : imrudrakarmakar
**/
public with sharing class AccountTriggerHandler {
    
    public static void preventDuplicateAccount(List<Account> accList) {

        if (UTL_TriggerControl.isTriggerDisabled('ACC001')) return;

        // Collect all new account names
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

    public static void preventAccountDeletionIfConactIsPotentialBuyer(List<Account> oldAccounts) {
        if (UTL_TriggerControl.isTriggerDisabled('ACC002')) return;
        
        if (oldAccounts == null || oldAccounts.isEmpty()) return;

        Set<Id> accountIds = new Set<Id>();
        for (Account acc : oldAccounts) {
            accountIds.add(acc.Id);
        }

        // Query contacts marked as potential buyer
        Set<Id> accountsWithBuyers = new Set<Id>();
        for (Contact con : [
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId IN :accountIds AND Potential_Buyer__c = true
        ]) {
            accountsWithBuyers.add(con.AccountId);
        }

        // Add error to accounts that have potential buyer contacts
        for (Account acc : oldAccounts) {
            if (accountsWithBuyers.contains(acc.Id)) {
                acc.addError('Cannot delete this Account as it has at least one Contact marked as a Potential Buyer.');
            }
        }
    }

    public static void distributeBudgetAmongOpportunities(List<Account> newList, Map<Id, Account> oldMap) {
        if (UTL_TriggerControl.isTriggerDisabled('ACC003')) return;

        Set<Id> accountIdsToUpdate = new Set<Id>();
        Map<Id, Decimal> updatedAccountBudgets = new Map<Id, Decimal>();

        for (Account acc : newList) {
            Account oldAcc = oldMap.get(acc.Id);
            if (acc.Total_Budget__c != oldAcc.Total_Budget__c) {
                accountIdsToUpdate.add(acc.Id);
                updatedAccountBudgets.put(acc.Id, acc.Total_Budget__c);
            }
        }
        
        if (accountIdsToUpdate.isEmpty()) return;

        // Fetch related Opportunities
        Map<Id, List<Opportunity>> accIdToOppsMap = new Map<Id, List<Opportunity>>();
        List<Opportunity> opportunities = [
            SELECT Id, AccountId, Budget__c
            FROM Opportunity
            WHERE AccountId IN :accountIdsToUpdate
        ];

        for (Opportunity opp : opportunities) {
            if (!accIdToOppsMap.containsKey(opp.AccountId)) {
                accIdToOppsMap.put(opp.AccountId, new List<Opportunity>());
            }
            accIdToOppsMap.get(opp.AccountId).add(opp);
        }

        // Prepare updated Opportunities
        Map<Id, Decimal> perOpportunityBudget = new Map<Id, Decimal>();
        for (Id accId : updatedAccountBudgets.keySet()) {
            if(accIdToOppsMap.containsKey(accId)) {
                Integer oppCount = accIdToOppsMap.get(accId).size();
                if(oppCount > 0) {
                    perOpportunityBudget.put(accId, updatedAccountBudgets.get(accId) / oppCount);
                }
            }
        }
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        for (Opportunity opp : opportunities) {
            if(perOpportunityBudget.containsKey(opp.AccountId)) {
                opp.Budget__c = perOpportunityBudget.get(opp.AccountId);
                opportunitiesToUpdate.add(opp);
            }
        }

        if (!opportunitiesToUpdate.isEmpty()) {
            update opportunitiesToUpdate;
        }
    }

    public static void beforeUpdate(List<Account> accList, Map<Id, Account> oldMap) {}
    public static void beforeDelete(Map<Id, Account> oldMap) {}
    public static void afterInsert(List<Account> accList) {}
    public static void afterUpdate(List<Account> accList, Map<Id, Account> oldMap) {}
    public static void afterDelete(Map<Id, Account> oldMap) {}   
    public static void afterUndelete(List<Account> accList) {} 
}