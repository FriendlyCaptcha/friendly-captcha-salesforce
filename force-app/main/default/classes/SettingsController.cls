public with sharing class SettingsController {
    public class WidgetSettings {
        @AuraEnabled public String apiEndpoint;
        @AuraEnabled public String sitekey;
        @AuraEnabled public String startMode;
        @AuraEnabled public String language;
        @AuraEnabled public String theme;

        public WidgetSettings(FriendlyCaptchaConfig__mdt config) {
            this.apiEndpoint = config.APIEndpoint__c;
            this.sitekey = config.Sitekey__c;
            this.startMode = config.StartMode__c;
            this.language = config.Language__c;
            this.theme = config.Theme__c;
        }
    }

    @AuraEnabled(cacheable=true)
    public static WidgetSettings get(){
        return new WidgetSettings(FriendlyCaptchaConfig__mdt.getInstance('Settings'));
    }
}