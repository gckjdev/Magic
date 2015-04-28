//
//  VoiceCacheManager.h
//  Magic
//
//  Created by pipi on 15/4/26.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "CommonManager.h"
#import "APLevelDB.h"
@interface VoiceCacheManager : CommonManager
{
    APLevelDB* _db;
}

DEF_SINGLETON_FOR_CLASS(VoiceCacheManager);

-(void)setVoicePath:(NSString*)voiceURL filePath:(NSString*)filePath;

-(NSString*)getVoicePath:(NSString*)voiceURL;

-(void)removeVoicePath:(NSString*)voiceURL;

@end
