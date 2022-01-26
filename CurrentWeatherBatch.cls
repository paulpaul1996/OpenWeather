public with sharing class CurrentWeatherBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, BillingLongitude, BillingLatitude, AccountCurrentWeather__c FROM Account '
        );
    }
    public void execute(Database.BatchableContext bc, List<Account> scope){
        String endpoint; 
        List<Account> accounts = new List<Account>();
        for (Account account : scope) {
            if(account.BillingLatitude != null && account.BillingLongitude != null) {
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();
                endpoint = 'https://api.openweathermap.org/data/2.5/onecall?lat=' + account.BillingLatitude +'&lon=' + account.BillingLongitude + '&appid=09a93c50ae11be4f195dbb9a9d1caff5';
                req.setEndpoint(endpoint);
                req.setMethod('GET');
    
                res = http.send(req);
                String sJson = res.getBody();
                Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(sJson);
                Map<String,Object> currentData = (Map<String,Object>)responseMap.get('current');
                List<Object> weatherData = (List<Object>)currentData.get('weather');
                Map<String,Object> weatherObject = (Map<String, Object>)weatherData[0];
                account.AccountCurrentWeather__c = (String)weatherObject.get('description');
            } else {
                account.AccountCurrentWeather__c = 'Could not get geolocation values on this billing address';
            }
            // add account to list to be updated
            accounts.add(account);
        }
        update accounts;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('Finish updating account weather');
    }
}