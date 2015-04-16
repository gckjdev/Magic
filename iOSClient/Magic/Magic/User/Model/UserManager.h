//
//  UserManager.h
//  BarrageClient
//
//  Created by pipi on 14/12/8.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonManager.h"
#import "Barrage.pb.h"

@interface UserManager : CommonManager
{
    PBUser* _pbUser;
}

DEF_SINGLETON_FOR_CLASS(UserManager)

- (void)storeUser:(PBUser*)pbUser;
- (void)storeUser;
- (PBUser*)pbUser;
- (PBUser*)miniPbUser;
- (NSString*)userId;
- (BOOL)hasUser;
- (void)printUser;
- (BOOL)hasSetNameAndAvatar;
- (NSString*)getSinaWeiboNick;
- (NSString*)getQQNick;
- (NSString*)getWeChatNick;

- (PBBarrageSpeed)barrageSpeed;
- (PBBarrageStyle)barrageStyle;
+ (NSString*)encryptPassword:(NSString*)rawPassword;
-(PBDevice*)getCurrentDevice;

-(void)setUserBSpeed:(int)bSpeed;
-(void)setUserBtyle:(int)bStyle;

@end
