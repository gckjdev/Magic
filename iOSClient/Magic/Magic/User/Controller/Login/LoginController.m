//
//  LoginController.m
//  BarrageClient
//
//  Created by pipi on 14/12/4.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "LoginController.h"
#import "Masonry.h"
#import "UIViewUtils.h"
#import "UserService.h"
#import "InviteCodeManager.h"
#import "UILabel+Touchable.h"
#import "StringUtil.h"
#import "LoginByEmailController.h"
#import "LoginByPhoneController.h"
#import "AppDelegate.h"
#import "UserTimelineFeedController.h"

#define TITLE_QQ_LOGING     @"QQ登录"
#define TITLE_WEIXIN_LOGING @"微信登录"
#define TITLE_SINA_LOGING   @"微博登录"
#define TITLE_EMAIL_LOGING  @"邮箱登录"
#define TITLE_MOBILE_LOGING @"手机登录"

const float kSelectionTipsLabelTopPadding = 40;
const float kLoginMenuTopPadding = 31;

@interface LoginController ()

@property (nonatomic,strong)UILabel *selectionTipsLabel;
@property (nonatomic,strong)UIButton *qqLoginBtn;
@property (nonatomic,strong)UIButton *xinlangWeiboLoginBtn;
@property (nonatomic,strong)UIButton *emailLoginBtn;

@end

@implementation LoginController

#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:BARRAGE_BG_COLOR];
    [self loadSelectionTipsLabel];
    [self loadLoginMenu];
}

#pragma  mark - Private methods

- (void)loadSelectionTipsLabel
{
    self.selectionTipsLabel = [UILabel defaultLabel:@"请选择相应的登录方式"
                                          superView:self.view];
    [self.selectionTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(+kSelectionTipsLabelTopPadding);
    }];
}
//  加载登录菜单
-(void)loadLoginMenu
{
    //  QQ
    UIButton *qqBtn = [UIButton registerStyleWithsuperView:self.view
                                                     title:TITLE_QQ_LOGING
                                                      icon:@"qq.png"
                                                   bgColor:BARRAGE_QQ_BTN_BG_COLOR];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_selectionTipsLabel.mas_bottom).with.offset(+kLoginMenuTopPadding);
    }];
    [qqBtn addTarget:self
              action:@selector(clickQQBtn:)
    forControlEvents:UIControlEventTouchUpInside]; //  点击QQ登录按钮
    
    //  Sina
    UIButton *sinaBtn = [UIButton registerStyleWithsuperView:self.view
                                                     title:TITLE_SINA_LOGING
                                                      icon:@"sina.png"
                                                   bgColor:BARRAGE_SINA_BTN_BG_COLOR];
    [sinaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qqBtn.mas_bottom).with.offset(+COMMON_MARGIN_OFFSET_Y);
    }];
    [sinaBtn addTarget:self
                 action:@selector(clickSinaBtn:)
       forControlEvents:UIControlEventTouchUpInside];   //  点击新浪微博登录按钮
    
    //  Weixin
    UIButton *weixinBtn = [UIButton registerStyleWithsuperView:self.view
                                                       title:TITLE_WEIXIN_LOGING
                                                        icon:@"weixin.png"
                                                     bgColor:BARRAGE_WEIXIN_BTN_BG_COLOR];
    [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sinaBtn.mas_bottom).with.offset(+COMMON_MARGIN_OFFSET_Y);
    }];
    [weixinBtn addTarget:self
                   action:@selector(clickWeixinBtn:)
         forControlEvents:UIControlEventTouchUpInside]; //  点击微信登录按钮
    
    //  Email
    UIButton *emailBtn = [UIButton registerStyleWithsuperView:self.view
                                                         title:TITLE_EMAIL_LOGING
                                                          icon:@"email.png"
                                                       bgColor:BARRAGE_EMAIL_BTN_BG_COLOR];
    
    [emailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weixinBtn.mas_bottom).with.offset(+COMMON_MARGIN_OFFSET_Y);
    }];
    [emailBtn addTarget:self
                  action:@selector(clickEmailBtn:)
        forControlEvents:UIControlEventTouchUpInside];  //  点击email登录按钮
    
    //  手机
    UIButton *mobileBtn = [UIButton registerStyleWithsuperView:self.view
                                                        title:TITLE_MOBILE_LOGING
                                                         icon:@"phone.png"
                                                      bgColor:BARRAGE_PHONE_BTN_BG_COLOR];
    [mobileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailBtn.mas_bottom).with.offset(+COMMON_MARGIN_OFFSET_Y);
    }];
    [mobileBtn addTarget:self
                 action:@selector(clickMobileBtn:)
       forControlEvents:UIControlEventTouchUpInside];   //  点击手机登录按钮
    
}

#pragma mark - Utils

- (void)loginBySns:(ShareType)shareType
{
    [[UserService sharedInstance] loginUserBySns:shareType
                                        callback:^(PBUser *pbUser, NSError *error) {
                                            
                                            if (error){
                                                POST_ERROR(@"登录失败，请无视这个即将被取代的消息");
                                            }
                                            else{
                                                POST_SUCCESS_MSG(@"登录成功，欢迎回到神秘星球世界");
                                                [[AppDelegate sharedInstance] showNormalHome];
                                                // post notification to UserTimelineController
                                                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIMELINE_RELOAD_ALL_ROWS
                                                                                                    object:nil];
                                            }
                                            
                                        }];
    
}

//  点击QQ登录按钮
-(void)clickQQBtn:(id)sender
{
    [self loginBySns:ShareTypeQQ];
}

//  点击新浪微博登录按钮
-(void)clickSinaBtn:(id)sender
{
    [self loginBySns:ShareTypeSinaWeibo];
}

//  点击微信登录按钮
-(void)clickWeixinBtn:(id)sender
{
    [self loginBySns:ShareTypeWeixiSession];
}

//  点击email登录按钮
-(void)clickEmailBtn:(id)sender
{
    LoginByEmailController *vc = [[LoginByEmailController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//  点击手机登录按钮
-(void)clickMobileBtn:(id)sender
{
    LoginByPhoneController *vc = [[LoginByPhoneController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
