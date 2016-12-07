# cordova-plugin-facebook-account-kit

> Use Facebook Facebook Account Kit in Cordova projects only in iOS for now

## Installation

See npm package for versions - https://github.com/Mhusain/FacebookAccountKit

Make sure you've registered your Facebook app with Facebook and have an `APP_ID` [https://developers.facebook.com/apps](https://developers.facebook.com/apps).

```bash
$ cordova plugin add cordova-plugin-facebook-account-kit --save --variable APP_ID="123456789" --variable APP_NAME="myApplication" --variable AK_TOKEN="AccountKitClientToken"
```

If you need to change your `APP_ID` after installation, it's recommended that you remove and then re-add the plugin as above. Note that changes to the `APP_ID` value in your `config.xml` file will *not* be propagated to the individual platform builds.
