/**
 * Represents the data structure returned in the siteverify response
 * from the Friendly Captcha API.
 * 
 * For more information, see [the API response documentation](/docs/v2/api/siteverify#response).
 */
global class VerifyResponse {
    global Boolean success;
    global Data data;
    global Error error;

    global Boolean isSuccess() {
        return success;
    }

    global class Data {
        global Challenge challenge;
    }

    global class Challenge {
        global String timestamp;
        global String origin;
    }

    global class Error {
        global String error_code;
        global String detail;
    }

    public static VerifyResponse fromJSON(String jsonString) {
        return (VerifyResponse) JSON.deserialize(jsonString, VerifyResponse.class);
    }
}
