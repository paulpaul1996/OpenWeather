# OpenWeather

The lwc component is added at the top of the Account Record Detail Page.  
The lwc component uses the BillingAddress for geolocation. The results will automatically be seen in the component whether a valid or invalid address has been added (depending if Salesforce finds geolocation on the BillingAddress you add).  
For the purpose of this test, i tested with simple addresses as City and Country. Again, the location might be correct, but salesforce could not set geolocation(latitude, longitude) for the address.  


The batch has been scheduled using the following code :  
  
   // Cron EXP for hourly schedule  
   String CRON_EXP = '0 0 * * * ?';  
   ScheduleWeatherBatch sch = new ScheduleWeatherBatch();  
   system.schedule('Hourly Example Batch Schedule job', CRON_EXP, sch);  
   
  
