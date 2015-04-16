//
//  UILineGridsView.m
//  BarrageClient
//
//  Created by Teemo on 15/3/3.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "UILineGridsView.h"

@implementation UILineGridsView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)initialize
{
    //TODO
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setLineCount:10.0f];
    [self setLineWidth:1.0f];
    [self setLineColor:[UIColor blackColor]];
    [self setUserInteractionEnabled:NO];
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGFloat diviCount = self.lineCount;
    CGFloat diviWidth = width /diviCount ;
    for (int i = 0; i <diviCount - 1; i++) {
        CGContextMoveToPoint(ctx, i*diviWidth +diviWidth, 0);
        CGContextAddLineToPoint(ctx, i*diviWidth +diviWidth, height);
        CGContextSetLineWidth(ctx, self.lineWidth);
        [self.lineColor set];
        CGContextStrokePath(ctx);
    }
    CGFloat diviHeight = height / diviCount;
    for (int i = 0; i <diviCount - 1; i++) {
        CGContextMoveToPoint(ctx, 0, i*diviHeight +diviHeight);
        CGContextAddLineToPoint(ctx, width, i*diviHeight +diviHeight);
        CGContextSetLineWidth(ctx, self.lineWidth);
        [self.lineColor set];
        CGContextStrokePath(ctx);
    }
}
@end
