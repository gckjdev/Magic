//
//  InviteCodePassController.m
//  BarrageClient
//
//  Created by pipi on 14/12/27.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//
//  add by Shaowu Cai on 15/1/25

#import "InviteCodePassController.h"
#import "Masonry.h"
#import "UIViewUtils.h"
#import "UserService.h"
#import "InviteCodeManager.h"
#import "UILabel+Touchable.h"
#import "StringUtil.h"
#import "RegisterByEmailController.h"
#import "AppDelegate.h"
#import "LoginView.h"
#import "UserManager.h"
#import "PhoneRegisterView.h"
#import "SMSManager.h"
#import "RegisterByPhoneVerifyCotroller.h"
#import "SMSManager.h"
#import "RegisterCodeManager.h"

#define kPadding 20
#define kBtnPadding 16  //  按钮间距
#define kLoginBtnPadding 14 //  登录方式按钮间距

#define TITLE_QQ_REGISTER       @"QQ注册"
#define TITLE_EMAIL_REGISTER    @"邮箱注册"
#define TITLE_WEIXIN_REGISTER   @"微信注册"
#define TITLE_SINA_REGISTER     @"微博注册"

@interface InviteCodePassController ()

//  将整个页面划分成两个子view
@property (nonatomic,strong)UIView *superViewOne;
@property (nonatomic,strong)UIView *superViewTwo;
@property (nonatomic,strong)UITextField *mobileTextField;   //  手机号
@property (nonatomic,strong)UITextField *passwordTextField; //  密码
@property (nonatomic,strong)UITextField *verifyTextField;
@property (nonatomic,strong)UIButton *registerSubmitBtn;    //  注册提交按钮
@property (nonatomic,strong)UILabel *selectionTipsLabel;    //  其他注册方式Tips
@property (nonatomic,strong)UIButton *pullBtn;  //  下拉按钮
//  4种注册方式
@property (nonatomic,strong)UIButton *qqBtn;
@property (nonatomic,strong)UIButton *sinaBtn;
@property (nonatomic,strong)UIButton *weixinBtn;
@property (nonatomic,strong)UIButton *emailBtn;
@property (nonatomic,strong)NSMutableArray *constraintArray;
@property (nonatomic,strong)UIView *pullDownMenuView;
@property (nonatomic,assign)BOOL isAnimation;
@end

@implementation InviteCodePassController
#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView
{
    [super loadView];
    self.title = @"注册";
    self.view.backgroundColor = BARRAGE_BG_COLOR;
    [self loadSuperViewOne];
    [self loadSuperViewTwo];
}
#pragma mark - Private methods
- (void)loadSuperViewOne
{
    //  子页面1
    self.superViewOne = [[UIView alloc]init];
    [self.view addSubview:self.superViewOne];
    [self.superViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(+(COMMON_TEXTFIELD_TOP_SPACING));
        make.height.equalTo(self.view).with.multipliedBy(0.35);
        make.width.equalTo(self.view);
    }];

    LoginView *loginView = [[LoginView alloc]initWithAccount:@"请输入手机号" password:@"请输入密码"  button:@"提交" controller:self buttonAction:@selector(clickSubmitBtn:)];
        
    loginView.accountTextField.keyboardType = UIKeyboardTypeNumberPad;   //  键盘样式
    
    [loginView.accountTextField resignFirstResponder];
    [loginView.passwordTextField resignFirstResponder];
    
    [self.superViewOne addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.superViewOne);
        make.width.equalTo(self.superViewOne);
        make.height.equalTo(self.superViewOne);
    }];

    self.mobileTextField = loginView.accountTextField;
    self.passwordTextField = loginView.passwordTextField;

    //add by neng, get register data
    _mobileTextField.text = [[RegisterCodeManager sharedInstance]getCurrentPhoneNum];
    _passwordTextField.text =  [[RegisterCodeManager sharedInstance]getCurrentPassword];
}
// 加载子页面2
- (void)loadSuperViewTwo
{
    //  子页面2
    self.superViewTwo = [[UIView alloc]init];
    [self.view addSubview:self.superViewTwo];
    [self.superViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.superViewOne.mas_bottom);
        make.height.equalTo(self.view).with.multipliedBy(0.65);
        make.width.equalTo(self.view);
    }];
    //  注册方式选择tips
    self.selectionTipsLabel = [UILabel defaultLabel: @"其他注册方式"
                                          superView:_superViewTwo];
    [self.selectionTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.superViewTwo).with.offset(+COMMON_MARGIN_OFFSET_Y);
    }];
    [self.selectionTipsLabel enableTapTouch:self
                                   selector:@selector(clickSelectonTipsLabel:)];
    //  下拉按钮
    self.pullBtn = [UIButton registerStyleWithsuperView:_superViewTwo
                                            normalBgImg:@"pull_down.png"
                                       highlightedBgImg:nil];
    [self.pullBtn setBackgroundImage:[UIImage imageNamed:@"pull_back.png"]
                            forState:UIControlStateSelected];
    [self.pullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectionTipsLabel.mas_bottom);
    }];
    [self.pullBtn addTarget:self
                     action:@selector(clickPullBtn:)
           forControlEvents:UIControlEventTouchUpInside]; //  点击下拉按钮的事件
    
    self.constraintArray = [NSMutableArray arrayWithObjects:0];
}
//  加载其他注册方式下拉列表
-(void)showPullDownMenu
{
    NSArray *registerButtonIconArray = @[@"qq.png",@"sina.png",@"weixin.png",@"email.png"];
    NSArray *registerButtonTitleArray = @[TITLE_QQ_REGISTER,
                                          TITLE_SINA_REGISTER,
                                          TITLE_WEIXIN_REGISTER,
                                          TITLE_EMAIL_REGISTER];
    NSArray *registerButtonColorArray = @[BARRAGE_QQ_BTN_BG_COLOR,
                                          BARRAGE_SINA_BTN_BG_COLOR,
                                          BARRAGE_WEIXIN_BTN_BG_COLOR,
                                          BARRAGE_EMAIL_BTN_BG_COLOR];
    NSUInteger buttonCount = [registerButtonTitleArray count];
    
    CGFloat pullDownMenuViewHeight = REGISETER_LOGIN_STYLE_BUTTON_HEIGHT * buttonCount + kLoginBtnPadding * (buttonCount - 1);
    self.pullDownMenuView = [[UIView alloc]init];
    [self.view addSubview:self.pullDownMenuView];
    [self.pullDownMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pullBtn.mas_bottom).with.offset(+2);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@(pullDownMenuViewHeight));
    }];
    [self.pullDownMenuView setBackgroundColor:BARRAGE_BG_COLOR];
    
    NSMutableArray *registerButtonArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < buttonCount; i++) {
        UIButton *registerButton = [UIButton registerStyleWithsuperView:self.pullDownMenuView
                                                                  title:registerButtonTitleArray[i]
                                                                   icon:registerButtonIconArray[i]
                                                                bgColor:registerButtonColorArray[i]];
        if (i == 0) {
            [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.pullDownMenuView);
            }];
        }else
        {
            [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
                UIButton *preRegisterButton = registerButtonArray[i-1];
                make.top.equalTo(preRegisterButton.mas_bottom).with.offset(+kLoginBtnPadding);
            }];
        }
        [registerButtonArray  addObject:registerButton];
    }
    
    self.qqBtn = registerButtonArray[0];
    self.sinaBtn = registerButtonArray[1];
    self.weixinBtn = registerButtonArray[2];
    self.emailBtn = registerButtonArray[3];
    
    [self.qqBtn addTarget:self
                   action:@selector(clickQQBtn:)
         forControlEvents:UIControlEventTouchUpInside]; //  点击QQ注册按钮
    
    [self.sinaBtn addTarget:self
                     action:@selector(clickSinaBtn:)
           forControlEvents:UIControlEventTouchUpInside];   //  点击新浪微博注册按钮
    
    [self.weixinBtn addTarget:self
                       action:@selector(clickWeixinBtn:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.emailBtn addTarget:self
                      action:@selector(clickEmailBtn:)
            forControlEvents:UIControlEventTouchUpInside];  //  点击email注册按钮
}
#pragma mark - UITextFieldDelegate
//  点击“return”或者“Done”执行的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _mobileTextField) {
        return [self.passwordTextField becomeFirstResponder];
    }else if(textField == _passwordTextField){
        [self clickSubmitBtn:nil];
        return [textField resignFirstResponder];    
    }
    else{
        return YES;
    }
}

//  textField完成编辑之后
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _mobileTextField) {
        
        //add by neng,set register
        [[RegisterCodeManager sharedInstance]setCurrentPhoneNum:textField.text];
        
        [self.passwordTextField becomeFirstResponder];
    }else if (textField == _passwordTextField)
    {
        //add by neng,set register
        [[RegisterCodeManager sharedInstance]setCurrentPassword:textField.text];
        
        [textField resignFirstResponder];
    }
}
#pragma mark - Utils
//  验证密码
- (BOOL)validatePassword:(NSString *)password
{
    if (password == nil || password.length == 0) {
        return NO;
    }else
    {
        return YES;
    }
}

//  点击下拉按钮时执行
-(void)clickPullBtn:(id)sender
{
    [self.mobileTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self showPullDownMenu];
//    [self beginPullDownAnimation];
    [self easeOutInAnimation];

}
//  点击“其他注册方式”时执行
-(void)clickSelectonTipsLabel:(id)sender
{
    [self clickPullBtn:sender];
}

- (void)beginPullDownAnimation
{
    [self.view removeConstraints:self.pullDownMenuView.constraints];
    [self.view removeConstraints:self.constraintArray];
    [self.constraintArray removeAllObjects];
    float duration = 5;
    float height = 136;
    if (self.pullBtn.selected) {
        [UIView animateWithDuration:duration animations:^{
            [self.pullDownMenuView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(height));
            }];
        }];
        [UIView animateWithDuration:duration animations:^{
            [self.qqBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(REGISETER_LOGIN_STYLE_BUTTON_HEIGHT));
            }];
        }];
        [UIView animateWithDuration:duration animations:^{
            [self.sinaBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(REGISETER_LOGIN_STYLE_BUTTON_HEIGHT));
            }];
        }];
        [UIView animateWithDuration:duration animations:^{
            [self.weixinBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(REGISETER_LOGIN_STYLE_BUTTON_HEIGHT));
            }];
        }];
        [UIView animateWithDuration:duration animations:^{
            [self.emailBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(REGISETER_LOGIN_STYLE_BUTTON_HEIGHT));
            }];
        }];
//        self.isAnimation = YES;
        self.pullBtn.selected = NO;
    }else{

        [UIView animateWithDuration:duration animations:^{
            [self.qqBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));
            }];
        }];
        [UIView animateWithDuration:duration animations:^{
            [self.sinaBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));
            }];
        }];
        [UIView animateWithDuration:duration animations:^{
            [self.weixinBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));
            }];
        }];
        [UIView animateWithDuration:duration animations:^{
            [self.emailBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));
            }];
        }];
//        [UIView animateWithDuration:duration animations:^{
//            [self.pullDownMenuView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@(10));
//            }];
//        }];
//        self.isAnimation = NO;
        self.pullBtn.selected = YES;
    }
    
}

- (void)easeOutInAnimation
{
    CGFloat easeInDuration = 2;
    CGFloat easeOutDuration = 1;

    self.pullBtn.selected = !self.pullBtn.selected;
    if (self.pullBtn.selected) {
        [self.qqBtn setEaseInWithDuration:easeInDuration];
        [self.emailBtn setEaseInWithDuration:easeInDuration];
        [self.weixinBtn setEaseInWithDuration:easeInDuration];
        [self.sinaBtn setEaseInWithDuration:easeInDuration];
    }else{
        [self.qqBtn setEaseOutWithDuration:easeOutDuration];
        [self.emailBtn setEaseOutWithDuration:easeOutDuration];
        [self.weixinBtn setEaseOutWithDuration:easeOutDuration];
        [self.sinaBtn setEaseOutWithDuration:easeOutDuration];

    }
}

//  其他注册方式选择
- (void)registerBySns:(ShareType)shareType
{
    NSString* inviteCode = [[InviteCodeManager sharedInstance] getCurrentInviteCode];
    [[UserService sharedInstance] registerBySns:shareType
                                     inviteCode:inviteCode
                                       callback:^(PBUser *pbUser, NSError *error) {
                                           
                                           if (error == nil){
                                               // success, TODO
                                               POST_SUCCESS_MSG(@"注册成功，欢迎光临");
                                               
                                               
                                               [[AppDelegate sharedInstance] showNormalHome];
                                               
                                           }
                                           else{
                                               // failure, TODO
                                               POST_SUCCESS_MSG(@"注册失败，这个消息不太友好，待完善");
                                           }
                                       }];
    
}

//  点击QQ注册按钮
-(void)clickQQBtn:(id)sender
{
    [self registerBySns:ShareTypeQQ];
}

//  点击新浪微博注册按钮
-(void)clickSinaBtn:(id)sender
{
    [self registerBySns:ShareTypeSinaWeibo];
}

//  点击微信注册按钮
-(void)clickWeixinBtn:(id)sender
{
    [self registerBySns:ShareTypeWeixiSession];
}

//  点击email注册按钮
-(void)clickEmailBtn:(id)sender
{
    RegisterByEmailController *vc = [[RegisterByEmailController alloc]init];
    vc.verifyPassBlock=^(){
        [[AppDelegate sharedInstance] showNormalHome];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//  点击提交按钮
- (void)clickSubmitBtn:(id)sender
{

    NSString* mobile = self.mobileTextField.text;
    NSString* password = self.passwordTextField.text;
    
    //  验证手机号和密码格式
    BOOL isMoblieValid = NSStringIsValidMobile(mobile);
    BOOL isPasswordValid = [self validatePassword:password];
    if (!isMoblieValid) {
        
        POST_ERROR(@"请输入正确的手机号码！");
        return;
    }else if (!isPasswordValid){
        POST_ERROR(@"密码不能为空！");
    }else{
        
        //add by neng ,verity Phone
        
        [self verifyCode:mobile];
        
    }
}

-(void)sendRegisterMessage{
    NSString* mobile = self.mobileTextField.text;
    NSString* password = self.passwordTextField.text;
    
    NSString* inviteCode = [[InviteCodeManager sharedInstance] getCurrentInviteCode];
    NSString* encryptPassword = [UserManager encryptPassword:password];
            [[UserService sharedInstance] regiseterUserByMobile:mobile
                                                       password:encryptPassword
                                                     inviteCode:inviteCode
                                                   callback:^(PBUser *pbUser, NSError *error) {
                                                       if (error == nil){
                                                           POST_SUCCESS_MSG(@"注册成功");
                                                           //add by neng ,clear register data
                                                           [[RegisterCodeManager sharedInstance]clearCurrentPhoneNum];
                                                           [[RegisterCodeManager sharedInstance]clearCurrentPassword];
                                                           [[AppDelegate sharedInstance] showNormalHome];
                                                       }
                                                       else{
                                                           POST_ERROR(@"注册失败，请稍后再试");
                                                       }
                                                   }];
}

//add by neng
-(void)verifyCode:(NSString*)phoneNum{
    RegisterByPhoneVerifyCotroller *registerByPhoneVerifyCotroller = [RegisterByPhoneVerifyCotroller initWithPhoneNum:phoneNum];
    
    
    [self.navigationController pushViewController :registerByPhoneVerifyCotroller animated:YES];
    
    __weak typeof(self) weakSelf = self;
    registerByPhoneVerifyCotroller.verifyPassBlock= ^(){
        [weakSelf sendRegisterMessage];
    };
}

@end
