global with sharing class ScheduleWeatherBatch implements Schedulable {
    global void execute(SchedulableContext sc) {
        CurrentWeatherBatch weatherBatch = new CurrentWeatherBatch(); 
        database.executebatch(weatherBatch, 100);
     }
}