//
//  UIImageUtil.h
//  three20test
//
//  Created by qqn_pipi on 10-3-23.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    CornerLeftTop = 0x1,
    CornerRightTop = 0x1 << 1,
    CornerLeftBottom = 0x1 << 2,
    CornerRightBottom = 0x1 << 3,
    CornerAll = (0x1 << 4) - 1,
}Corner;


@interface UIImage (UIImageUtil)

- (BOOL)saveJPEGToFile:(NSString*)fileName compressQuality:(CGFloat)compressQuality;
- (BOOL)saveImageToFile:(NSString*)fileName;
+ (CGRect)shrinkFromOrigRect:(CGRect)origRect imageSize:(CGSize)imageSize;
+ (NSData *)compressImage:(UIImage *)image;
+ (NSData *)compressImage:(UIImage *)image byQuality:(float)quality;

+ (UIImage*)strectchableImageName:(NSString*)name;
+ (UIImage*)strectchableTopImageName:(NSString*)name;
+ (UIImageView*)strectchableImageView:(NSString*)name viewWidth:(int)viewWidth;
+ (UIImage*)strectchableImageName:(NSString*)name leftCapWidth:(int)leftCapWidth;
+ (UIImage*)strectchableImageName:(NSString*)name topCapHeight:(int)topCapHeight;
+ (UIImage*)strectchableImageName:(NSString*)name leftCapWidth:(int)leftCapWidth topCapHeight:(int)topCapHeight;
+ (UIImage*)creatThumbnailsWithData:(NSData*)data withSize:(CGSize)size;

- (UIImage*)defaultStretchableImage;

+ (UIImage*)creatImageByImage:(UIImage*)backgroundImage 
                    withLabel:(UILabel*)label;
+ (UIImage *)shrinkImage:(UIImage*)image 
                withRate:(float)rate;
+ (UIImage *)adjustImage:(UIImage*)image 
                 toRatio:(float)ratio;
+ (NSString *)fixImageName:(NSString *)imageName;

+ (UIImage *)imageFromColor:(UIColor *)color
                     corner:(Corner)corner
                     radius:(CGFloat)radius;

-(UIImage*)getSubImage:(CGRect)rect;

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

+ (UIImage *)imageNamedFixed:(NSString*)imageName;

+ (UIImage *)imageNamedScaleToOne:(NSString*)imageName;

+ (UIImage *)resizableImage:(NSString *)name;

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size;
- (NSData*)getData;
- (NSData*)data;
- (NSUInteger)uncompressSize;

- (BOOL) hasAlpha;
- (UIImage *)whiteToTransparent;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageFromCircleColor:(UIColor *)color radius:(CGFloat)radius;
@end

#define TOP_ROUND_CORNER_IMAGE_FROM_COLOR(color) ([UIImage imageFromColor:color corner:CornerLeftTop|CornerRightTop radius:DEFAULT_CORNER_RADIUS])

#define BOTTOM_ROUND_CORNER_IMAGE_FROM_COLOR(color) ([UIImage imageFromColor:color corner:CornerLeftBottom|CornerRightBottom radius:DEFAULT_CORNER_RADIUS])

#define LEFT_ROUND_CORNER_IMAGE_FROM_COLOR(color) ([UIImage imageFromColor:color corner:CornerLeftBottom|CornerLeftTop radius:DEFAULT_CORNER_RADIUS])

#define RIGHT_ROUND_CORNER_IMAGE_FROM_COLOR(color) ([UIImage imageFromColor:color corner:CornerRightTop|CornerRightBottom radius:DEFAULT_CORNER_RADIUS])

#define ALL_ROUND_CORNER_IMAGE_FROM_COLOR(color) ([UIImage imageFromColor:color corner:CornerAll radius:DEFAULT_CORNER_RADIUS])

