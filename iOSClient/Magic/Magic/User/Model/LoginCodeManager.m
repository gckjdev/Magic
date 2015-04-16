//
//  LoginCodeManager.m
//  BarrageClient
//
//  Created by Teemo on 15/3/19.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//
#define KEY_LOGIN_CURRENT_PHONENUM_CODE   @"KEY_LOGIN_CURRENT_PHONENUM_CODE"
#define KEY_LOGIN_CURRENT_EMAIL_CODE      @"KEY_LOGIN_CURRENT_EMAIL_CODE"
#import "LoginCodeManager.h"

@implementation LoginCodeManager
IMPL_SINGLETON_FOR_CLASS(RegisterCodeManager)


- (void)setCurrentPhoneNum:(NSString*)phoneNum
{
    if ([phoneNum length] > 0){
        UD_SET(KEY_LOGIN_CURRENT_PHONENUM_CODE, phoneNum);
    }
}
- (NSString*)getCurrentPhoneNum
{
    return UD_GET(KEY_LOGIN_CURRENT_PHONENUM_CODE);
}
- (void)clearCurrentPhoneNum
{
    return UD_REMOVE(KEY_LOGIN_CURRENT_PHONENUM_CODE);
}

- (void)setCurrentEmail:(NSString*)email
{
    if ([email length] > 0){
        UD_SET(KEY_LOGIN_CURRENT_EMAIL_CODE, email);
    }
}
- (NSString*)getCurrentEmail
{
    return UD_GET(KEY_LOGIN_CURRENT_EMAIL_CODE);
}
- (void)clearCurrentEmail
{
    return UD_REMOVE(KEY_LOGIN_CURRENT_EMAIL_CODE);
}
@end
