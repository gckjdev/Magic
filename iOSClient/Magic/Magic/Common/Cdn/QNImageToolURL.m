//
//  QNImageToolURL.m
//  BarrageClient
//
//  Created by Teemo on 15/3/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//
//七牛api http://developer.qiniu.com/docs/v6/api/reference/fop/image/imagemogr2.html




#define THUMBNAIL_IMAGE_SIZE            100         //100*100的缩略图
#define MIDDLESIZE_IMAGE_PERCENT        50         //原图的一半
#define SMALLSIZE_IMAGE_PERCENT        25          //原图的1/4

#import "QNImageToolURL.h"

@implementation QNImageToolURL



+(NSString*)GetNormalSizeImageUrl:(NSString*)url
{
    NSMutableString *resultUrl = [url mutableCopy];
    return resultUrl;
}

+(NSString*)GetMiddleSizeImageUrl:(NSString*)url
{
    if ([url length] == 0){
        return url;
    }

    NSMutableString *resultUrl = [url mutableCopy];
    NSString* paraStr = @"?imageMogr2/thumbnail/!%dp";
    [resultUrl appendFormat:paraStr,MIDDLESIZE_IMAGE_PERCENT];
    return resultUrl;
}

+(NSString*)GetSmallSizeImageUrl:(NSString*)url
{
    if ([url length] == 0){
        return url;
    }

    NSMutableString *resultUrl = [url mutableCopy];
    NSString* paraStr = @"?imageMogr2/thumbnail/!%dp";
    [resultUrl appendFormat:paraStr,SMALLSIZE_IMAGE_PERCENT];
    return resultUrl;
}

+(NSString*)GetThumbnailSizeImageUrl:(NSString*)url width:(int)width height:(int)height;
{
    if ([url length] == 0){
        return url;
    }
    
    NSMutableString *resultUrl = [url mutableCopy];
    [resultUrl appendFormat:@"?imageMogr2/thumbnail/%dx%d",width,height];
    return resultUrl;
}

@end
