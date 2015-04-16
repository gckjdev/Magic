//
//  QNImageToolURL.h
//  BarrageClient
//
//  Created by Teemo on 15/3/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNImageToolURL : NSObject
/**
 *  返回获取原图片的URL
 */
+(NSString*)GetNormalSizeImageUrl:(NSString*)url;
/**
 *  返回获取原图片尺寸一半的URL，按原图等比缩放
 */
+(NSString*)GetMiddleSizeImageUrl:(NSString*)url;
/**
 *  返回获取原图片尺寸四分之一的URL，按原图等比缩放
 */
+(NSString*)GetSmallSizeImageUrl:(NSString*)url;
/**
 *  返回获取图片Width*Height尺寸的URL，按原图等比缩放
 */
+(NSString*)GetThumbnailSizeImageUrl:(NSString*)url width:(int)width height:(int)height;
@end
