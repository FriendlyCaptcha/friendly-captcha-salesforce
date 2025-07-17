/**
 * VerifyResult is a wrapper around the response of an
 * /api/v2/captcha/siteverify request.
 * 
 * The main methods are `shouldAccept` and `wasAbleToVerify`.
 * The first one you should use to determine if the user's request should be accepted;
 * the second one to determine if the request was able to be verified.
 * If that returns false, you should alert yourself.
 */
global class VerifyResult {
    /** Whether the request was made in strict mode. */
    private Boolean strict;

    /** The HTTP status code of the response. */
    private Integer status;

    /** The response body. */
    private VerifyResponse response;

    /** The exception that was thrown, if any. */
    private Exception exc;

    /**
     * `null` if the puzzle could be verified, in other words we got a 200 response.
     * 
     * Otherwise this will be set to one of the error codes in `ErrorCodes`:
     * * `ErrorCodes.REQUEST_FAILED`
     * * `ErrorCodes.FAILED_DUE_TO_CLIENT_ERROR` (see response.error for more
     * details, your API key might be wrong).
     * * `ErrorCodes.FAILED_TO_ENCODE_REQUEST`
     * * `ErrorCodes.FAILED_TO_DECODE_RESPONSE`
     */
    private String errorCode = null;

    /**  If available, details about errors encountered during verification. */
    private String errorDetail = null;

    public VerifyResult(Boolean strict) {
        this.strict = strict;
    }

    /**
     * @return whether the `strict` option was set to true on the client. In
     *         `strict` mode this will only return `true`
     *         if the request was successful (e.g. verification could happen), and
     *         the challenge was solved successfully.
     * 
     *         By default, `strict` is set to `false`, which means that the request
     *         will be accepted if the challenge could
     *         not be verified (also called *fail open*).
     */
    global Boolean isStrict() {
        return strict;
    }

    /**
     * Determines if the user's request should be accepted.
     * 
     * @return true if the request should be accepted, false otherwise.
     */
    global Boolean shouldAccept() {
        if (wasAbleToVerify()) {
            if (isEncodeError()) {
                return false;
            }
            return response.isSuccess();
        }
        if (errorCode != null) {
            if (strict) {
                return false;
            }
            if (
                errorCode.equals(ErrorCodes.REQUEST_FAILED) ||
                errorCode.equals(ErrorCodes.FAILED_DUE_TO_CLIENT_ERROR) ||
                errorCode.equals(ErrorCodes.FAILED_TO_DECODE_RESPONSE)
            ) {
                return true;
            }
            return false;
        }

        throw new NullErrorException(
                'Implementation error in friendly-captcha-salesforce shouldAccept: error should never be null if success is false. '
                        + this);
    }

    /**
     * Determines if the user's request should be rejected.
     * 
     * @return true if the request should be rejected, false otherwise.
     */
    global Boolean shouldReject() {
        return !shouldAccept();
    }

    /**
     * Was unable to encode the captcha response. This means the captcha response
     * was invalid and should never be accepted.
     * 
     * @return true if there was an encoding error, false otherwise.
     */
    global Boolean isEncodeError() {
        return errorCode == ErrorCodes.FAILED_TO_ENCODE_REQUEST;
    }

    /**
     * Something went wrong making the request to the Friendly Captcha API, perhaps
     * there is a network connection issue?
     * 
     * @return true if there was a request error, false otherwise.
     */
    global Boolean isRequestError() {
        return errorCode == ErrorCodes.REQUEST_FAILED;
    }

    /**
     * Something went wrong decoding the response from the Friendly Captcha API.
     * 
     * @return true if there was a decoding error, false otherwise.
     */
    global Boolean isDecodeError() {
        return errorCode == ErrorCodes.FAILED_TO_DECODE_RESPONSE;
    }

    /**
     * Something went wrong on the client side, this generally means your
     * configuration is wrong.
     * Check your secrets (API key) and sitekey.
     * 
     * See `response.error` for more details.
     * 
     * @return true if there was a client error, false otherwise.
     */
    global Boolean isClientError() {
        return errorCode == ErrorCodes.FAILED_DUE_TO_CLIENT_ERROR;
    }

    /**
     * Get the response as was sent from the server.
     * This can be null if the request to the API could not be made successfully.
     * 
     * @return the response from the server, or null if the request failed.
     */
    global VerifyResponse getResponse() {
        return response;
    }

    /**
     * Get the error code.
     * 
     * @return the error code, or null if not present.
     */
    global String getErrorCode() {
        return errorCode;
    }

    /**
     * Get the error detail.
     * 
     * @return the error detail, or null if not present.
     */
    global String getErrorDetail() {
        return errorDetail;
    }

    /**
     * Set the error code.
     * 
     * @param errorCode the error code to set.
     */
    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    /**
     * Set the error detail.
     * 
     * @param errorDetail the error detail to set.
     */
    public void setErrorDetail(String errorDetail) {
        this.errorDetail = errorDetail;
    }

    /**
     * Set the HTTP status code of the response.
     * 
     * @param status the status code to set.
     */
    public void setStatus(Integer status) {
        this.status = status;
    }

    /**
     * Set the response body.
     * 
     * @param response the response to set.
     */
    public void setResponse(VerifyResponse response) {
        this.response = response;
    }

    /**
     * Whether the request to verify the captcha was completed. In other words: the
     * API responded with status 200.
     * If this is false, you should notify yourself and check `getErrorCode()` to see
     * what is wrong.
     * 
     * @return true if the request was able to be verified, false otherwise.
     */
    global Boolean wasAbleToVerify() {
        if (isEncodeError()) {
            // Despite not being able to make the request, if we are not even able to encode
            // the captcha response
            // we can be certain it's invalid and were thus able to verify it without even
            // making a request.
            return true;
        }
        return status == 200 && !isRequestError() && !isDecodeError();
    }

    /**
     * Get the exception that was thrown, if any.
     * 
     * @return the exception, or null if none was thrown.
     */
    global Exception getException() {
        return exc;
    }

    /**
     * Set the exception that was thrown, if any.
     * 
     * @param exception the exception to set.
     */
    public void setException(Exception exc) {
        this.exc = exc;
    }

    global class NullErrorException extends Exception {}
}
