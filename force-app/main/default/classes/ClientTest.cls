@IsTest
private class ClientTest {
    @IsTest
    static void testClient() {
        StaticResource sr = [SELECT Body FROM StaticResource WHERE Name = 'test_cases' LIMIT 1];
        String jsonString = sr.Body.toString();
        TestFixtures fixtures = TestFixtures.fromJSON(jsonString);
        Assert.areEqual(1, fixtures.version);

        Test.setMock(HttpCalloutMock.class, new TestServerMock(fixtures));

        for (TestFixtures.TestCase testCase : fixtures.tests) {
            Options opts = new Options().strict(testCase.strict).apiKey('api-key');
            VerifyResult result = Client.verifyCaptchaResponse(testCase.response, opts);
            String msg = testCase.name + ' | ' + result.toString();
            Assert.areEqual(testCase.expectation.shouldAccept, result.shouldAccept(), msg);
            Assert.areEqual(testCase.expectation.wasAbleToVerify, result.wasAbleToVerify(), msg);
            Assert.areEqual(testCase.expectation.isClientError, result.isClientError(), msg);
        }
    }

    @IsTest
    static void testVerifyResult() {
        VerifyResult result = new VerifyResult(true);
        Assert.isTrue(result.isStrict(), 'failed: result.isStrict()');

        result.setErrorCode(ErrorCodes.FAILED_TO_ENCODE_REQUEST);
        Assert.isFalse(result.shouldAccept(), 'failed: result.shouldAccept(): FAILED_TO_ENCODE_REQUEST');
        Assert.isTrue(result.shouldReject(), 'failed: result.shouldReject()');

        result = new VerifyResult(false);
        result.setStatus(500);
        try {
            result.shouldAccept();
            Assert.fail('failed: result.shouldAccept() should have thrown');
        } catch (Exception exc) {}
    }

    @IsTest
    static void testOptions() {
        Options opts = new Options()
            .sitekey('FC0123456789ABCD')
            .apiKey('shhhh')
            .apiEndpoint('eu')
            .strict(true)
            .timeout(5000);

        Assert.areEqual('FC0123456789ABCD', opts.sitekey());
        Assert.areEqual('shhhh', opts.apiKey());
        Assert.areEqual('eu', opts.apiEndpoint());
        Assert.areEqual(true, opts.strict());
        Assert.areEqual(5000, opts.timeout());

        try {
            opts.validate();
        } catch (Exception exc) {
            Assert.fail('Unexpected InvalidOptionsException: ' + exc);
        }

        opts.apiKey('');
        try {
            opts.validate();
            Assert.fail('opts.validate() should have thrown for missing apiKey');
        } catch (Exception exc) {}
        opts.apiKey('shhhh');

        opts.timeout(-1000);
        try {
            opts.validate();
            Assert.fail('opts.validate() should have thrown for invalid timeout');
        } catch (Exception exc) {}
        opts.timeout(5000);

        opts.apiEndpoint('not a url');
        try {
            opts.validate();
            Assert.fail('opts.validate() should have thrown for invalid apiEndpoint');
        } catch (Exception exc) {}
    }
}
