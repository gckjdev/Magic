//
//  UIImageUtil.m
//  three20test
//
//  Created by qqn_pipi on 10-3-23.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIImageUtil.h"
#import "FileUtil.h"
#import "DeviceDetection.h"
#import "PPDebug.h"

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


@implementation UIImage (UIImageUtil)

- (UIImage*)defaultStretchableImage
{
    return [self stretchableImageWithLeftCapWidth:self.size.width/2 topCapHeight:self.size.height/2];
}

+ (UIImage*)strectchableImageName:(NSString*)name
{
    UIImage* image = [UIImage imageNamedFixed:name];
    return [image defaultStretchableImage];
}

+ (UIImage*)strectchableTopImageName:(NSString*)name
{
    UIImage* image = [UIImage imageNamedFixed:name];
    int topCapHeight = image.size.height/2;
    return [image stretchableImageWithLeftCapWidth:0 topCapHeight:topCapHeight];
}

+ (UIImage*)strectchableImageName:(NSString*)name leftCapWidth:(int)leftCapWidth
{
    UIImage* image = [UIImage imageNamedFixed:name];
    return [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:0];
}

+ (UIImage*)strectchableImageName:(NSString*)name topCapHeight:(int)topCapHeight
{
    UIImage* image = [UIImage imageNamedFixed:name];
    return [image stretchableImageWithLeftCapWidth:0 topCapHeight:topCapHeight];    
}

+ (UIImage*)strectchableImageName:(NSString*)name leftCapWidth:(int)leftCapWidth topCapHeight:(int)topCapHeight
{
    UIImage* image = [UIImage imageNamedFixed:name];
    return [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];    
}

+ (UIImageView*)strectchableImageView:(NSString*)name viewWidth:(int)viewWidth
{
    UIImage* image = [UIImage strectchableImageName:name];
    UIImageView* view = [[UIImageView alloc] initWithImage:image];
    view.frame = CGRectMake(0, 0, viewWidth, image.size.height);
    return view;
}

//Add By ChaoSo on 2014.08.05
- (BOOL)saveJPEGToFile:(NSString*)fileName compressQuality:(CGFloat)compressQuality
{
	// Create paths to output images
    //	NSString  *pngPath = [FileUtil getFileFullPath:fileName];
	
    //	[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    //	NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
	
	// Write a UIImage to JPEG with minimum compression (best quality)
	// The value 'image' must be a UIImage object
	// The value '1.0' represents image compression quality as value from 0.0 to 1.0
    BOOL result = [UIImageJPEGRepresentation(self, compressQuality) writeToFile:fileName atomically:YES];
	
	// Write image to PNG
//	BOOL result = [UIImagePNGRepresentation(self) writeToFile:fileName atomically:YES];
	
	// Let's check to see if files were successfully written...
	
	// Create file manager
	//NSError *error;
	//NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	// Point to Document directory
	//NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	
	// Write out the contents of home directory to console
	//NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
	
	PPDebug(@"Write to file (%@), width(%.0f), height(%.0f), size (%ld), result=%d",
            fileName,
            self.size.width,
            self.size.height,
            [FileUtil fileSizeAtPath:fileName],
            result);
	
	return result;
}


- (BOOL)saveImageToFile:(NSString*)fileName
{
	// Create paths to output images
//	NSString  *pngPath = [FileUtil getFileFullPath:fileName];
	
//	[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
//	NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
	
	// Write a UIImage to JPEG with minimum compression (best quality)
	// The value 'image' must be a UIImage object
	// The value '1.0' represents image compression quality as value from 0.0 to 1.0
//	[UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
	
	// Write image to PNG
	BOOL result = [UIImagePNGRepresentation(self) writeToFile:fileName atomically:YES];
	
	// Let's check to see if files were successfully written...
	
	// Create file manager
	//NSError *error;
	//NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	// Point to Document directory
	//NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	
	// Write out the contents of home directory to console
	//NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
	
    PPDebug(@"Write to file (%@), width(%.0f), height(%.0f), size (%ld), result=%d",
            fileName,
            self.size.width,
            self.size.height,
            [FileUtil fileSizeAtPath:fileName],
            result);
	
	return result;
}

+ (CGRect)shrinkFromOrigRect:(CGRect)origRect imageSize:(CGSize)imageSize
{
    CGRect retRect = origRect;
    
    if (imageSize.width > origRect.size.width && imageSize.height <= origRect.size.height){
        // use height 
        float percentage = origRect.size.width / imageSize.width;
        float width = imageSize.width * percentage;
        float height = imageSize.height * percentage;
        retRect.size = CGSizeMake(width, height);
    }
    else if (imageSize.width <= origRect.size.width && imageSize.height > origRect.size.height){
        // use width
        float percentage = origRect.size.height / imageSize.height;
        float width = imageSize.width * percentage;
        float height = imageSize.height * percentage;
        retRect.size = CGSizeMake(width, height);            
    }
    else if (imageSize.width > origRect.size.width && imageSize.height > origRect.size.height){
        float percentage1 = origRect.size.height / imageSize.height;
        float percentage2 = origRect.size.width / imageSize.width;
        float percentage;
        if (percentage1 > percentage2){
            percentage = percentage2;
        }
        else{
            percentage = percentage1;
        }
        float width = imageSize.width * percentage;
        float height = imageSize.height * percentage;
        retRect.size = CGSizeMake(width, height);                        
    }
    else{
        retRect.size = CGSizeMake(imageSize.width, imageSize.height);
    }
    
    return retRect;
}

#define IMAGE_DEFAULT_COMPRESS_QUALITY  1.0
#define IMAGE_POST_MAX_BYTE             (6000000)

+ (NSData *)compressImage:(UIImage *)image {

    NSData *data = UIImageJPEGRepresentation(image,IMAGE_DEFAULT_COMPRESS_QUALITY);
    NSUInteger length = [data length];
    if (length <= IMAGE_POST_MAX_BYTE) {
        return data;
    }
    CGFloat quality = IMAGE_POST_MAX_BYTE/(CGFloat)length;
    NSData *tempData = UIImageJPEGRepresentation(image, quality);
    return tempData;
}

+ (NSData *)compressImage:(UIImage *)image byQuality:(float)quality{
    float compressQuality = quality;
    NSData *originData = UIImageJPEGRepresentation(image, 1.0);
    NSData *tempData = UIImageJPEGRepresentation(image, compressQuality);
    NSLog(@"before compress, size is %lu\n after compress, size is %lu", (unsigned long)[originData length], (unsigned long)[tempData length]);
    return tempData;

}

+ (UIImage*)creatThumbnailsWithData:(NSData*)data withSize:(CGSize)size
{
    UIImage* tempImage = [UIImage imageWithData:data];
    return [tempImage imageByScalingAndCroppingForSize:size];
}

+ (UIImage*)creatImageByImage:(UIImage*)backgroundImage 
                    withLabel:(UILabel*)label
{
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setAdjustsFontSizeToFitWidth:YES];

    
    UIGraphicsBeginImageContext(backgroundImage.size);
    
    // Draw image1
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    
    // Draw image2    
    [label drawTextInRect:label.frame];
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext(); 
    
    return resultImage;
}

+ (UIImage *)shrinkImage:(UIImage*)image 
                withRate:(float)rate
{
    if (rate
         > 1.0) {
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width*rate, image.size.height*rate));
        
        // Draw image1
        [image drawInRect:CGRectMake(0,
                                             0,
                                             image.size.width*rate,
                                             image.size.height*rate)];
        
        
        UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext(); 
        
        return resultImage;
    }
    UIImage* compressImage = [image imageByScalingAndCroppingForSize:CGSizeMake(image.size.width*rate, image.size.height*rate)];
    UIGraphicsBeginImageContext(image.size);
    
    // Draw image1
    [compressImage drawInRect:CGRectMake((1 - rate)*image.size.width/2, 
                                 (1 - rate)*image.size.height/2, 
                                 compressImage.size.width, 
                                 compressImage.size.height)];
    
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext(); 
    
    return resultImage;
}

+ (UIImage *)adjustImage:(UIImage*)image 
                 toRatio:(float)ratio;
{
    float maxLen = MAX(image.size.width, image.size.height);
    UIGraphicsBeginImageContext(CGSizeMake(maxLen, maxLen));
    
    // Draw image1
    if (image.size.width > image.size.height) {
        [image drawInRect:CGRectMake(0, (maxLen-image.size.height)/2, image.size.width, image.size.height)];
    } else {
        [image drawInRect:CGRectMake((maxLen-image.size.width)/2, 0, image.size.width, image.size.height)];
    }

    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext(); 
    
    return resultImage;
}

+ (NSString *)fixImageName:(NSString *)imageName
{
    if([DeviceDetection isIPAD]){
        return [NSString stringWithFormat:@"%@@2x",imageName];
    }
    return imageName;
}
+ (UIImage *)imageFromCircleColor:(UIColor *)color radius:(CGFloat)radius
{
    CGFloat width = MAX(10, radius * 2+8);
    UIImage *image = nil;
    UIGraphicsBeginImageContext(CGSizeMake(width, width));
   
    [color setFill];
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextAddEllipseInRect(context, CGRectMake(4, 4, radius*2, radius*2));
    
    [color set];
    // 闭合路径
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageFromColor:(UIColor *)color corner:(Corner)corner radius:(CGFloat)radius
{
    CGFloat width = MAX(10, radius * 2+2);
    UIImage *image = nil;
    UIGraphicsBeginImageContext(CGSizeMake(width, width));
    CGFloat height = width;
    [color setFill];
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 移动到初始点
    if (corner&CornerLeftTop) {
        CGContextMoveToPoint(context, radius, 0);
    }else{
        CGContextMoveToPoint(context, 0, 0);
    }
    
    if (corner&CornerRightTop) {
        // 绘制第1条线和第1个1/4圆弧
        CGContextAddLineToPoint(context, width - radius, 0);
        CGContextAddArc(context, width - radius, radius, radius, -0.5 * M_PI, 0.0, 0);
    }else{
        CGContextAddLineToPoint(context, width, 0);
    }
    
    if (corner & CornerRightBottom) {
        // 绘制第2条线和第2个1/4圆弧
        CGContextAddLineToPoint(context, width, height - radius);
        CGContextAddArc(context, width - radius, height - radius, radius, 0.0, 0.5 * M_PI, 0);
    }else{
        CGContextAddLineToPoint(context, width, height);
    }
    
    if (corner&CornerLeftBottom) {
        // 绘制第3条线和第3个1/4圆弧
        CGContextAddLineToPoint(context, radius, height);
        CGContextAddArc(context, radius, height - radius, radius, 0.5 * M_PI, M_PI, 0);
    }else{
        CGContextAddLineToPoint(context, 0, height);
    }
    
    if (corner&CornerLeftTop) {
        // 绘制第4条线和第4个1/4圆弧
        CGContextAddLineToPoint(context, 0, radius);
        CGContextAddArc(context, radius, radius, radius, M_PI, 1.5 * M_PI, 0);
    }else{
        CGContextAddLineToPoint(context, 0, 0);
    }
    
    // 闭合路径
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image stretchableImageWithLeftCapWidth:width/2 topCapHeight:width/2];
}

+ (UIImage *)resizableImage:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.5;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    
    return smallImage;
}


- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    if (image == nil){
        return nil;
    }
    
    if (scaleSize == 1.0f){
        return image;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+(UIImage *)imageNamedScaleToOne:(NSString*)imageName{
    NSString* extension = @"png";
    if ([imageName hasSuffix:@"jpg"]){
        extension = @"jpg";
    }
    
    imageName = [imageName stringByDeletingPathExtension];
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:extension];
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    if(ISIOS8){
        
    
        if ([imageName containsString:@"@2x"]){
            return [UIImage imageWithData:data scale:1.0];
        }
        else{
            return [UIImage imageNamed:imageName];
        }
    }
    else{
        
        NSRange range = [imageName rangeOfString:@"@2x"];
        if (range.location!=NSNotFound){
            return [UIImage imageWithData:data scale:1.0];
        }
        else{
            return [UIImage imageNamed:imageName];
        }
        
    }
}

+ (UIImage *)imageNamedFixed:(NSString*)imageName
{
    if (ISIOS8 && ISIPAD){

        NSString* extension = @"png";
        if ([imageName hasSuffix:@"jpg"]){
            extension = @"jpg";
        }
        
        imageName = [imageName stringByDeletingPathExtension];
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:extension];
        NSData* data = [NSData dataWithContentsOfFile:path];
        if ([imageName containsString:@"@2x"]){
            return [UIImage imageWithData:data scale:1.0];
        }
        else{
            return [UIImage imageNamed:imageName];
        }
    }
    else{            
        return [UIImage imageNamed:imageName];
    }
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    //	UIGraphicsBeginImageContext(targetSize); // this will crop
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, self.scale);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}




+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size
{
    if (image == nil)
        return nil;
    
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGBitmapAlphaInfoMask);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 10, 10);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *retImage = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    
    return retImage;
}

- (NSData*)getData
{
    NSData* data = UIImageJPEGRepresentation(self, 1.0);
    if (nil == data) {
        data = UIImagePNGRepresentation(self);
    }
    
    return data;
}

- (NSData*)data
{
    return [self getData];
}

- (NSUInteger)uncompressSize
{
    int height = self.size.height;
    int width = self.size.width;
    
    int bytesPerRow = 4*width;
    if (bytesPerRow % 16)
        bytesPerRow = ((bytesPerRow / 16) + 1) * 16;
    
    int dataSize = height*bytesPerRow;
    return dataSize;
}

- (BOOL)hasAlpha
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

#pragma mark 白色背景变为透明
- (UIImage *)whiteToTransparent
{
    CGImageRef rawImageRef = self.CGImage;
    
    CGFloat minValue = 222.0f;    //  可以调节，如果图片只有白色和黑色，可以调节到180，待测
    CGFloat maxValue = 255.0f;    //  去除白色的话，这个必须是255
    CGFloat colorMasking[6] = {minValue,maxValue,minValue,maxValue,minValue,maxValue};
    
    //    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    //        UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    //    else
    //        UIGraphicsBeginImageContext(self.size);
    
    UIGraphicsBeginImageContextWithOptions(self.size, YES, self.scale);
    
    CGImageRef maskedImageRef = CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    //  没有这个，生成的图片会倒转
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, self.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       CGRectMake(0, 0, self.size.width, self.size.height),
                       maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();
    return result;
}

-(UIColor*)mostColor{
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(50, 50);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, self.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL){
         //add by neng, Analyze
         CGContextRelease(context);
         return nil;
    }
    
    
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            
            int offset = 4*(x*y);
            
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            
            NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
            [cls addObject:clr];
            
        }
    }
    CGContextRelease(context);
    
    
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        
        if ( tmpCount < MaxCount ) continue;
        
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

//- (void)colorAction:(id)sender{
//    bgimageV.image = nil;
//
//    UIColor *color = nil;
//    int colorNum = arc4random()%2;
//    if (colorNum == 0)
//        color = [UIColor blackColor];
//    else if (colorNum == 1)
//        color = [UIColor whiteColor];
//    [bgimageV setBackgroundColor:color];
//
//    [self setTextColor];
//}
//
//
//- (void)setTextColor{
//    UIColor *color = nil;
//    if(bgimageV.image != nil)
//        color = [bgimageV.image mostColor];//这里请看这里<a href="\"http://www.cocoachina.com/bbs/read.php?tid=181490\"" target="\"_blank\"" onclick="\"return" checkurl(this)\"="" id="\"url_1\"">http://www.cocoachina.com/bbs/read.php?tid=181490</a>
//    else
//        color = bgimageV.backgroundColor;
//    if([self isLightColor:color])
//        [textLabel setTextColor:[UIColor blackColor]];
//    else
//        [textLabel setTextColor:[UIColor whiteColor]];
//}



//判断颜色是不是亮色
-(BOOL) isLightColor:(UIColor*)clr {
    CGFloat components[3];
    [self getRGBComponents:components forColor:clr];
    NSLog(@"%f %f %f", components[0], components[1], components[2]);
    
    CGFloat num = components[0] + components[1] + components[2];
    if(num < 382)
        return NO;
    else
        return YES;
}



//获取RGB值
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 bitmapInfo);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component];
    }
}

static NSMutableDictionary *colorImageDict;

+ (NSString *)keyForColor:(UIColor *)color
{
    if (color == nil){
        return @"";
    }
    
    const CGFloat *cpn = CGColorGetComponents(color.CGColor);
    NSInteger count = CGColorGetNumberOfComponents(color.CGColor);
    NSMutableString *ret = [[NSMutableString alloc] init];
    for (int i = 0; i < count; i ++) {
        int value = cpn[i] * 255;
        [ret appendFormat:@"%03d", value];
    }
    //    CGFloat alpha = CGColorGetAlpha(color.CGColor);
    //    [ret appendFormat:@"%f", alpha];
    //    PPDebug(@"<keyForColor> key = %@", ret);
    return ret;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    if (!colorImageDict) {
        colorImageDict = [[NSMutableDictionary alloc] init];
    }
    NSString* key = [self keyForColor:color];
    UIImage *image = [colorImageDict objectForKey:key];
    if (!image) {
        CGSize size = CGSizeMake(2, 2);
        UIGraphicsBeginImageContext(size);
        [color setFill];
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height));
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image = [image stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height/2];
        
        [colorImageDict setObject:image forKey:key];
    }
    return image;
}

@end
