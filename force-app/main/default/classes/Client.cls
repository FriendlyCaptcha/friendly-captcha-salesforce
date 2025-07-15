public class Client {
    private static final String GLOBAL_ENDPOINT = 'https://global.frcapi.com';
    private static final String EU_ENDPOINT = 'https://eu.frcapi.com';

    public static VerifyResult verifyCaptchaResponse(String response, Options opts) {
        return doRequest(response, opts);
    }

    public static VerifyResult verifyCaptchaResponse(String response) {
        Config__mdt config = Config__mdt.getInstance('Settings');
        Options opts = new Options()
            .apiEndpoint(config.APIEndpoint__c)
            .apiKey(config.APIKey__c)
            .sitekey(config.Sitekey__c)
            .strict(config.Strict__c)
            .timeout((Integer) config.Timeout__c);
        return doRequest(response, opts);
    }

    private static VerifyResult doRequest(String response, Options opts) {
        // Throws an exception if there are any invalid options.
        opts.validate();

        String apiEndpoint = opts.apiEndpoint();
        if (apiEndpoint == 'global') {
            apiEndpoint = GLOBAL_ENDPOINT;
        } else if (apiEndpoint == 'eu') {
            apiEndpoint = EU_ENDPOINT;
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint(apiEndpoint + '/api/v2/captcha/siteverify');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Frc-Sdk', Info.IDENTIFIER);
        req.setHeader('X-Api-Key', opts.apiKey());
        req.setTimeout(opts.timeout());

        VerifyResult result = new VerifyResult(opts.strict());

        try {
            req.setBody(requestBody(response, opts.sitekey()));
        } catch (JSONException e) {
            result.setException(e);
            result.setErrorCode(ErrorCodes.FAILED_TO_ENCODE_REQUEST);
            return result;
        }

        try {
            Http httpProtocol = new Http();
            HttpResponse resp = httpProtocol.send(req);
            Integer statusCode = resp.getStatusCode();
            String body = resp.getBody();

            result.setStatus(statusCode);

            if (statusCode >= 500) {
                result.setErrorCode(ErrorCodes.REQUEST_FAILED);
                result.setErrorDetail(body);
            } else if (statusCode >= 400) {
                result.setErrorCode(ErrorCodes.FAILED_DUE_TO_CLIENT_ERROR);
                result.setErrorDetail(body);
            }

            result.setResponse(VerifyResponse.fromJSON(body));
        } catch (CalloutException e) {
            result.setException(e);
            result.setErrorCode(ErrorCodes.REQUEST_FAILED);
        } catch (JSONException e) {
            result.setException(e);
            result.setErrorCode(ErrorCodes.FAILED_TO_DECODE_RESPONSE);
        }

        return result;
    }

    private static String requestBody(String response, String sitekey) {
        Map<String, String> m = new Map<String, String>();
        m.put('response', response);
        m.put('sitekey', sitekey);
        return JSON.serialize(m, true);
    }
}
