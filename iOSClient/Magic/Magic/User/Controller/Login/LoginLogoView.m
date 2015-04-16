//
//  LoginLogoView.m
//  BarrageClient
//
//  Created by Teemo on 15/3/31.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "LoginLogoView.h"
#import "FeedBarrageView.h"
#import "UIImageView+WebCache.h"
#import "ColorInfo.h"
#import "Masonry.h"

#define LOGOIMAGE_CENTER_Y_OFFSET 30.0f

@interface LoginLogoView ()
@property (nonatomic,strong) Feed   *feed;
@property (nonatomic,strong) FeedBarrageView   *feedView;
@property (nonatomic,strong) UIImageView   *logoView;
@property (nonatomic,strong) UIImageView   *maskView;
@property (nonatomic,strong) UILabel   *textLabel;
@end


@implementation LoginLogoView

+(instancetype)viewInitWithFeed:(Feed*)feed
                          frame:(CGRect)frame
{
    LoginLogoView *view = [[LoginLogoView alloc]initWithFrame:frame];
    [view updateViewWithFeed:feed];
    return view;
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
//    [self setupFeedView];
//    [self setupMaskView];
//    [self setupLogoView];
//    [self setupTextLabel];
    [self setBackgroundImageView:@"login_bg"];
}
-(void)updateViewWithFeed:(Feed*)feed
{
    self.feed = feed;
    
    NSURL* url = [NSURL URLWithString:self.feed.feedBuilder.image];
    
    [self.feedView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        PPDebug(@"image(%@) load, error(%@)", self.feed.feedBuilder.image, error);
        
        [self.feedView setImage:image];
        [self.feedView addBarrageWithActions:self.feed.feedBuilder.actions];
        [self.feedView play];
    }];
}
-(void)setupTextLabel{
    _textLabel = [[UILabel alloc]init];
    _textLabel.text = @"任性发图 愉快弹幕";
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.font = [UIFont boldSystemFontOfSize:18];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200,50));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(LOGOIMAGE_CENTER_Y_OFFSET);
    }];
    
}
-(void)setupLogoView{
    _logoView = [[UIImageView alloc]init];
    [_logoView setImage:[UIImage imageNamed:@"logo_demo"] ];
    [self addSubview:_logoView];
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80,80));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(-LOGOIMAGE_CENTER_Y_OFFSET);
    }];
}
-(void)setupMaskView{
    _maskView = [[UIImageView alloc]init];
    [_maskView setBackgroundColor:COLOR255(0,0,0,80)];

    [self addSubview:_maskView];
}
-(void)setupFeedView{
   
    self.feedView = [FeedBarrageView barrageViewInView:self frame: self.bounds];

    [self addSubview:self.feedView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.feedView.frame = self.bounds;
//    _maskView.frame = self.bounds;
//    _logoView.frame = self.bounds;
}
@end
