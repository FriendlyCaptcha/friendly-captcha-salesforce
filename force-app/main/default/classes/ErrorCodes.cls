/**
 * ErrorCodes contains constants representing various error codes used in the Friendly Captcha SDK.
 */
global class ErrorCodes {
    /** (-1, internal) Failed to encode request */
    global static final String FAILED_TO_ENCODE_REQUEST = 'failed_to_encode_request';

    /** (-1, internal) Failed to talk to the Friendly Captcha API */
    global static final String REQUEST_FAILED = 'request_failed';

    /** (-1, internal) Verification failed due to a client error (check your credentials) */
    global static final String FAILED_DUE_TO_CLIENT_ERROR = 'request_failed_due_to_client_error';

    /** (-1, internal) Verification failed because we got an unexpected value from the server */
    global static final String FAILED_TO_DECODE_RESPONSE = 'verification_response_could_not_be_decoded';

    /** (401) You forgot to set the X-API-Key header */
    global static final String AUTH_REQUIRED = 'auth_required';

    /** (401) The API key you provided is invalid */
    global static final String AUTH_INVALID = 'auth_invalid';

    /** (400) The sitekey in your request is invalid */
    global static final String SITEKEY_INVALID = 'sitekey_invalid';

    /** (400) The response field is missing in your request */
    global static final String RESPONSE_MISSING = 'response_missing';

    /** (200) The response field is invalid */
    global static final String RESPONSE_INVALID = 'response_invalid';

    /** (200) The response has expired */
    global static final String RESPONSE_TIMEOUT = 'response_timeout';

    /** (200) The response has already been used */
    global static final String RESPONSE_DUPLICATE = 'response_duplicate';

    /** (400) Something else is wrong with your request, e.g. the request body was empty */
    global static final String BAD_REQUEST = 'bad_request';
}
