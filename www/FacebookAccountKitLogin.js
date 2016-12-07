var exec = require('cordova/exec')
exports.mobileLogin = function mobileLogin (s, f) {
    exec(s, f, 'FacebookAccountKitLogin', 'mobileLogin', [])
}

exports.emailLogin = function mobileLogin (s, f) {
    exec(s, f, 'FacebookAccountKitLogin', 'emailLogin', [])
}
