public class VerifyResponse {
    public Boolean success;
    public Data data;
    public Error error;

    public Boolean isSuccess() {
        return success;
    }

    public class Data {
        public Challenge challenge;
    }

    public class Challenge {
        public String timestamp;
        public String origin;
    }

    public class Error {
        public String error_code;
        public String detail;
    }

    public static VerifyResponse fromJSON(String jsonString) {
        return (VerifyResponse) JSON.deserialize(jsonString, VerifyResponse.class);
    }
}
