# Friendly Captcha for Salesforce

This project contains the source code for the Salesforce integration for Friendly Captcha. Much (all?) of this repository was generated using the `sf` command line tool. You can install it [from their website][sf-website] or [from npm][sf-npm].

You can also run it as a Docker container, which I've started doing recently.

```
docker run --rm -it -v $PWD:/app -w /app salesforce/cli:latest-full
```

That will drop you into a shell with the `sf` command installed.

## Map of the repository

All source is located in `force-app/main/default`.

```
force-app
└── main
    └── default
        ├── classes
        │   └──> Apex classes
        ├── cspTrustedSites
        │   └──> Stored CSP configuration
        ├── customMetadata
        │   └──> Records (aka instances of) a Custom Metadata Type (CMDT)
        ├── layouts
        │   └──> XML markup for a CMDT record page.
        ├── lwc
        │   └──> Lightning web components
        ├── objects
        │   └──> Custom metadata types (CMDTs)
        ├── remoteSiteSettings
        │   └──> Store trusted site settings for HTTP requests (to siteverify API)
        └── staticresources
            └──> Static files, including test fixtures and also the front-end SDK.
```

Everything in `cspTrustedSites`, `customMetadata`, `layouts`, `objects`, and `remoteSiteSettings` should _pretty much_ never need to change.

The three main components of this project are the Apex classes, the LWC, and the Custom Metadata Type (CMDT).

### Apex Classes

Located in `force-app/main/default/classes`. This code makes up the back-end code for the integration, and handles performing the siteverify request and parsing the response.

### LWC

Located in `force-app/main/default/lwc`. This is a front-end component that wraps and manages a Friendly Captcha Widget. It's meant to be used in Salesforce UIs that support LWCs.

### CMDT

The CMDT is basically a data type that stores the configuration parameters for the integration. For this project, those parameters are `sitekey`, `apiEndpoint`, `apiKey`, `strict`, `timeout`, `startMode`, `theme`, and `language`. The code for it is split across the `customMetadata`, `layouts`, and `objects` directories. In short, `objects` contains the definition of the CMDT (named `Config__mdt`), `customMetadata` contains a _record_ of that object with some default values, and `layouts` defines a page for managing instances of the CMDT within the Salesforce Setup UI.

## Development Workflow

Salesforce development doesn't really happen locally; everything happens within Salesforce orgs. You make changes to your code and then deploy it to an ephemeral "Scratch" org, where you can interact with it or run tests. To create scratch orgs, you have to first log into a Dev Hub org.

### CLI Authentication

You log into the Dev Hub org via

```
sf org login web --set-default-dev-hub
```

This will open a web browser where you log in with your Salesforce Dev Hub credentials. Upon successful authentication, you'll see a success message, and your command line session should be authenticated.

If you're in the Docker container, you probably will want to use

```
sf org login device --set-default-dev-hub
```

If everything is successful, you'll see your org in the output when you run `sf org list`.

### Create a scratch org and deploy the code

Use the following command to create a scratch org to develop against.

```
sf org create scratch --alias MyScratch --definition-file config/project-scratch-def.json
```

When it's done, you'll see it in the output of `sf org list`. You can then deploy your code to the scratch org:

```
sf project deploy start --target-org MyScratch
```

You'll see a bunch of resources get created in the output. Now your code is the org, and you can open the org and start exploring and testing.

```
sf org open --target-org MyScratch
```

If in Docker,

```
sf org open --target-org MyScratch --url-only
```

Then copy and paste the URL into your browser.

### Running the tests

This command runs the Apex tests synchronously and outputs the results upon completion:

```
sf apex run test --target-org MyScratch --synchronous
```

You can add the `--code-coverage` flag (optionally with `--detailed-coverage`) to generate a basic code coverage report.

### Deleting a scratch org

```
sf org delete scratch --target-org MyScratch
```

## Typical development tasks

If you want to change the site verification behavior, you'll make changes to the Apex classes. To change the behavior of the widget, you can update the LWC.

### Upgrading the SDK version

The SDK ships bundled as a Static Resource (in `force-app/main/default/staticresources`). To update it, copy the desired version of `site.compat.min.js` into `force-app/main/default/staticresources/FriendlyCaptchaSDK.js`.

## Generating Apex Documentation

Documentation for the Apex classes is generated using [`@cparra/apexdocs`][apexdocs]. You can run the following command to generate docs in to the `docs/` folder.

```
rm -rf docs
npm run docs
```

You can then copy the contents of the folder to [friendly-docs][friendly-docs]:

```
rm -rf /path/to/friendly-docs/src/pages/integrations/salesforce/reference
cp -R docs /path/to/friendly-docs/src/pages/integrations/salesforce/reference
```

## License

This is free software; you can redistribute it and/or modify it under the terms of the [Mozilla Public License Version 2.0](./LICENSE).

[sf-website]: https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm
[sf-npm]: https://www.npmjs.com/package/@salesforce/cli
[apexdocs]: https://github.com/cesarParra/apexdocs
[friendly-docs]: https://github.com/FriendlyCaptcha/friendly-docs
