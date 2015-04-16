//
//  UIColor+UIColorExt.m
//  Draw
//
//  Created by Kira on 13-3-28.
//
//

#import "UIColor+UIColorExt.h"

@implementation UIColor (UIColorExt)

+ (UIColor *)colorWithIntegerRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(NSUInteger)alpha
{
    return [UIColor colorWithRed:red/255.0
                           green:green/255.0
                            blue:blue/255.0
                           alpha:alpha/255.0];
}

// new compress
+ (NSUInteger)compressColorWithRed:(CGFloat)red
                             green:(CGFloat)green
                              blue:(CGFloat)blue
                             alpha:(CGFloat)alpha
{
    NSUInteger ret = (NSUInteger)(alpha * 255.0) +
    ((NSUInteger)(blue * 255.0) << 8) +
    ((NSUInteger)(green * 255.0) << 16) +
    ((NSUInteger)(red * 255.0) << 24);
    return ret;
}

+ (NSUInteger)compressColor:(UIColor*)color
{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    return [self compressColorWithRed:r
                                green:g
                                 blue:b
                                alpha:a];
}

// new decompress, with 8 bits for alpha
+ (void)decompressColor:(NSUInteger)intColor
                    red:(CGFloat*)red
                  green:(CGFloat*)green
                   blue:(CGFloat*)blue
                  alpha:(CGFloat*)alpha
{
    *alpha = (intColor % (1<<8)) / 255.0;
    *blue = ((intColor >> 8) % (1<<8)) / 255.0;
    *green = ((intColor >> 16) % (1<<8)) / 255.0;
    *red = ((intColor >> 24) % (1<<8)) / 255.0;
}

+ (UIColor*)decompressColorByInt:(NSUInteger)intColor
{
    CGFloat alpha = (intColor % (1<<8)) / 255.0;
    CGFloat blue = ((intColor >> 8) % (1<<8)) / 255.0;
    CGFloat green = ((intColor >> 16) % (1<<8)) / 255.0;
    CGFloat red = ((intColor >> 24) % (1<<8)) / 255.0;

    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return color;
}

@end
