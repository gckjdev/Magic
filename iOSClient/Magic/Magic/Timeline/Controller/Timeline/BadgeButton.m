//
//  BadgeButton.m
//  BarrageClient
//
//  Created by Teemo on 15/3/25.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "BadgeButton.h"
#import "UIImageUtil.h"
#import "StringUtil.h"

@implementation BadgeButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        [self setBackgroundImage:[UIImage resizableImage:@"new_message_bg"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return self;
}
- (void)setBadgeValue:(NSString *)badgeValue
{
    //    _badgeValue = badgeValue;
    _badgeValue = [badgeValue copy];
    
    if (badgeValue) {
        self.hidden = NO;
        // 设置文字
        [self setTitle:badgeValue forState:UIControlStateNormal];
        
        // 设置frame
        CGRect frame = self.frame;
        CGFloat badgeH = self.currentBackgroundImage.size.height;
        CGFloat badgeW = self.currentBackgroundImage.size.width;
        CGSize badgeSize =[badgeValue sizeWithMyFont:self.titleLabel.font
                                   constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                       lineBreakMode:NSLineBreakByWordWrapping];
        if (badgeValue.length > 1) {
            // 文字的尺寸
            badgeW = badgeSize.width + 12;
        }
        if (badgeValue.length == 1) {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, badgeSize.width/2-2 , 0, 0);
        }
        
        frame.size.width = badgeW;
        frame.size.height = badgeH;
        self.frame = frame;
    } else {
        self.hidden = YES;
    }
}
@end
