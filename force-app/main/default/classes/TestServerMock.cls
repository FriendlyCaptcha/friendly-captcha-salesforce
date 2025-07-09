@IsTest
public class TestServerMock implements HttpCalloutMock {
    private Map<String, TestFixtures.TestCase> responseToCase;

    public TestServerMock(TestFixtures fixtures) {
        this.responseToCase = new Map<String, TestFixtures.TestCase>();
        for (TestFixtures.TestCase testCase : fixtures.tests) {
            this.responseToCase.put(testCase.response, testCase);
        }
    }

    public HttpResponse respond(HttpRequest req) {
        HttpResponse resp = new HttpResponse();

        String apiKey = req.getHeader('X-Api-Key');
        if (String.isEmpty(apiKey)) {
            System.debug('Missing X-Api-Key header');
            resp.setStatusCode(400);
            resp.setBody('Missing X-Api-Key header');
            return resp;
        }

        String contentType = req.getHeader('Content-Type');
        if (contentType != 'application/json') {
            System.debug('Invalid Content-Type header: ' + contentType);
            resp.setStatusCode(400);
            resp.setBody('Invalid Content-Type header: ' + contentType);
            return resp;
        }

        String frcSdk = req.getHeader('Frc-Sdk');
        if (String.isEmpty(frcSdk)) {
            System.debug('Missing Frc-Sdk header');
            resp.setStatusCode(400);
            resp.setBody('Missing Frc-Sdk header');
            return resp;
        }

        String rawBody = req.getBody();
        Map<String,String> body;
        try {
            body = (Map<String,String>) JSON.deserialize(rawBody, Map<String,String>.class);
        } catch (JSONException exc) {
            resp.setStatusCode(400);
            resp.setBody('Failed to decode request: ' + exc.getMessage());
            return resp;
        }

        String response = body.get('response');
        if (String.isEmpty(response)) {
            System.debug('Missing `response` parameter in request body');
            resp.setStatusCode(400);
            resp.setBody('Missing `response` parameter in request body');
            return resp;
        }

        TestFixtures.TestCase testCase = responseToCase.get(response);
        if (testCase == null) {
            System.debug('No test case found for response: ' + response);
            resp.setStatusCode(400);
            resp.setBody('No test case found for response: ' + response);
            return resp;
        }

        resp.setHeader('Content-Type', 'application/json');
        resp.setStatusCode(testCase.siteverifyStatusCode);
        resp.setBody(testCase.siteverifyResponse);
        return resp;
    }
}
