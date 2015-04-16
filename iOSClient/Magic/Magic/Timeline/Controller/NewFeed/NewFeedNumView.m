//
//  NewFeedNumView.m
//  BarrageClient
//
//  Created by Teemo on 15/3/25.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "NewFeedNumView.h"
#import "FontInfo.h"
#import "BadgeButton.h"
#import "BadgeView.h"
#import "ColorInfo.h"

@interface NewFeedNumView ()
@property (nonatomic,strong) UIButton   *myBGButton;
@property (nonatomic,strong) UILabel    *myNumLabel;
@property (nonatomic, strong) PBMyNewFeed    *mynewFeed;
@property (nonatomic,strong) BadgeView   *badgeButton;
@end
@implementation NewFeedNumView

+(instancetype)initWithMyNewFeed:(PBMyNewFeed*)newFeed;
{
    NewFeedNumView *newFeedNumView = [[NewFeedNumView alloc]init];
    newFeedNumView.mynewFeed = newFeed;
    return newFeedNumView;
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
-(void)updateView:(PBMyNewFeed*)newFeed
{
    _mynewFeed = newFeed;
    if (_mynewFeed.type == PBMyNewFeedTypeTypeNewFeedToMe) {
        
        [_myNumLabel setHidden:NO];
        [_myBGButton setHidden:NO];
        [_badgeButton setHidden:YES];
    }else{
        [_myNumLabel setHidden:YES];
        [_myBGButton setHidden:YES];
        [_badgeButton setHidden:NO];
        [_badgeButton setNumber:newFeed.count];

    }
    
}
-(void)initView{
    
    
    _myBGButton = [[UIButton alloc]init];
    [_myBGButton setImage:[UIImage imageNamed:@"new_message_tag"] forState:UIControlStateNormal];
    [_myBGButton setUserInteractionEnabled:NO];
    [self addSubview:_myBGButton];
    
    _myNumLabel = [[UILabel alloc]init];
    _myNumLabel.textAlignment = NSTextAlignmentCenter;
    _myNumLabel.font  = CELL_SMALL_FONT;
    _myNumLabel.textColor = [UIColor whiteColor];
    _myNumLabel.text = @"NEW";
    [self addSubview:_myNumLabel];
    
    _badgeButton = [[BadgeView alloc]init];
    [_badgeButton setBackgroundColor: COLOR_GREEN_TAG];
    [_badgeButton setMaxNumber:99];
    _badgeButton.layer.cornerRadius = 9;
    _badgeButton.titleLabel.font = CELL_SUB_FONT;
    [self addSubview:_badgeButton];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _myBGButton.frame = self.bounds;
    _badgeButton.frame = CGRectMake(0, 5,30, 18);
    
    
    CGRect frame = self.bounds;
    frame.origin.x += 3;
    _myNumLabel.frame = frame;
}
@end
