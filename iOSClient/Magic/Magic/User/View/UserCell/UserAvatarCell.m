//
//  UserAvatarCell.m
//  BarrageClient
//
//  Created by 蔡少武 on 14/12/26.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "UserAvatarCell.h"
#import "Masonry.h"
#import "UIViewUtils.h"
#import "UserAvatarView.h"
#import "UserManager.h"
#import "ColorInfo.h"
#import "FontInfo.h"
#import "UserSettingController.h"
#import "TGRImageViewController.h"
#import "QNImageToolURL.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@implementation UserAvatarCell
{
    float nickNameLabelHeight;
    float nickNameLabelWidth;
}

#pragma mark - Default methods
- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Public methods
-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier
              user:(PBUser *)user
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if(self){
        [self loadData];
        self.user = user;

        //  判断背景图片是否存在
        if (self.user.avatarBg == nil || self.user.avatarBg.length == 0) {
            self.hasBackgroundImageView = NO;
        }else{
            self.hasBackgroundImageView = YES;
        }
        [self loadBackgroundImageView];
        [self loadAvatarView];
        [self loadNickNameLabel];
//        [self loadBackButton];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               user:(PBUser*)user
superViewController:(UIViewController *)superViewController
{
    self.superViewController = superViewController;
    __block UIViewController *currentController = self.superViewController;
    
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier user:user];
    
    self.userAvatarView.clickOnAvatarBlock = ^(void){
        NSURL *url = [NSURL URLWithString:user.avatar];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        TGRImageViewController *vc = [[TGRImageViewController alloc] initWithImage:image];
        [currentController presentViewController:vc animated:YES completion:nil];
    };
    return self;
}
#pragma mark - Private methods
- (void)loadBackgroundImageView
{
    //  背景
    self.backgroundImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.backgroundImageView];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
    }];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    
    if (self.hasBackgroundImageView == NO){
        self.backgroundImageView.image = [UIImage imageNamed:@"default_user_background_image"];
    }else{
        NSString *backgroundImgStr = self.user.avatarBg;
        //  user.avatarBg是url来的，得用这个来显示图片
        NSURL* url = [NSURL URLWithString:backgroundImgStr];
        UIImage* placeHolder = nil;
        [self.backgroundImageView sd_setImageWithURL:url
                              placeholderImage:placeHolder
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         PPDebug(@"load background image %@, error=%@", backgroundImgStr, error);
                                     }];
    }
}

- (void)loadAvatarView
{
    //  头像
    CGRect frame = CGRectMake(0, 0, AVATARVIEW_WIDTH_HEIGHT, AVATARVIEW_WIDTH_HEIGHT);
    self.userAvatarView = [[UserAvatarView alloc] initWithUser:self.user
                                                         frame:frame];
    [self.userAvatarView setBorderWidth:2];
    [self.contentView addSubview:self.userAvatarView];
    [self.userAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).with.multipliedBy(0.8);  //  guarantee user avatar view and nick name label are in the middle of content view.
        make.width.equalTo(@(AVATARVIEW_WIDTH_HEIGHT));
        make.height.equalTo(@(AVATARVIEW_WIDTH_HEIGHT));
    }];
}

- (void)loadNickNameLabel
{
    //  昵称
    self.nickNameLabel = [[UILabel alloc]init];
    self.nickNameLabel.textAlignment = NSTextAlignmentCenter;
    self.nickNameLabel.font = BARRAGE_LABEL_FONT;
    self.nickNameLabel.text = self.user.nick;
    [self.contentView addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userAvatarView.mas_bottom).with.offset(+COMMON_PADDING);
        make.centerX.equalTo(self.userAvatarView);
    }];
    if (self.hasBackgroundImageView == NO) {
        self.nickNameLabel.textColor = BARRAGE_LABEL_COLOR;              //  昵称颜色
   }else {
       //  改变昵称颜色
       self.nickNameLabel.textColor = [UIColor whiteColor];
    }
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickNickNameLabel)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.nickNameLabel addGestureRecognizer:tapGestureRecognizer];
    self.nickNameLabel.userInteractionEnabled = YES;
}
- (void)loadBackButton
{
    self.backButton = [[UIButton alloc]init];
    [self.contentView addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.height.equalTo(@(buttonWidthHeight));
        make.width.equalTo(@(buttonWidthHeight));
    }];
    [self.backButton setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackButton:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.backButton addGestureRecognizer:tapGestureRecognizer];
}
- (void)loadData
{
    buttonWidthHeight = 44.0f;
}
#pragma mark - Utils
- (void)clickBackButton:(id)sender
{
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    UINavigationController* currentNavigationController = delegate.currentNavigationController;
    [currentNavigationController popViewControllerAnimated:YES];
}
- (void)clickNickNameLabel
{
    if (self.clickNickNameLabelBlock) {
        EXECUTE_BLOCK(self.clickNickNameLabelBlock);
    }else{
        
    }
}
@end
