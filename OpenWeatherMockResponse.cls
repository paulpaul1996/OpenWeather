public with sharing class OpenWeatherMockResponse implements HttpCalloutMock {
    
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
    
        response.setStatusCode(200);
        response.setBody('{"current" : { "weather" : [{"id":500, "main":"Rain", "description":"light rain", "icon":"10d"}]}}');
        return response;
    }
        
}