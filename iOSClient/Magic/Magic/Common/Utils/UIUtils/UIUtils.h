//
//  UIUtils.h
//  three20test
//
//  Created by qqn_pipi on 10-1-9.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kCallNotSupportOnIPod		NSLocalizedString(@"kCallNotSupportOnIPod", @"")
#define kSmsNotSupportOnIPod		NSLocalizedString(@"kSmsNotSupportOnIPod", @"")
#define kFaceTimeNotSupportOnDevice NSLocalizedString(@"kFaceTimeNotSupportOnDevice", @"")

#define kAlertTextViewTag			2011031501
#define CHECK_APP_VERSION_ALERT_VIEW    9832432

@interface UIUtils : NSObject {	

}

//+ (void)alert:(NSString *)msg;
//+ (void)alertWithTitle:(NSString *)title msg:(NSString *)msg;
//+ (void)askYesNo:(NSString *)msg cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle delegate:(id)delegate;
+ (BOOL) canMakeCall:(NSString *)phoneNumber;
//+ (void)makeCall:(NSString *)phoneNumber;
//+ (void)sendSms:(NSString *)phoneNumber;
+ (void) sendEmail:(NSString *)phoneNumber;
+ (void) sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body;
+ (void)openApp:(NSString*)appId;
+ (void)gotoReview:(NSString*)appId;
+ (void)openLocation:(CLLocation*)location;
+ (NSString*)getAppLink:(NSString*)appId;
+ (BOOL) canFaceTime;
//+ (void) makeFaceTime:(NSString *)faceTimeId;
+ (NSString*)getAppVersion;
+ (NSString*)getAppName;
+ (BOOL)canOpenURL:(NSString*)url;


+ (void)openURL:(NSString*)url;

+ (void)openAppForUpgrade:(NSString*)appId;
//+ (void)checkAppVersion:(NSString*)appId;
//+ (BOOL)checkAppHasUpdateVersion;

//+ (void)checkAppVersion;
+ (NSString*)getUserDeviceName;

@end
