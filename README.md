# cordova-plugin-facebook-account-kit

> Use Facebook Account Kit Login in Apache Cordova projects in iOS & Android. Now with background colors customization also available.

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


## Colors customizations

### iOS

`Change colors according to your requirements in js.`

`var theme = new Object();`
`theme.backgroundColor = "f8e8db"`
`theme.buttonBackgroundColor = "d4c0c8"`
`theme.buttonBorderColor = "1877a5"`
`theme.buttonTextColor = "ffffff"`
`theme.headerBackgroundColor = "ddadc0"`
`theme.headerTextColor = "ffffff"`
`theme.inputBackgroundColor = "def3ee"`
`theme.inputBorderColor = "a4a4d0"`
`theme.inputTextColor = "ff7373"`
`theme.textColor = "c25975"`
`theme.titleColor = "9e596e"`

`FacebookAccountKit.mobileLoginWithTheme( function (response) { alert(JSON.stringify(response)); }, function (error) { console.log(error) }, theme );`

### Android

`Plugin have defualt values now but you can change colors according to your requirements in /android/res/values/FacebookAccountKitLogin.xml file or comment all '<item> tags to achieve default theme of account kit'`

`File :: res/values/FacebookAccountKitLogin.xml`

`<style name="AccountKitLoginTheme" parent="Theme.AccountKit">`
`<item name="com_accountkit_background_color">#EEF6FF</item>`
`<item name="com_accountkit_button_background_color">#96BDEB</item>`
`<item name="com_accountkit_button_disabled_background_color">#96BDEB</item>`
`<item name="com_accountkit_button_border_color">#96BDEB</item>`
`<item name="com_accountkit_button_text_color">#ffffff</item>`
`<item name="com_accountkit_header_background_color">#96BDEB</item>`
`<item name="com_accountkit_header_text_color">#ffffff</item>`
`<item name="com_accountkit_input_background_color">#EEF6FF</item>`
`<item name="com_accountkit_input_border_color">#96BDEB</item>`
`<item name="com_accountkit_input_text_color">#da4a11</item>`
`<item name="com_accountkit_text_color">#da4a11</item>`
`<item name="com_accountkit_title_text_color">#da4a11</item>`
`</style>`

you will find above style in file res/values/FacebookAccountKitLogin.xml. Change these colors accordingly.

