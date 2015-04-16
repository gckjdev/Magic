//
//  LoginByPhoneController.m
//  BarrageClient
//
//  Created by gckj on 15/1/29.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "LoginByPhoneController.h"
#import "LoginView.h"
#import "Masonry.h"
#import "ColorInfo.h"
#import "StringUtil.h"
#import "UserService.h"
#import "AppDelegate.h"
#import "UserManager.h"
#import "UserTimelineFeedController.h"
#import "LoginCodeManager.h"

@interface LoginByPhoneController ()

@property (nonatomic,strong)LoginView *loginView;

@end

@implementation LoginByPhoneController

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
    self.title = @"手机登录";
    self.view.backgroundColor = BARRAGE_BG_COLOR;
    [self loadLoginView];
}

#pragma mark - Private methods
- (void)loadLoginView
{
    self.loginView = [[LoginView alloc]initWithAccount:@"请输入手机号码"
                                              password:@"请输入密码"
                                                button:@"登录"
                                            controller:self
                                          buttonAction:@selector(clickPhoneLoginBtn:)];
    
    _loginView.accountTextField.keyboardType = UIKeyboardTypeNumberPad;   //  键盘样式
    
    [self.view addSubview:_loginView];
    [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(+COMMON_TEXTFIELD_TOP_SPACING);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).with.dividedBy(2);
    }];
    
    //add by neng,get login data
    _loginView.accountTextField.text = [[LoginCodeManager sharedInstance]getCurrentPhoneNum];
}
#pragma mark - Utils
//  点击登录按钮
-(void)clickPhoneLoginBtn:(id)sender
{
    NSString* mobile = _loginView.accountTextField.text;
    NSString* password = _loginView.passwordTextField.text;
    
    //  验证手机号码格式
    BOOL isMoblieValid = NSStringIsValidMobile(mobile);
    //  验证密码不为空
    BOOL isPasswordValid = password == nil || password.length == 0 ? NO : YES;
    
    if (!isMoblieValid) {
        POST_ERROR(@"请输入正确的手机号码！");
    }else if (!isPasswordValid){
        POST_ERROR(@"密码不能为空！");
    }else{
        NSString* encryptPassword = [UserManager encryptPassword:password];
        [[UserService sharedInstance] loginUserByMobile:mobile
                                              password:encryptPassword
                                              callback:^(PBUser *pbUser, NSError *error) {
                                                  if (error == nil){
                                                      POST_SUCCESS_MSG(@"登录成功");
        
                                                      
                                                      
                                                      
                                                      [[AppDelegate sharedInstance] showNormalHome];
                                                      // post notification to UserTimelineController
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIMELINE_RELOAD_FROM_NETWORK
                                                                                                          object:nil];
                                                  }
                                                  else{
                                                      POST_ERROR(@"登录失败，请稍后再试");
                                                  }
                                              }];
    }
    
}

#pragma mark - A2DynamicUITextFieldDelegate
//  点击“return”或者“Done”执行的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _loginView.accountTextField) {
     
        
        return [_loginView.passwordTextField becomeFirstResponder];
        
    }else if(textField == _loginView.passwordTextField){
        [self clickPhoneLoginBtn:nil];
        return [textField resignFirstResponder];
    }else{
        return YES;
    }
}

//  textField完成编辑之后
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _loginView.accountTextField) {
        //add by neng,set login data
        [[LoginCodeManager sharedInstance]setCurrentPhoneNum:_loginView.accountTextField.text];
        [_loginView.passwordTextField becomeFirstResponder];
    }else if (textField == _loginView.passwordTextField)
    {
        [textField resignFirstResponder];
    }
}
@end
