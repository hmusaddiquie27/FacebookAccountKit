# cordova-plugin-facebook-account-kit

> Use Facebook Account Kit Login in Apache Cordova projects in iOS & Android

## Command

cordova plugin add cordova-plugin-facebook-account-kit --save --variable APP_ID="123456789" --variable  APP_NAME="TestApp" --variable AK_TOKEN="XYZ123"

## Installation

See npm package for versions - https://github.com/Mhusain/FacebookAccountKit

Make sure you've registered your Facebook app with Facebook and have an `APP_ID` on [https://developers.facebook.com/apps](https://developers.facebook.com/apps) and `AccountKitClientToken` on [https://developers.facebook.com/apps/<APP_ID>/account-kit/](https://developers.facebook.com/apps/<APP_ID>/account-kit/).

```bash
$ cordova plugin add cordova-plugin-facebook-account-kit --save --variable APP_ID="123456789" --variable APP_NAME="myApplication" --variable AK_TOKEN="AccountKitClientToken"
```

If you need to change your `APP_ID`, `APP_NAME`, or `AK_TOKEN` after installation, it's recommended that you remove and then re-add the plugin as above. Note that changes to the `APP_ID`, `APP_NAME`, or `AK_TOKEN` value in your `config.xml` file will *not* be propagated to the individual platform builds.

## Android (One more steps to add)

`Open class MainActivity.java`

`Import Facebook Account Kit package`

`import com.facebook.accountkit.AccountKit;`

`Add below line of code to initialize Facebook Account Kit`

`@Override`
`public void onCreate(Bundle savedInstanceState)`
`{`
    `super.onCreate(savedInstanceState);`
    `//Account Kit initialization`
    `AccountKit.initialize(getApplicationContext());`
`}`

## Usage

### Email Login

`FacebookAccountKit.emailLogin(function (response) { alert(JSON.stringify(response)); }, function (error) { console.log(error) });`

Success function will response like:

{
accessToken: "<long string>",
provider: "<string>",
id: "<string>",
email: "<email>"
}

### Mobile Login

`FacebookAccountKit.mobileLogin(function (response) { alert(JSON.stringify(response)); }, function (error) { console.log(error) });`

Success function will response like:

{
accessToken: "<long string>",
provider: "<string>",
id: "<string>",
mobile: "<mobile>"
}

