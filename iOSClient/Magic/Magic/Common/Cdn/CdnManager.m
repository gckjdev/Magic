//
//  CdnManager.m
//  BarrageClient
//
//  Created by pipi on 15/1/27.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "CdnManager.h"
#import "BarrageConfigManager.h"


@implementation CdnManager

IMPL_SINGLETON_FOR_CLASS(CdnManager)

- (NSString*)getUserDataUrl:(NSString*)key
{
    return QIUNIU_USER_IMAGE(key);
}

- (NSString*)getUserDataToken
{
    return QIUNIU_USER_TOKEN;
}

- (NSString*)getUserAvatarDataPrefix
{
    return @"user/av";
}

- (NSString*)getUserBackgroundDataPrefix
{
    return @"user/bg";
}

- (NSString*)getFeedDataUrl:(NSString*)key
{
    return QIUNIU_FEED_IMAGE(key);
}

- (NSString*)getFeedDataToken
{
    return QIUNIU_FEED_TOKEN;
}

- (NSString*)getFeedDataKeyPrefix
{
    return @"dat";
}


@end
