//
//  SMSManager.m
//  BarrageClient
//
//  Created by Teemo on 15/3/17.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//
#import <SMS_SDK/SMS_SDK.h>
#import <SMS_SDK/CountryAndAreaCode.h>
#import "SMSManager.h"
#import "PPDebug.h"

@implementation SMSManager
+(void)sendMessage:(NSString*)phone zone:(NSString*)zone
{
    
    [SMS_SDK getVerifyCodeByPhoneNumber:phone AndZone:zone result:^(enum SMS_GetVerifyCodeResponseState state) {
        if (state == SMS_ResponseStateGetVerifyCodeSuccess) {
            PPDebug(@"send phone : +%@-%@ message succes",zone,phone);
        }
        else
        {
            PPDebug(@"send phone : +%@-%@ message fail",zone,phone);
            
        }
        
    }];
   
}
+(void)commitVerifty:(NSString*)code
{
    [SMS_SDK commitVerifyCode:code result:^(enum SMS_ResponseState state) {
        if (state == SMS_ResponseStateSuccess) {
            PPDebug(@"Verifty Success");
        }
        else
        {
            PPDebug(@"Verifty fail");
        }
    }];
    
}
@end
