//
//  UIColor+UIColorExt.h
//  Draw
//
//  Created by Kira on 13-3-28.
//
//

#import <UIKit/UIKit.h>

#define OPAQUE_COLOR(A, B, C)   ([UIColor colorWithIntegerRed:A green:B blue:C alpha:255])
#define ALPHA_COLOR(R, G, B, A) ([UIColor colorWithIntegerRed:R green:G blue:B alpha:A*100])

#define COLOR255(R, G, B, A)    ([UIColor colorWithIntegerRed:R green:G blue:B alpha:A])
#define COLOR1(R, G, B, A)      ([UIColor colorWithRed:R green:G blue:B alpha:A])


@interface UIColor (UIColorExt)

+ (UIColor *)colorWithIntegerRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(NSUInteger)alpha;

//frome  r g b alpha to int, which is called compress
+ (NSUInteger)compressColorWithRed:(CGFloat)red
                             green:(CGFloat)green
                              blue:(CGFloat)blue
                             alpha:(CGFloat)alpha;

+ (NSUInteger)compressColor:(UIColor*)color;

//from int to r g b alpha, which is called decompress
+ (void)decompressColor:(NSUInteger)intColor
                    red:(CGFloat*)red
                  green:(CGFloat*)green
                   blue:(CGFloat*)blue
                  alpha:(CGFloat*)alpha;

//from int to uicolor
+ (UIColor*)decompressColorByInt:(NSUInteger)intColor;

@end
