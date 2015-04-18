//
//  UIImage.m
//  02-qq
//
//  Created by Teemo on 15/1/12.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+(UIImage*)resizableImage:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.5;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}
@end
