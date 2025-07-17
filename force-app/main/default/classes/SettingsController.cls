global with sharing class SettingsController {
    global class WidgetSettings {
        @AuraEnabled global String apiEndpoint;
        @AuraEnabled global String sitekey;
        @AuraEnabled global String startMode;
        @AuraEnabled global String language;
        @AuraEnabled global String theme;

        global WidgetSettings(Config__mdt config) {
            this.apiEndpoint = config.APIEndpoint__c;
            this.sitekey = config.Sitekey__c;
            this.startMode = config.StartMode__c;
            this.language = config.Language__c;
            this.theme = config.Theme__c;
        }
    }

    @AuraEnabled(cacheable=true)
    global static WidgetSettings get() {
        return new WidgetSettings(Config__mdt.getInstance('Settings'));
    }
}
