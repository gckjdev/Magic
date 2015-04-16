//
//  RegisterCodeManager.h
//  BarrageClient
//
//  Created by Teemo on 15/3/19.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "CommonManager.h"

@interface RegisterCodeManager : CommonManager
DEF_SINGLETON_FOR_CLASS(InviteCodeManager)


- (void)setCurrentPhoneNum:(NSString*)phoneNum;
- (NSString*)getCurrentPhoneNum;
- (void)clearCurrentPhoneNum;

- (void)setCurrentEmail:(NSString*)email;
- (NSString*)getCurrentEmail;
- (void)clearCurrentEmail;

- (void)setCurrentPassword:(NSString*)password;
- (NSString*)getCurrentPassword;
- (void)clearCurrentPassword;

- (void)setEmailVerify:(NSString*)code;
- (NSString*)getEmailVerify;
@end
