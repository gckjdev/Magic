//
//  BCButton.m
//  BarrageClient
//
//  Created by Teemo on 15/3/31.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "BCButton.h"

@implementation BCButton

+(instancetype)buttonWithImage:(UIImage*)image
                         title:(NSString*)title
                  imagePercent:(CGFloat)imagePercent
{
    BCButton *button = [[BCButton alloc]init];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.imagePercent = imagePercent;
    [button.titleLabel setTextColor:[UIColor blackColor]];
    return button;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = self.frame.size.height*_imagePercent;
    CGFloat imageX = contentRect.size.width - imageW;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 0;
    CGFloat titleX = 0;
    CGFloat titleW = contentRect.size.width - self.frame.size.height*_imagePercent;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
@end
