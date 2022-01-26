# OpenWeather

The lwc component is added at the top of the Account Record Detail Page.  
The batch scheduling has been run using the following code :  
   // Cron EXP for hourly schedule  
   String CRON_EXP = '0 0 * * * ?';  
   ScheduleWeatherBatch sch = new ScheduleWeatherBatch();  
   system.schedule('Hourly Example Batch Schedule job', CRON_EXP, sch);  
  
