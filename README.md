# cordova-plugin-facebook-account-kit

> Use Facebook Account Kit in Cordova projects only in iOS for now

## Installation

See npm package for versions - https://github.com/Mhusain/FacebookAccountKit

Make sure you've registered your Facebook app with Facebook and have an `APP_ID` [https://developers.facebook.com/apps](https://developers.facebook.com/apps).

```bash
$ cordova plugin add cordova-plugin-facebook-account-kit --save --variable APP_ID="123456789" --variable APP_NAME="myApplication" --variable AK_TOKEN="AccountKitClientToken"
```

If you need to change your `APP_ID`, `APP_NAME`, or `AK_TOKEN` after installation, it's recommended that you remove and then re-add the plugin as above. Note that changes to the `APP_ID`, `APP_NAME`, or `AK_TOKEN` value in your `config.xml` file will *not* be propagated to the individual platform builds.

## Usage

### Email Login

`FacebookAccountKit.emailLogin(function (response) { console.log(response) }, function (error) { console.log(error) });`

Success function will response like:

{
accessToken: "<long string>",
provider: "<string>",
id: "<string>",
email: "<email>"
}

### Mobile Login

`FacebookAccountKit.mobileLogin(function (response) { console.log(response) }, function (error) { console.log(error) });`

Success function will response like:

{
accessToken: "<long string>",
provider: "<string>",
id: "<string>",
mobile: "<mobile>"
}

