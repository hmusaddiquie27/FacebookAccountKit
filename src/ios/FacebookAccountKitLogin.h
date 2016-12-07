//
//  FacebookAccountKitLogin.h
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
