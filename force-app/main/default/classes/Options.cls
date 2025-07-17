global class Options {
    private String sitekey;
    private String apiKey;
    private String apiEndpoint = 'global';
    private Boolean strict = false;
    private Integer timeout = 20000;

    global String sitekey() {
        return sitekey;
    }

    global Options sitekey(String sitekey) {
        this.sitekey = sitekey;
        return this;
    }

    global String apiKey() {
        return apiKey;
    }

    global Options apiKey(String apiKey) {
        this.apiKey = apiKey;
        return this;
    }

    global String apiEndpoint() {
        return apiEndpoint;
    }

    global Options apiEndpoint(String apiEndpoint) {
        this.apiEndpoint = apiEndpoint;
        return this;
    }

    global Boolean strict() {
        return strict;
    }

    global Options strict(Boolean strict) {
        this.strict = strict;
        return this;
    }

    global Integer timeout() {
        return timeout;
    }

    global Options timeout(Integer timeout) {
        this.timeout = timeout;
        return this;
    }

    public void validate() {
        if (String.isEmpty(apiKey)) {
            throw new InvalidOptionsException('apiKey is required');
        }

        if (timeout <= 0) {
            throw new InvalidOptionsException('timeout must be a positive integer');
        }

        if (apiEndpoint != 'global' && apiEndpoint != 'eu') {
            try {
                new URL(apiEndpoint);
            } catch (StringException exc) {
                throw new InvalidOptionsException('apiEndpoint must be "global", "eu", or a valid URL: ' + exc);
            }
        }
    }

    global class InvalidOptionsException extends Exception {}
}
