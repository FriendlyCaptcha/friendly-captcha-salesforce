public class Options {
    private String sitekey;
    private String apiKey;
    private String apiEndpoint = 'global';
    private Boolean strict = false;
    private Integer timeout = 20000;

    public String sitekey() {
        return sitekey;
    }

    public Options sitekey(String sitekey) {
        this.sitekey = sitekey;
        return this;
    }

    public String apiKey() {
        return apiKey;
    }

    public Options apiKey(String apiKey) {
        this.apiKey = apiKey;
        return this;
    }

    public String apiEndpoint() {
        return apiEndpoint;
    }

    public Options apiEndpoint(String apiEndpoint) {
        this.apiEndpoint = apiEndpoint;
        return this;
    }

    public Boolean strict() {
        return strict;
    }

    public Options strict(Boolean strict) {
        this.strict = strict;
        return this;
    }

    public Integer timeout() {
        return timeout;
    }

    public Options timeout(Integer timeout) {
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

    public class InvalidOptionsException extends Exception {}
}
