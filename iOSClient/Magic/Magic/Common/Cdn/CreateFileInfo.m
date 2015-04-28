//
//  CreateFileInfo.m
//  Magic
//
//  Created by Teemo on 15/4/20.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "CreateFileInfo.h"
#import "TimeUtils.h"
#import "StringUtil.h"
#import "PPDebug.h"

@implementation CreateFileInfo
+(NSString*)audioCreateKey:(NSString*)keyPrefix
{
    NSString* pathExt = @"wav";
    NSString* uuid = [NSString GetUUID];
    NSString* date = dateToStringByFormat([NSDate date], @"yyyyMMdd");
    NSString* key = [NSString stringWithFormat:@"%@/audio/%@/%@.%@", keyPrefix, date, uuid, pathExt];
    PPDebug(@"<createKey> key = %@", key);
    return key;
}
@end
