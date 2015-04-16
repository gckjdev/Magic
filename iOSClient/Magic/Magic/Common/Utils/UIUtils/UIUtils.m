//
//  UIUtils.m
//  three20test
//
//  Created by qqn_pipi on 10-1-9.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIUtils.h"
#import "DeviceDetection.h"
#import "PPDebug.h"
//#import "HJObjManager.h"
#import "ASIHTTPRequest.h"
#import "UIUtils.h"
#import "TimeUtils.h"
#import "DeviceDetection.h"
#import "LocaleUtils.h"

@implementation UIUtils


+ (NSString*) cleanPhoneNumber:(NSString*)phoneNumber
{
	NSString* number = [NSString stringWithString:phoneNumber];
	NSString* number1 = [[[number stringByReplacingOccurrencesOfString:@" " withString:@""]
						  //						stringByReplacingOccurrencesOfString:@"-" withString:@""]
						  stringByReplacingOccurrencesOfString:@"(" withString:@""] 
						 stringByReplacingOccurrencesOfString:@")" withString:@""];
	
	return number1;	
}

+ (BOOL) canMakeCall:(NSString *)phoneNumber
{
	if ([DeviceDetection isIPodTouch]){
		return NO;
	}
	
	NSString* numberAfterClear = [UIUtils cleanPhoneNumber:phoneNumber];		
	NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberAfterClear]];
	if (phoneNumberURL == nil){
		return NO;
	}
	
	return YES;
}

+ (BOOL) canFaceTime
{
	if ([DeviceDetection detectModel] == MODEL_IPHONE_4G || [DeviceDetection detectModel] == MODEL_IPOD_TOUCH_4G){
		return YES;
	}
	
	return NO;
}

//+ (void) makeFaceTime:(NSString *)faceTimeId
//{
//	if ([UIUtils canFaceTime] == NO){
//		[UIUtils alert:kFaceTimeNotSupportOnDevice];
//		return;
//	}
//	
//	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"facetime://%@", faceTimeId]];	
//	NSLog(@"Make FaceTime, URL=%@", [NSString stringWithFormat:@"facetime://%@", faceTimeId]);	
//	if (url == nil){
//		NSLog(@"Make FaceTime, URL incorrect");
//	}
//	
//	[[UIApplication sharedApplication] openURL:url];	
//}
//
//+ (void) makeCall:(NSString *)phoneNumber
//{
//	if ([DeviceDetection isIPodTouch]){
//		[UIUtils alert:kCallNotSupportOnIPod];
//		return;
//	}
//	
//	NSString* numberAfterClear = [UIUtils cleanPhoneNumber:phoneNumber];	
//	
//	NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberAfterClear]];
//	PPDebug(@"make call, URL=%@", phoneNumberURL);
//	
//	[[UIApplication sharedApplication] openURL:phoneNumberURL];	
//}
//
//+ (void) sendSms:(NSString *)phoneNumber
//{
//	if ([DeviceDetection isIPodTouch]){
//		[UIUtils alert:kSmsNotSupportOnIPod];
//		return;
//	}
//	
//	NSString* numberAfterClear = [UIUtils cleanPhoneNumber:phoneNumber];
//	
//	NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", numberAfterClear]];
//	NSLog(@"send sms, URL=%@", phoneNumberURL);
//	[[UIApplication sharedApplication] openURL:phoneNumberURL];	
//}

+ (void) sendEmail:(NSString *)phoneNumber
{
	NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", phoneNumber]];
	NSLog(@"send sms, URL=%@", phoneNumberURL);
	[[UIApplication sharedApplication] openURL:phoneNumberURL];	
}

+ (void) sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body
{
//	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
//	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString* str = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",
					 to, cc, subject, body];

	str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
//	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
//	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
	
}

+ (NSString*)getAppVersion
{
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return version;
}

+ (NSString*)getAppName
{
    // Attempt to find a name for this application
    NSBundle* bundle = [NSBundle mainBundle];
    NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
    }
    
    if (!appName) {
        return nil;
    }
    
    return appName;
}

+ (NSString*)getAppLink:(NSString*)appId
{
	NSString* iTunesLink = [NSString stringWithFormat:
							@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", appId];
	
    PPDebug(@"<getAppLink> iTunes Link=%@", iTunesLink);
	return iTunesLink;
}

+ (void)openApp:(NSString*)appId
{
	NSString* iTunesLink = [NSString stringWithFormat:
							@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", appId];	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];	
}

+ (void)gotoReview:(NSString*)appId
{
	NSString* iTunesLink = [NSString stringWithFormat:
							@"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=%@&type=Purple+Software", appId];
    
    PPDebug(@"goto app review, link=%@", iTunesLink);
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];	
}

+ (void)openURL:(NSString*)url
{
    PPDebug(@"Open URL=%@", url);
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];	
}

+ (BOOL)canOpenURL:(NSString*)url
{
    PPDebug(@"canOpenURL URL=%@", url);
    if ([url length] == 0){
        return NO;
    }
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}

+ (void)openLocation:(CLLocation*)location
{
	NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f", location.coordinate.latitude, location.coordinate.longitude];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];		
}

#pragma mark Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    enum ButtonIndex {
        kAddCalendar,
        kDoNothing
    };
	
    switch (buttonIndex) {
        case kDoNothing:
            break;
        case kAddCalendar:
        {
        }
            break;
        default:
            break;
    }
	
}


#pragma mark Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    enum ButtonIndex {
        kButtonCloseIndex,
        kButtonDialIndex
    };
	
    switch (buttonIndex) {
        case kButtonCloseIndex:
            break;
        case kButtonDialIndex:
        {
        }
            break;
        default:
            break;
    }		
}


+ (void)openAppForUpgrade:(NSString*)appId
{
    [UIUtils openApp:appId];
}


//#define KEY_APP_NEW_VERSION             @"checkAppVersion_KEY_APP_NEW_VERSION"
//#define KEY_APP_NEW_VERSION_URL         @"checkAppVersion_KEY_APP_NEW_VERSION_URL"
#define KEY_APP_LAST_CHECK_DATE         @"checkAppVersion_KEY_APP_LAST_CHECK_DATE"

+ (BOOL)hasCheckAppVersionToday
{
    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_APP_LAST_CHECK_DATE];
    if (date == nil)
        return NO;
    
    if (isLocalToday(date)){
        return YES;
    }
    else{
        return NO;
    }
}

//+ (BOOL)checkAppHasUpdateVersion
//{
//    NSString *currentVersion = [self getAppVersion];
//    NSString* newVersion = [PPConfigManager getLastAppVersion];
//
//    if (newVersion == nil) {
//        return NO;
//    }
//            
//    if ([newVersion floatValue] > [currentVersion floatValue]){
//        return YES;
//    }else{
//        return NO;
//    }
//}

+ (void)askToDownloadNewVersion:(NSString*)newVersionId
{
    int randValue = rand() % 2;
    if (randValue)
        return;
    
    NSString* message = [NSString stringWithFormat:NSLS(@"kNewVersionMessage"), newVersionId];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLS(@"kNewVersionTitle") message:message delegate:self cancelButtonTitle:NSLS(@"Remind Later") otherButtonTitles:NSLS(@"kUpgradeNow"), nil];
    alertView.tag = CHECK_APP_VERSION_ALERT_VIEW;
    [alertView show];
}

//+ (void)checkAppVersion:(NSString*)appId
//{
//    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
//    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
//    
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString* newVersion = [userDefaults objectForKey:KEY_APP_NEW_VERSION];
//    NSString* appUrl = [userDefaults objectForKey:KEY_APP_NEW_VERSION_URL];
//    if (newVersion && appUrl &&
//        [newVersion isEqualToString:currentVersion] == NO){
//        if ([newVersion floatValue] > [currentVersion floatValue]){
//            [self askToDownloadNewVersion:newVersion];
//            return;
//        }
//        else{
//            // current version is the latest one, skip and return
//            return;
//        }
//    }
//    
//    if ([self hasCheckAppVersionToday]){
//        return;
//    }
//    
//    [userDefaults setObject:[NSDate date] forKey:KEY_APP_LAST_CHECK_DATE];
//    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    if (queue == NULL){
//        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
//        if (queue == NULL){
//            return;
//        }
//    }
//    
//    dispatch_async(queue, ^{
//        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appId]];
//        ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
//        [request startSynchronous];
//        NSString* responseString = [request responseString];
//        if ([responseString length] > 0){
//            NSDictionary *jsonData = [responseString JSONValue];
//            NSArray *infoArray = [jsonData objectForKey:@"results"];
//            if ([infoArray count] == 0)
//                return;
//            
//            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
//            
//            NSString *latestVersion = [releaseInfo objectForKey:@"version"];
//            NSString *trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];
////            NSString *releaseNotes = [releaseInfo objectForKey:@"releaseNotes"];
//            NSLog(@"releaseInfo=%@", [releaseInfo description]);
//            
//            if ([latestVersion isEqualToString:currentVersion] == NO &&
//                [latestVersion floatValue] > [currentVersion floatValue]){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    // save track view URL and new version to user defaults
//                    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//                    [userDefaults setObject:latestVersion forKey:KEY_APP_NEW_VERSION];
//                    [userDefaults setObject:trackViewUrl forKey:KEY_APP_NEW_VERSION_URL];
//                    [userDefaults synchronize];
//                    
//                    [self askToDownloadNewVersion:latestVersion];
//                });
//            }
//            else{
//                // current version is the latest one, skip and return
//            }
//        }
//    });
//}

//+ (void)checkAppVersion
//{
//    if ([self hasCheckAppVersionToday]){
//        return;
//    }
//    
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:[NSDate date] forKey:KEY_APP_LAST_CHECK_DATE];
//    [userDefaults synchronize];
//
//    // save track view URL and new version to user defaults
//    NSString *currentVersion = [self getAppVersion];
//    NSString *lastVersion = [PPConfigManager getLastAppVersion];
//        
//    if ([lastVersion floatValue] > [currentVersion floatValue]){
//        [self askToDownloadNewVersion:lastVersion];
//        return;
//    }
// }

+ (NSString*)getUserDeviceName
{
    UIDevice* device = [UIDevice currentDevice];
    
    NSString* name = [device name];
    
    name = [name stringByReplacingOccurrencesOfString:@"iPhone" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"iPad" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"iOS" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"iPod" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"Touch" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"\'s" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"\'" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"“" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"”" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"的" withString:@""];
    
    
    
    return name;
}

@end



