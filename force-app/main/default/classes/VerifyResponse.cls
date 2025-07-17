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
