//
//  BadgeView.m
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "BadgeView.h"
#import "FontInfo.h"
#import "ColorInfo.h"

@implementation BadgeView

#define BadgeSize (25)
#define DEFAULT_MAX_NUMBER 99


- (void)baseInit
{
    self.userInteractionEnabled = NO;
    
    
    [self.titleLabel setFont:BADGE_FONT];
    
    
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // TODO set badge image
//    [self setBGImage:[[ShareImageManager defaultManager] badgeImage]];

    [self setMaxNumber:DEFAULT_MAX_NUMBER];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

+ (id)badgeViewWithNumber:(NSInteger)number
{
    BadgeView *badge = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, BadgeSize, BadgeSize)];
    [badge baseInit];
    [badge setNumber:number];
    return badge;
}

- (void)setNumber:(NSInteger)number
{
    _number = number;
    [self setHidden:NO];
    if (_number > self.maxNumber) {
        [self setTitle:@"N" forState:UIControlStateNormal];
    }else if(_number <= 0){
        //hide it
        [self setTitle:nil forState:UIControlStateNormal];
        [self setHidden:YES];
    }else{
        [self setTitle:[@(number) stringValue] forState:UIControlStateNormal];
    }
    
}

- (void)setMaxNumber:(NSInteger)maxNumber
{
    _maxNumber = maxNumber;
    [self setNumber:self.number];
}

- (void)setBGImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}


@end
