/**
 * @description       : 
 * @author            : imrudrakarmakar
 * @group             : 
 * @last modified on  : 08-07-2025
 * @last modified by  : imrudrakarmakar
**/
public with sharing class AccountTriggerHandler {
    public static void beforeInsert(List<Account> accList) {}
    public static void beforeUpdate(List<Account> accList, Map<Id, Account> oldMap) {}
    public static void beforeDelete(Map<Id, Account> oldMap) {}
    public static void afterInsert(List<Account> accList) {}
    public static void afterUpdate(List<Account> accList, Map<Id, Account> oldMap) {}
    public static void afterDelete(Map<Id, Account> oldMap) {}   
    public static void afterUndelete(List<Account> accList) {} 
}