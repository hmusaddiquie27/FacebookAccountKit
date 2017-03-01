var exec = require('cordova/exec')

exports.mobileLoginWithTheme = function login (s, f, t) {
    exec(s, f, 'FacebookAccountKitLogin', 'mobileLogin', [t])
}

exports.emailLoginWithTheme = function login (s, f, t) {
    exec(s, f, 'FacebookAccountKitLogin', 'emailLogin', [t])
}

exports.mobileLogin = function login (s, f) {
    exec(s, f, 'FacebookAccountKitLogin', 'mobileLogin', [])
}

exports.emailLogin = function login (s, f) {
    exec(s, f, 'FacebookAccountKitLogin', 'emailLogin', [])
}
