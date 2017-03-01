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
    //access theme colors here
    NSDictionary *theme = command.arguments.count > 0 ? command.arguments[0] : nil;
    // view controller for resuming login
    pendingLoginViewController = [accountKit viewControllerForLoginResume];
    
    NSString *inputState = [[NSUUID UUID] UUIDString];
    
    UIViewController<AKFViewController> *viewController = [accountKit viewControllerForPhoneLoginWithPhoneNumber:nil state:inputState];
    
    viewController.enableSendToFacebook = YES; // defaults to NO
    
    [self prepareLoginViewController:viewController withTheme:theme]; // see below
    
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
    //access theme colors here
    NSDictionary *theme = command.arguments.count > 0 ? command.arguments[0] : nil;
    // view controller for resuming login
    pendingLoginViewController = [accountKit viewControllerForLoginResume];
    
    NSString *inputState = [[NSUUID UUID] UUIDString];
    
    UIViewController<AKFViewController> *viewController = [accountKit viewControllerForEmailLoginWithEmail:nil state:inputState];
    
    viewController.enableSendToFacebook = YES; // defaults to NO
    
    [self prepareLoginViewController:viewController withTheme:theme]; // see below
    
    [self.viewController presentViewController:viewController animated:YES completion:nil];
}

- (void)prepareLoginViewController:(UIViewController<AKFViewController> *)loginViewController withTheme:(NSDictionary *)themeInfo
{
    loginViewController.delegate = self;
    //set a theme to customize the UI.
    if (themeInfo) {
        AKFTheme *theme = [AKFTheme defaultTheme];
        theme.backgroundColor = [self colorWithRGBHexValue:themeInfo[@"backgroundColor"]];
        theme.buttonBackgroundColor = [self colorWithRGBHexValue:themeInfo[@"buttonBackgroundColor"]];
        theme.buttonBorderColor = [self colorWithRGBHexValue:themeInfo[@"buttonBorderColor"]];
        theme.buttonTextColor = [self colorWithRGBHexValue:themeInfo[@"buttonTextColor"]];
        theme.headerBackgroundColor = [self colorWithRGBHexValue:themeInfo[@"headerBackgroundColor"]];
        theme.headerTextColor = [self colorWithRGBHexValue:themeInfo[@"headerTextColor"]];
        theme.iconColor = [self colorWithRGBHexValue:themeInfo[@"iconColor"]];
        theme.inputBackgroundColor = [self colorWithRGBHexValue:themeInfo[@"inputBackgroundColor"]];
        theme.inputBorderColor = [self colorWithRGBHexValue:themeInfo[@"inputBorderColor"]];
        theme.inputTextColor = [self colorWithRGBHexValue:themeInfo[@"inputTextColor"]];
        theme.textColor = [self colorWithRGBHexValue:themeInfo[@"textColor"]];
        theme.titleColor = [self colorWithRGBHexValue:themeInfo[@"titleColor"]];
        theme.statusBarStyle = UIStatusBarStyleDefault;
        loginViewController.theme = theme;
    }
}


- (UIColor *)colorWithRGBHexValue:(NSString *)hexValue {
    NSString *cString = [[hexValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0];
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
