@IsTest
public with sharing class CurrentWeatherBatchTest {
    @IsTest
    static void correctGeolocation() {
        Account account = new Account(Name='Test', BillingCity='Barcelona', BillingCountry='ES', BillingLatitude=25.12, BillingLongitude=-25.12);
        insert account;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OpenWeatherMockResponse());
        CurrentWeatherBatch batch = new CurrentWeatherBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        Account accountToTest = [SELECT Id, Name, BillingCity, BillingCountry,BillingLongitude, BillingLatitude, AccountCurrentWeather__c FROM Account LIMIT 1];
        System.assertEquals('light rain', accountToTest.AccountCurrentWeather__c);
    }    

    @IsTest
    static void incorrectGeolocation() {
        Account account = new Account(Name='Test', BillingCity='Barcelona', BillingCountry='ES');
        insert account;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OpenWeatherMockResponse());
        CurrentWeatherBatch batch = new CurrentWeatherBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        Account accountToTest = [SELECT Id, Name, BillingCity, BillingCountry,BillingLongitude, BillingLatitude, AccountCurrentWeather__c FROM Account LIMIT 1];
        System.assertEquals('Could not get geolocation values on this billing address', accountToTest.AccountCurrentWeather__c);
    }  

    @IsTest
    static void testBulk() {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 100; i++) {
            accounts.add(new Account(Name='Test ' + i, BillingCity='Barcelona', BillingCountry='ES', BillingLatitude=25.12, BillingLongitude=-25.12));
        }
        insert accounts;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OpenWeatherMockResponse());
        CurrentWeatherBatch batch = new CurrentWeatherBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        List<Account> accountsToTest = [SELECT Id, Name, AccountCurrentWeather__c FROM Account WHERE AccountCurrentWeather__c='light rain'];
        System.assertEquals(100, accountsToTest.size());
    }
}