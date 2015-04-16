//
//  UILineLabel.m
//  BarrageClient
//
//  Created by Teemo on 15/2/9.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "UILineLabel.h"
#import "StringUtil.h"
#import "UIViewUtils.h"
#import <Masonry.h>

@implementation UILineLabel


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)initialize{
    self.lineHeight = 1.0f;
    self.padding = 0;
    self.lineColor = self.textColor;
    self.textAlignment = NSTextAlignmentCenter;
    self.lineType = UILINELABELTYPE_DOWN;
}
//add by charlie 2015 3 11
// Note:    this class UILineLabel should have another easier implementation,
//          like, the extended line can be add as a view, then just add subview
//          in different place in diff mode.


+(UILineLabel*)initWithText:(NSString*)text
                       Font:(UIFont*)font
                      Color:(UIColor*)color
                       Type:(UILineLabelType)tpye;
{
    CGSize textSize = [text sizeWithMyFont:font
                         constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                             lineBreakMode:NSLineBreakByWordWrapping];
    UILineLabel* lineLabel = [[UILineLabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width + 10, textSize.height + 10)];
    lineLabel.lineType = tpye;
    lineLabel.font = font;
    lineLabel.text = text;
    lineLabel.textColor = color;
    lineLabel.lineColor = color;
    return lineLabel;
}
-(void)setLineType:(UILineLabelType)lineType
{
    _lineType = lineType;
    [self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:rect];
    
    CGSize textSize = [self.text sizeWithMyFont:self.font
                              constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                  lineBreakMode:NSLineBreakByWordWrapping];
    
//    NSLog(@"neng :w  : %f  h: %f",textSize.width,textSize.height);
//    NSLog(@"neng : text %@",self.text);
    CGFloat strikeWidth = textSize.width;
    CGFloat strikeHeight = textSize.height;
    CGRect lineRect;
    CGFloat origin_x = 0;
    CGFloat origin_y = 0;
    
    
    if ([self textAlignment] == NSTextAlignmentRight) {
        
        origin_x = rect.size.width - strikeWidth;
        
    } else if ([self textAlignment] == NSTextAlignmentCenter) {
        
        origin_x = (rect.size.width - strikeWidth)/2 ;
        
    } else {
        
        origin_x = 0;
    }
    
    
    if (self.lineType == UILINELABELTYPE_UP) {
        
        origin_y =  (rect.size.height - strikeHeight)/2 - self.padding;
    }
    
    if (self.lineType == UILINELABELTYPE_MIDDLE) {
        
        origin_y =  rect.size.height / 2 - self.padding;
    }
    
    if (self.lineType == UILINELABELTYPE_DOWN) {//下画线
        
        origin_y = (rect.size.height + strikeHeight)/2 + self.padding;
    }
    
    lineRect = CGRectMake(origin_x , origin_y, strikeWidth, self.lineHeight);
    
    if (self.lineType != UILINELABELTYPE_NONE) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat R, G, B, A;
        UIColor *uiColor = self.lineColor;
        CGColorRef color = [uiColor CGColor];
        int numComponents = (int)CGColorGetNumberOfComponents(color);
        
        if( numComponents == 4)
        {
            const CGFloat *components = CGColorGetComponents(color);
            R = components[0];
            G = components[1];
            B = components[2];
            A = components[3];
            //            NSLog(@"neng :R : %f  G : %f  B : %f  A: %f",R,G,B,A);
            CGContextSetRGBFillColor(context, R, G, B, A);
            
        }
        else if(numComponents == 2)
        {
            const CGFloat *components = CGColorGetComponents(color);
            CGContextSetRGBFillColor(context, components[0], components[0], components[0],
                                     components[1]);
        }
        else
        {
            //What is this?
        }
        CGContextFillRect(context, lineRect);
    }
}


//- (void)drawTextInRect:(CGRect)rect{
//    [super drawTextInRect:rect];
//    
//    CGSize textSize = [self.text sizeWithMyFont:self.font
//                              constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
//                                  lineBreakMode:NSLineBreakByWordWrapping];
//
////    NSLog(@"neng :w  : %f  h: %f",textSize.width,textSize.height);
//    CGFloat strikeWidth = _textSize.width;
//    CGFloat strikeHeight = _textSize.height;
//    CGRect lineRect;
//    CGFloat origin_x = 0;
//    CGFloat origin_y = 0;
//    
//    
//    if ([self textAlignment] == NSTextAlignmentRight) {
//        
//        origin_x = self.bounds.size.width - strikeWidth;
//        
//    } else if ([self textAlignment] == NSTextAlignmentCenter) {
//        
//        origin_x = (self.bounds.size.width - strikeWidth)/2 ;
//        
//    } else {
//        
//        origin_x = 0;
//    }
//    
//    
//    if (self.lineType == UILINELABELTYPE_UP) {
//        
//        origin_y =  (self.bounds.size.height - strikeHeight)/2 - self.padding;
//    }
//    
//    if (self.lineType == UILINELABELTYPE_MIDDLE) {
//        
//        origin_y =  self.bounds.size.height / 2 - self.padding;
//    }
//    
//    if (self.lineType == UILINELABELTYPE_DOWN) {//下画线
//        
//        origin_y = (self.bounds.size.height + strikeHeight)/2 + self.padding;
//    }
//    
//    lineRect = CGRectMake(origin_x , origin_y, strikeWidth, self.lineHeight);
//    
//    if (self.lineType != UILINELABELTYPE_NONE) {
//        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGFloat R, G, B, A;
//        UIColor *uiColor = self.lineColor;
//        CGColorRef color = [uiColor CGColor];
//        int numComponents = (int)CGColorGetNumberOfComponents(color);
//        
//        if( numComponents == 4)
//        {
//            const CGFloat *components = CGColorGetComponents(color);
//            R = components[0];
//            G = components[1];
//            B = components[2];
//            A = components[3];
////            NSLog(@"neng :R : %f  G : %f  B : %f  A: %f",R,G,B,A);
//            CGContextSetRGBFillColor(context, R, G, B, A);
//            
//        }
//        else if(numComponents == 2)
//        {
//            const CGFloat *components = CGColorGetComponents(color);
//            CGContextSetRGBFillColor(context, components[0], components[0], components[0],
//                                     components[1]);
//        }
//        else
//        {
//            //What is this?
//        }
//        CGContextFillRect(context, lineRect);
//    }
//}


@end