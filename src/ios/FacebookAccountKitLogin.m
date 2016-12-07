//
//  FacebookAccountKitLogin.m
//  TravelDaddy
//
//  Created by Musaddiquie Husain on 30/11/16.
//
//

#import <Cordova/CDV.h>
#import <AccountKit/AccountKit.h>

@interface FacebookAccountKitLogin : CDVPlugin <AKFViewControllerDelegate>

-(void)mobileLogin:(CDVInvokedUrlCommand*)command;

-(void)emailLogin:(CDVInvokedUrlCommand*)command;

@end

@implementation FacebookAccountKitLogin {
    AKFAccountKit *accountKit;
    UIViewController<AKFViewController> *pendingLoginViewController;
    NSString *_authorizationCode;
    CDVInvokedUrlCommand *commandGlobal;
}

-(void)mobileLogin:(CDVInvokedUrlCommand*)command
{
    commandGlobal = command;
    // initialize Account Kit
    if (accountKit == nil) {
        // may also specify AKFResponseTypeAccessToken
        accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
    }
    
    // view controller for resuming login
    pendingLoginViewController = [accountKit viewControllerForLoginResume];
    
    NSString *inputState = [[NSUUID UUID] UUIDString];
    
    UIViewController<AKFViewController> *viewController = [accountKit viewControllerForPhoneLoginWithPhoneNumber:nil state:inputState];
    
    viewController.enableSendToFacebook = YES; // defaults to NO
    
    [self prepareLoginViewController:viewController]; // see below
    
    [self.viewController presentViewController:viewController animated:YES completion:nil];
}

-(void)emailLogin:(CDVInvokedUrlCommand*)command
{
    commandGlobal = command;
    // initialize Account Kit
    if (accountKit == nil) {
        // may also specify AKFResponseTypeAccessToken
        accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAccessToken];
    }
    
    // view controller for resuming login
    pendingLoginViewController = [accountKit viewControllerForLoginResume];
    
    NSString *inputState = [[NSUUID UUID] UUIDString];
    
    UIViewController<AKFViewController> *viewController = [accountKit viewControllerForEmailLoginWithEmail:nil state:inputState];
    
    viewController.enableSendToFacebook = YES; // defaults to NO
    
    [self prepareLoginViewController:viewController]; // see below
    
    [self.viewController presentViewController:viewController animated:YES completion:nil];
}

- (void)prepareLoginViewController:(UIViewController<AKFViewController> *)loginViewController
{
    loginViewController.delegate = self;
    // Optionally, you may use the Advanced UI Manager or set a theme to customize the UI.
    //    loginViewController.advancedUIManager = _advancedUIManager;
    //    loginViewController.theme = [Themes bicycleTheme];
}

#pragma mark - AKFViewControllerDelegate;

- (void)viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAccessToken:(id<AKFAccessToken>)accessToken state:(NSString *)state {
    [accountKit requestAccount:^(id<AKFAccount> account, NSError *error) {
        if (error) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:commandGlobal.callbackId];
        }
        else{
            NSString *keyName;
            NSString *keyValue;
            NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
            
            [info setValue:account.accountID forKey:@"id"];
            if ([account.emailAddress length] > 0) {
                [info setValue:account.emailAddress forKey:@"email"];
                keyName = @"email";
                keyValue = account.emailAddress;
            }
            else if ([account phoneNumber] != nil) {
                [info setValue:[NSString stringWithFormat:@"%@@accountkit.com", account.accountID] forKey:@"email"];
                [info setValue:[[account phoneNumber] stringRepresentation] forKey:@"mobile"];
                keyName = @"mobile";
                keyValue = [[account phoneNumber] stringRepresentation];
            }
            [info setValue:@"accountkit" forKey:@"provider"];
            [info setValue:accessToken.tokenString forKey:@"accessToken"];
            
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:commandGlobal.callbackId];
            
        }
    }];
}

- (void)viewController:(UIViewController<AKFViewController> *)viewController didFailWithError:(NSError *)error {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandGlobal.callbackId];
}

@end
