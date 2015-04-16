//
//  LoginCodeManager.h
//  BarrageClient
//
//  Created by Teemo on 15/3/19.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "CommonManager.h"

@interface LoginCodeManager : CommonManager
DEF_SINGLETON_FOR_CLASS(InviteCodeManager)

- (void)setCurrentPhoneNum:(NSString*)phoneNum;
- (NSString*)getCurrentPhoneNum;
- (void)clearCurrentPhoneNum;

- (void)setCurrentEmail:(NSString*)email;
- (NSString*)getCurrentEmail;
- (void)clearCurrentEmail;
@end
