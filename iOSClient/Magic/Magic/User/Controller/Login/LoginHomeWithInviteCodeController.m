//
//  LoginHomeWithInviteCodeController.m
//  BarrageClient
//
//  Created by pipi on 14/12/27.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "LoginHomeWithInviteCodeController.h"
#import "Masonry.h"
#import "EnterInviteCodeController.h"
#import "LoginController.h"
#import "FontInfo.h"
#import "ColorInfo.h"
#import "UserService.h"
#import "UIViewUtils.h"
#import "UIViewController+Utils.h"
#import "AppDelegate.h"
#import "UILineLabel.h"
#import "ViewInfo.h"
#import "LoginLogoView.h"

const float kBottomHolderViewHeight = 152.0f;
const float kLabelHeight = 30.0f;
const float kLogoHeightWidth = 80.0f;
const float kLabelCenterXPadding = 28.0f;

@interface LoginHomeWithInviteCodeController ()

@property (nonatomic,strong)UILineLabel *directLoginLabel;
@property (nonatomic,strong)UILabel *textLabel; //  for “已有账号”
@property (nonatomic,strong)UIImageView *backgroundImageView;
@property (nonatomic,strong)UIImageView *logoImageView;
@property (nonatomic,strong)UILabel *sloganLabel;
@property (nonatomic,strong)UIButton *invitedRegisterBtn;
@property (nonatomic,strong)UIView *bottomHolderView;
@property (nonatomic,strong)UIView *tempHolderViewInBottom; // temp holder view in bottom holder view,in order to guarantee what inside are placed in the middle.
@property (nonatomic,strong) LoginLogoView   *logoView;

@end

@implementation LoginHomeWithInviteCodeController

#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self hideTabBar];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self showTabBar];
    [super viewDidDisappear:animated];
}

-(void)loadView{
    [super loadView];
//    [self loadTopHolderView];
    [self setupLogoView];
    [self loadBottomHolderView];
    
}

#pragma mark - Private methods

- (void)setupLogoView{
    _logoView = [LoginLogoView viewInitWithFeed:nil
                                    frame:CGRectMake(0, 0, kScreenWidth, LOGOVIEW_HIEGHT)];

    [self.view addSubview:_logoView];
}
- (void)loadTopHolderView
{
    self.backgroundImageView = [[UIImageView alloc]init];
    self.backgroundImageView.image = [UIImage imageNamed:@""];  //  TODO
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(self.view).with.offset(-(kBottomHolderViewHeight));
        make.width.equalTo(self.view);
    }];
}

- (void)loadBottomHolderView
{
    self.bottomHolderView = [[UIView alloc]init];
    [self.view addSubview:self.bottomHolderView];
    [self.bottomHolderView setBackgroundColor:BARRAGE_BG_WHITE_COLOR];
    [self.bottomHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view);
        make.height.equalTo(@(kScreenHeight - LOGOVIEW_HIEGHT));
    }];
    [self loadTempHolderViewInBottom];
}

- (void)loadTempHolderViewInBottom
{
    self.tempHolderViewInBottom = [[UIView alloc]init];
    
    [self.bottomHolderView addSubview:self.tempHolderViewInBottom];
    [self.tempHolderViewInBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomHolderView);
        make.width.equalTo(self.bottomHolderView);
        make.height.equalTo(self.bottomHolderView).with.dividedBy(2);
    }];
    
    self.invitedRegisterBtn = [UIView defaultTextButton:@"邀请码注册"
                                              superView:self.tempHolderViewInBottom];
    [self.invitedRegisterBtn addTarget:self
                                action:@selector(clickInvitedRigisterBtn:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    [self.invitedRegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tempHolderViewInBottom.mas_centerY);
    }];
    
    //  Modified by Teemo
    /**
     *   提示登录文字
     **/
    NSString* prefix = @"已有账号? ";
    NSString* other = @"直接登录";
    
    CGFloat padding = kLabelCenterXPadding;
    self.textLabel = [[UILabel alloc]init];
    self.textLabel.text = prefix;
    self.textLabel.font = BARRAGE_LITTLE_LABEL_FONT;
    [self.textLabel setTextColor:BARRAGE_TEXTFIELD_COLOR ];
    [self.tempHolderViewInBottom addSubview:self.textLabel];

    [self.textLabel setUserInteractionEnabled:YES];  //设置textLabel接受事件
    [self.textLabel addTapGestureWithTarget:self selector:@selector(clickDirectLoginLabel:)];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tempHolderViewInBottom.mas_centerX).with.offset(-padding);
        make.height.equalTo(@(kLabelCenterXPadding));
        make.bottom.equalTo(self.tempHolderViewInBottom);
    }];

    //init dierect login label，modified by charlie
    self.directLoginLabel = [UILineLabel initWithText:other
                                                 Font:BARRAGE_LITTLE_LABEL_FONT
                                                Color:BARRAGE_LABEL_RED_COLOR                                                  Type:UILINELABELTYPE_DOWN];
 
    [self.tempHolderViewInBottom addSubview:self.directLoginLabel];
    [self.directLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tempHolderViewInBottom.mas_centerX).with.offset(+padding);
        make.height.equalTo(@(kLabelHeight));
        make.centerY.equalTo(self.textLabel);
    }];
    self.directLoginLabel.padding = 0.0f;
    [self.directLoginLabel setUserInteractionEnabled:YES];  //设置directLoginLabel接受事件
    [self.directLoginLabel addTapGestureWithTarget:self selector:@selector(clickDirectLoginLabel:)];
}

#pragma mark - Utils
- (void)clickInvitedRigisterBtn:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    EnterInviteCodeController *vc = [[EnterInviteCodeController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickDirectLoginLabel:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    LoginController *vc = [[LoginController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
