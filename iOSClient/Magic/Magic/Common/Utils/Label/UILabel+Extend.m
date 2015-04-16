//
//  UILabel+Extend.m
//  Draw
//
//  Created by 王 小涛 on 13-8-15.
//
//

#import "UILabel+Extend.h"
#import "StringUtil.h"
#import "UIViewUtils.h"

@implementation UILabel (Extend)

- (void)wrapTextWithConstrainedSize:(CGSize)constrainedSize{
    
    NSString *text = [self.text copy];
    UIFont *font = self.font;
    NSLineBreakMode lineBreakMode = self.lineBreakMode;
    
    CGSize size = [text sizeWithMyFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
    
    [self updateWidth:size.width];
    [self updateHeight:size.height];
}

- (CGRect)autoFitFrame
{
    CGSize size = self.frame.size;
    size.height = INT_MAX;
    [self wrapTextWithConstrainedSize:size];
    [self updateWidth:size.width];
    return self.frame;
}

@end
