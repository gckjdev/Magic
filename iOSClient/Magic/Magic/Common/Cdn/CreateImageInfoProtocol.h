//
//  CreateImageInfo.h
//  BarrageClient
//
//  Created by pipi on 15/1/27.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MIME_JPEG                       @"image/jpeg"
#define MIME_WEBP                       @"image/webp"
#define PATH_EXT_WEBP                   @"webp"
#define PATH_EXT_JPEG                   @"jpg"

typedef enum
{
    UPLOAD_JPEG              = 1,
    UPLOAD_WEBP              = 2,
    
} UploadImageType;

@protocol CreateImageInfoProtocol <NSObject>

@required

- (NSData*)getImageData:(UIImage*)image quality:(float)quality;
- (NSString*)getMimeType;
- (NSString*)getPathExtension;
- (NSString*)createKey:(NSString*)keyPrefix;

@end
