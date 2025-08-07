/**
 * @description       : This is the trigger for Account object which handles all the DML operations.
 *                      It calls the AccountTriggerHandler class methods based on the trigger context.
 *                      The trigger is controlled by the UTL_TriggerControl class to enable or disable specific
 *                      trigger events.
 *                      This helps in managing the trigger execution flow and prevents unnecessary processing.
 *                      The trigger is designed to handle before and after events for insert, update, delete,
 *                      and undelete operations.
 * @author            : imrudrakarmakar
 * @group             : 
 * @last modified on  : 08-08-2025
 * @last modified by  : imrudrakarmakar
**/
trigger Account_Trigger on Account (before insert, before update, before delete, after insert, after update, after delete,  after undelete) {

    if (UTL_TriggerControl.isTriggerDisabled('Account_Trigger')) return;

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            if (!UTL_TriggerControl.isTriggerDisabled('Account_BeforeInsert')) {
                AccountTriggerHandler.preventDuplicateAccount(Trigger.new);
            }
        } else if (Trigger.isUpdate) {
            if (!UTL_TriggerControl.isTriggerDisabled('Account_BeforeUpdate')) {
                AccountTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
            }
        } else if (Trigger.isDelete) {
            if (!UTL_TriggerControl.isTriggerDisabled('Account_BeforeDelete')) {
                AccountTriggerHandler.preventAccountDeletionIfConactIsPotentialBuyer(Trigger.old);
            }
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            if (!UTL_TriggerControl.isTriggerDisabled('Account_AfterInsert')) {
                AccountTriggerHandler.afterInsert(Trigger.new);
            }
        } else if (Trigger.isUpdate) {
            if (!UTL_TriggerControl.isTriggerDisabled('Account_AfterUpdate')) {
                AccountTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
            }
        } else if (Trigger.isDelete) {
            if (!UTL_TriggerControl.isTriggerDisabled('Account_AfterDelete')) {
                AccountTriggerHandler.afterDelete(Trigger.oldMap);
            }
        } else if (Trigger.isUndelete) {
            if (!UTL_TriggerControl.isTriggerDisabled('Account_AfterUndelete')) {
                AccountTriggerHandler.afterUndelete(Trigger.new);
            }
        }
    }
}