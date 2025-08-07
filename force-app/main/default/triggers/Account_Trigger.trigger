/**
 * @description       : 
 * @author            : imrudrakarmakar
 * @group             : 
 * @last modified on  : 08-07-2025
 * @last modified by  : imrudrakarmakar
**/
trigger Account_Trigger on Account (before insert, before update, before delete, after insert, after update, after delete,  after undelete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            AccountTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
            AccountTriggerHandler.beforeDelete(Trigger.oldMap);
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.afterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            AccountTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
            AccountTriggerHandler.afterDelete(Trigger.oldMap);
        } else if (Trigger.isUndelete) {
            AccountTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}