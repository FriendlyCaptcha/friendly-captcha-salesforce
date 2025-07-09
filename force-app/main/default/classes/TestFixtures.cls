@IsTest
public class TestFixtures {
    public Integer version;
    public List<TestCase> tests;

    public class Expectation {
        public Boolean shouldAccept;
        public Boolean wasAbleToVerify;
        public Boolean isClientError;
    }

    public class TestCase {
        public String name;
        public String response;
        public Boolean strict;
        public String siteverifyResponse;
        public Integer siteverifyStatusCode;
        public Expectation expectation;
    }

    public static TestFixtures fromJSON(String jsonString) {
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

        TestFixtures fixtures = new TestFixtures();
        fixtures.version = (Integer) jsonMap.get('version');
        fixtures.tests = new List<TestCase>();

        List<Object> testsArray = (List<Object>) jsonMap.get('tests');
        for (Object testObj : testsArray) {
            Map<String, Object> testMap = (Map<String, Object>) testObj;
            TestCase testCase = new TestCase();

            testCase.name = (String) testMap.get('name');
            testCase.response = (String) testMap.get('response');
            testCase.strict = (Boolean) testMap.get('strict');
            testCase.siteverifyStatusCode = (Integer) testMap.get('siteverify_status_code');

            Object siteverifyResponse = testMap.get('siteverify_response');
            if (siteverifyResponse instanceof String) {
                testCase.siteverifyResponse = (String) siteverifyResponse;
            } else {
                testCase.siteverifyResponse = JSON.serialize(siteverifyResponse);
            }

            Map<String, Object> expectationMap = (Map<String, Object>) testMap.get('expectation');
            Expectation expectation = new Expectation();
            expectation.shouldAccept = (Boolean) expectationMap.get('should_accept');
            expectation.wasAbleToVerify = (Boolean) expectationMap.get('was_able_to_verify');
            expectation.isClientError = (Boolean) expectationMap.get('is_client_error');
            testCase.expectation = expectation;

            fixtures.tests.add(testCase);
        }

        return fixtures;
    }
}
