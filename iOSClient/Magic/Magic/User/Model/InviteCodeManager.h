//
//  InviteCodeManager.h
//  BarrageClient
//
//  Created by pipi on 15/1/10.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "CommonManager.h"
#import "User.pb.h"

@interface InviteCodeManager : CommonManager

DEF_SINGLETON_FOR_CLASS(InviteCodeManager)

//- (NSArray*)getCodes;
//- (void)storeCodes:(NSArray*)codes;
//- (NSArray*)getUsedCodes;
//- (void)useCode:(NSString*)code info:(NSString*)info;

// invite code login cache
- (void)setCurrentInviteCode:(NSString*)code;
- (NSString*)getCurrentInviteCode;
- (void)clearCurrentInviteCode;


- (void)storeUserInviteCodeList:(PBUserInviteCodeList*)list;
- (PBUserInviteCodeList*)getUserInviteCodeList;

@end
