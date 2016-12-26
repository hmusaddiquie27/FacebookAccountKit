package org.apache.cordova.FacebookAccountKit;

import android.content.Intent;
import com.facebook.accountkit.AccessToken;
import com.facebook.accountkit.AccountKit;
import com.facebook.accountkit.AccountKitCallback;
import com.facebook.accountkit.AccountKitError;
import com.facebook.accountkit.AccountKitLoginResult;
import com.facebook.accountkit.ui.AccountKitActivity;
import com.facebook.accountkit.ui.AccountKitConfiguration;
import com.facebook.accountkit.ui.LoginType;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class FacebookAccountKitLogin extends CordovaPlugin {
    
    public static int APP_REQUEST_CODE = 99;
    private CallbackContext cbContext = null;
    
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        
        AccessToken accessToken = AccountKit.getCurrentAccessToken();
        
        if (accessToken != null) {
            //Handle Returning User
            AccountKit.logOut();
        } else {
            //Handle new or logged out user
        }
        
        if (action.equals("mobileLogin")) {
            this.login(LoginType.PHONE, callbackContext);
            return true;
        } else if (action.equals("emailLogin")) {
            this.login(LoginType.EMAIL, callbackContext);
            return true;
        }
        
        return false;
    }
    
    public void login(LoginType loginType, CallbackContext callbackContext) {
        cbContext = callbackContext;
        PluginResult pluginResult = new PluginResult(PluginResult.Status.NO_RESULT);
        pluginResult.setKeepCallback(true); // Keep callback
        callbackContext.sendPluginResult(pluginResult);
        
        final Intent intent = new Intent(cordova.getActivity(), AccountKitActivity.class);
        AccountKitConfiguration.AccountKitConfigurationBuilder configurationBuilder = new AccountKitConfiguration.AccountKitConfigurationBuilder(loginType, AccountKitActivity.ResponseType.TOKEN); // or .ResponseType.TOKEN
        // ... perform additional configuration ...
        intent.putExtra(AccountKitActivity.ACCOUNT_KIT_ACTIVITY_CONFIGURATION, configurationBuilder.build());
        cordova.setActivityResultCallback(this);
        cordova.startActivityForResult(this, intent, APP_REQUEST_CODE);
    }
    
    @Override
    public void onActivityResult(final int requestCode, final int resultCode, final Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (data != null) {
            if (requestCode == APP_REQUEST_CODE) { // confirm that this response matches your request
                final AccountKitLoginResult loginResult = data.getParcelableExtra(AccountKitLoginResult.RESULT_KEY);
                String toastMessage;
                if (loginResult.getError() != null) {
                    toastMessage = loginResult.getError().getErrorType().getMessage();
                    //Failure!
                    PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, "error hai");
                    pluginResult.setKeepCallback(true);
                    cbContext.sendPluginResult(pluginResult);
                } else if (loginResult.wasCancelled()) {
                    toastMessage = "Login Cancelled";
                    PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, toastMessage);
                    pluginResult.setKeepCallback(true);
                    cbContext.sendPluginResult(pluginResult);
                } else {
                    // Success! Start your next activity...
                    getAccountDetails(loginResult);
                }
            }
        }
    }
    
    public void getAccountDetails(final AccountKitLoginResult loginResult) {
        AccountKit.getCurrentAccount(new AccountKitCallback<com.facebook.accountkit.Account>() {
            @Override
            public void onSuccess(com.facebook.accountkit.Account account) {
                
                try {
                    JSONObject result = new JSONObject();
                    result.put("accessToken", loginResult.getAccessToken().getToken());
                    result.put("provider", "accountkit");
                    result.put("id", loginResult.getAccessToken().getAccountId());
                    
                    if (account.getEmail() != null) {
                        result.put("email", account.getEmail());
                    } else if (account.getPhoneNumber() != null) {
                        result.put("mobile", account.getPhoneNumber().toString());
                    }
                    
                    PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, result);
                    pluginResult.setKeepCallback(true);
                    cbContext.sendPluginResult(pluginResult);
                    
                } catch (JSONException e) {
                    PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, "unexpected JSON exception");
                    pluginResult.setKeepCallback(true);
                    cbContext.sendPluginResult(pluginResult);
                }
            }
            
            @Override
            public void onError(AccountKitError accountKitError) {
                try {
                    JSONObject result = new JSONObject();
                    result.put("accessToken", loginResult.getAccessToken().getToken());
                    result.put("provider", "accountkit");
                    result.put("id", loginResult.getAccessToken().getAccountId());
                    result.put("error", "unable to get email or phone number");
                    
                    PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, result);
                    pluginResult.setKeepCallback(true);
                    cbContext.sendPluginResult(pluginResult);
                } catch (JSONException e) {
                    PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, "unexpected JSON exception");
                    pluginResult.setKeepCallback(true);
                    cbContext.sendPluginResult(pluginResult);
                }
            }
        });
    }
}
