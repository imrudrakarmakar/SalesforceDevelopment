/**
 * @description       : This class controls the enabling and disabling of triggers based on user settings.
 * @author            : imrudrakarmakar
 * @group             : 
 * @last modified on  : 08-07-2025
 * @last modified by  : imrudrakarmakar
**/
public with sharing class UTL_TriggerControl {

    @TestVisible private static Set<String> disabledTriggers = new Set<String>();
    @TestVisible private static Boolean disableAllTriggers = false;
    @TestVisible private static Boolean isInitialized = false;

    @TestVisible private static void initialize() {
        if (isInitialized) return;
        isInitialized = true;

        TRG_TriggerActivationSettings__c settings = TRG_TriggerActivationSettings__c.getInstance(UserInfo.getUserId());
        if (settings == null) {
            settings = TRG_TriggerActivationSettings__c.getOrgDefaults();
        }

        if (settings != null) {
            disableAllTriggers = settings.TRG_Disable_All_Triggers__c;

            if (!String.isBlank(settings.TRG_Triggers_To_Disable_List__c)) {
                List<String> items = settings.TRG_Triggers_To_Disable_List__c.split(',');
                for (String item : items) {
                    disabledTriggers.add(item.trim().toLowerCase());
                }
            }
        }
    }

    public static Boolean isTriggerDisabled(String triggerKey) {
        initialize();
        if (disableAllTriggers) return true;
        return disabledTriggers.contains(triggerKey.toLowerCase());
    }

}