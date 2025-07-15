@IsTest
private class ClientTest {
    @IsTest
    static void testClient() {
        StaticResource sr = [SELECT Body FROM StaticResource WHERE Name = 'test_cases' LIMIT 1];
        String jsonString = sr.Body.toString();
        TestFixtures fixtures = TestFixtures.fromJSON(jsonString);
        System.assertEquals(1, fixtures.version);

        Test.setMock(HttpCalloutMock.class, new TestServerMock(fixtures));

        for (TestFixtures.TestCase testCase : fixtures.tests) {
            Options opts = new Options().strict(testCase.strict).apiKey('api-key');
            VerifyResult result = Client.verifyCaptchaResponse(testCase.response, opts);
            String msg = testCase.name + ' | ' + result.toString();
            System.assertEquals(testCase.expectation.shouldAccept, result.shouldAccept(), msg);
            System.assertEquals(testCase.expectation.wasAbleToVerify, result.wasAbleToVerify(), msg);
            System.assertEquals(testCase.expectation.isClientError, result.isClientError(), msg);
        }
    }
}
