//
//  RegisterCodeManager.m
//  BarrageClient
//
//  Created by Teemo on 15/3/19.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#define KEY_REGISTER_CURRENT_PHONENUM_CODE   @"KEY_REGISTER_CURRENT_PHONENUM_CODE"
#define KEY_REGISTER_CURRENT_EMAIL_CODE      @"KEY_REGISTER_CURRENT_EMAIL_CODE"
#define KEY_REGISTER_CURRENT_PASSWORD_CODE   @"KEY_REGISTER_CURRENT_PASSWORD_CODE"
#define KEY_REGISTER_VERIFY_EMAIL_CODE       @"KEY_REGISTER_VERIFY_EMAIL_CODE"

#import "RegisterCodeManager.h"

@implementation RegisterCodeManager
IMPL_SINGLETON_FOR_CLASS(RegisterCodeManager)


- (void)setCurrentPhoneNum:(NSString*)phoneNum
{
    if ([phoneNum length] > 0){
        UD_SET(KEY_REGISTER_CURRENT_PHONENUM_CODE, phoneNum);
    }
}
- (NSString*)getCurrentPhoneNum
{
    return UD_GET(KEY_REGISTER_CURRENT_PHONENUM_CODE);
}
- (void)clearCurrentPhoneNum
{
    return UD_REMOVE(KEY_REGISTER_CURRENT_PHONENUM_CODE);
}

- (void)setCurrentEmail:(NSString*)email
{
    if ([email length] > 0){
        UD_SET(KEY_REGISTER_CURRENT_EMAIL_CODE, email);
    }
}
- (NSString*)getCurrentEmail
{
     return UD_GET(KEY_REGISTER_CURRENT_EMAIL_CODE);
}
- (void)clearCurrentEmail
{
    return UD_REMOVE(KEY_REGISTER_CURRENT_EMAIL_CODE);
}

- (void)setCurrentPassword:(NSString*)password
{
    if ([password length] > 0){
        UD_SET(KEY_REGISTER_CURRENT_PASSWORD_CODE, password);
    }
}
- (NSString*)getCurrentPassword
{
    return UD_GET(KEY_REGISTER_CURRENT_PASSWORD_CODE);
}
- (void)clearCurrentPassword
{
    return UD_REMOVE(KEY_REGISTER_CURRENT_PASSWORD_CODE);
}

- (void)setEmailVerify:(NSString*)code
{
    UD_SET(KEY_REGISTER_VERIFY_EMAIL_CODE, code);
}
- (NSString*)getEmailVerify
{
    return UD_GET(KEY_REGISTER_VERIFY_EMAIL_CODE);
}
@end
