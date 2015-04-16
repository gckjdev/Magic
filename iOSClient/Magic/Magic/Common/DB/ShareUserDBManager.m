//
//  ShareUserDBManager.m
//  BarrageClient
//
//  Created by pipi on 15/1/20.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "ShareUserDBManager.h"
#import "UserManager.h"

@implementation ShareUserDBManager

IMPL_SINGLETON_FOR_CLASS(ShareUserDBManager)

- (APLevelDB*)db
{
    NSString* userId = [[UserManager sharedInstance] userId];
    if ([userId length] == 0){
        PPDebug(@"call ShareUserDBManager but userId is nil");
        return nil;
    }
    
    NSString* name = [NSString stringWithFormat:@"user_db_%@.db", userId];
    PPDebug(@"access db %@", name);
    return [[LevelDBManager defaultManager] db:name];
}

- (APLevelDB*)dbForFeedPlayIndex
{
    NSString* userId = [[UserManager sharedInstance] userId];
    if ([userId length] == 0){
        PPDebug(@"call ShareUserDBManager but userId is nil");
        return nil;
    }
    
    NSString* name = [NSString stringWithFormat:@"user_db_feed_play_%@.db", userId];
    return [[LevelDBManager defaultManager] db:name];
}

@end
