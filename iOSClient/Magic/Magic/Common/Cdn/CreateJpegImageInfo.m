//
//  CreateJpegImageInfo.m
//  BarrageClient
//
//  Created by pipi on 15/1/27.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "CreateJpegImageInfo.h"
#import "TimeUtils.h"
#import "StringUtil.h"
#import "PPDebug.h"

@implementation CreateJpegImageInfo

- (NSData*)getImageData:(UIImage*)image quality:(float)quality
{
    NSData* data = nil;
    data = UIImageJPEGRepresentation(image, quality);
    
#ifdef DEBUG
    NSData* origData = UIImageJPEGRepresentation(image, quality);
#endif
    
    PPDebug(@"create image, raw/best quality data (%d), compressed data (%d)", [origData length], [data length]);
    return data;
}

- (NSString*)getMimeType
{
    return MIME_JPEG;
}

- (NSString*)getPathExtension
{
    return PATH_EXT_JPEG;
}

- (NSString*)createKey:(NSString*)keyPrefix
{
    NSString* pathExt = [self getPathExtension];
//    NSString* pathExt = @"aac";
    NSString* uuid = [NSString GetUUID];
    NSString* date = dateToStringByFormat([NSDate date], @"yyyyMMdd");
    NSString* key = [NSString stringWithFormat:@"%@/img/%@/%@.%@", keyPrefix, date, uuid, pathExt];
    PPDebug(@"<createKey> key = %@", key);
    return key;
}

@end
