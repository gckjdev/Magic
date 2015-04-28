//
//  VoiceCacheManager.m
//  Magic
//
//  Created by pipi on 15/4/26.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "VoiceCacheManager.h"

#import "LevelDBManager.h"
#import "FileUtil.h"

#define DB_USER_CHAT               @"db_chatvoice_cache"


@implementation VoiceCacheManager

IMPL_SINGLETON_FOR_CLASS(VoiceCacheManager);


- (instancetype)init
{
    self = [super init];
    
    if (self !=nil) {
 
        NSString* dbName = [NSString stringWithFormat:@"%@.db", DB_USER_CHAT];
        _db = [[LevelDBManager defaultManager] db:dbName];
    }

    return self;
}


-(void)setVoicePath:(NSString*)voiceURL filePath:(NSString*)filePath
{
    
    [_db setObject:filePath.lastPathComponent forKey:voiceURL];
}

-(NSString*)getVoicePath:(NSString*)voiceURL
{
    NSString *voiceName = [_db objectForKey:voiceURL];
    if (voiceName ==nil) {
        return nil;
    }
    NSMutableString *path = [NSMutableString string];
    NSString *tmpPath = [[FileUtil getAppCacheDir]stringByAppendingPathComponent:@"chatvoice"];

    [path appendString: [tmpPath stringByAppendingPathComponent:voiceName]];
  
    return [path copy];
}

-(void)removeVoicePath:(NSString*)voiceURL
{
    [_db removeKey:voiceURL];
}
@end
