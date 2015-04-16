//
//  HYCTagButton.m
//  BarrageClient
//
//  Created by HuangCharlie on 1/22/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "HYCTagButton.h"
#import "PPDebug.h"
#import "TagManager.h"
#import <POP.h>

@interface HYCTagButton ()

@property (nonatomic,strong) UIColor* currentColor;


@end

@implementation HYCTagButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithPbUserTag:(PBUserTag*)pbTag
            shouldFillBackground:(BOOL)shouldFill
                          target:(id)target
                       tapAction:(SEL)tapAction
                 longpressAction:(SEL)longpressAction

{
    self = [super init];
    
    //unique id
    self.tid = [pbTag tid];
    
    //title and title property
    NSString *text = [NSString stringWithFormat:@"%@ (%lu)",[pbTag name],(unsigned long)[[pbTag userIds]count]];
    [self setTitle:text forState:UIControlStateNormal];
    [self.titleLabel setFont:TAG_TEXT_FONT];
    
    //frame and size
    CGSize size = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:TAG_TEXT_FONT}];
    [self setFrame:CGRectMake(0, 0, size.width, size.height)];

    //layer property
    [self.layer setCornerRadius:size.height];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderWidth:1.5];

    //color and its changing situation
    self.currentColor = [UIColor decompressColorByInt:pbTag.color];
#pragma warning default color here
    self.currentColor = TAG_COLOR_GREEN;
    self.isSelected = shouldFill;
    [self setButtonBackgroundStyle];
    
    //action
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc]initWithTarget:target action:longpressAction];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:target action:tapAction];
    [self addGestureRecognizer:longPressGes];
    [self addGestureRecognizer:tapGes];
    
    return self;
}

-(void)setButtonBackgroundStyle
{
    [self.layer setBorderColor:[self.currentColor CGColor]];
    if(self.isSelected)
    {
        [self setBackgroundColor:self.currentColor];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:self.currentColor forState:UIControlStateNormal];
    }
}

-(void)shouldFillBackgroundColor:(BOOL)shouldFill
{
    self.isSelected = shouldFill;
    [self setButtonBackgroundStyle];
}


+ (BOOL)userByTag:(PBUserTag*)tag areContainedInSelectedUser:(NSArray*)selectedUser
{
    BOOL flag = YES;
    NSArray* array = [[TagManager sharedInstance]userListByTag:tag];
    if([array count]==0)
        flag = NO;
    for(PBUser* userByTag in array)
    {
        if(![selectedUser containsObject:userByTag])
            flag = NO;
    }
    return flag;
}

@end
