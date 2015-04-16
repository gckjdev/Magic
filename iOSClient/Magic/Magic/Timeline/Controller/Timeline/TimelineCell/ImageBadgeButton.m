//
//  ImageBadgeButton.m
//  BarrageClient
//
//  Created by Teemo on 15/3/26.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "ImageBadgeButton.h"

#import "Masonry.h"

@interface ImageBadgeButton()
@property (nonatomic,strong) BadgeButton   *badgeButton;
@end
@implementation ImageBadgeButton

+(instancetype)initWithFrame:(CGRect)frame
                       image:(NSString*)image
                      target:(id)target
                      action:(SEL)action
{
    ImageBadgeButton *btn = [[ImageBadgeButton alloc]initWithFrame:frame];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)setBadgeValue:(NSString*)value
{
    _badgeButton.badgeValue = value;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    _badgeButton = [[BadgeButton alloc]initWithFrame:CGRectMake(22, -4,10, 10)];
    [self addSubview:_badgeButton];
}
-(void)setImageEdgeInsets:(UIEdgeInsets)insets
{
    [super setImageEdgeInsets:insets];
    CGRect frame = _badgeButton.frame;
    frame.origin.y +=insets.top;
    frame.origin.x +=insets.left;
    _badgeButton.frame = frame;
}
@end
