//
//  LoginByEmailController.m
//  BarrageClient
//
//  Created by gckj on 15/1/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "LoginByEmailController.h"
#import "UserService.h"
#import "InviteCodeManager.h"
#import "UserTimelineFeedController.h"
#import "Masonry.h"
#import "ColorInfo.h"
#import "StringUtil.h"
#import "AppDelegate.h"
#import "UserManager.h"
#import "LoginView.h"
#import "LoginCodeManager.h"

@interface LoginByEmailController ()
@property (nonatomic,strong)LoginView *loginView;
@end

@implementation LoginByEmailController

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
    self.title = @"邮箱登录";
    self.view.backgroundColor = BARRAGE_BG_COLOR;
    [self loadLoginView];
}

#pragma mark - Private methods
- (void)loadLoginView
{
    self.loginView = [[LoginView alloc]initWithAccount:@"请输入邮箱"
                                              password:@"请输入密码"
                                                button:@"登录"
                                            controller:self
                                          buttonAction:@selector(clickLoginBtn:)];
    
    self.loginView.accountTextField.keyboardType = UIKeyboardTypeEmailAddress;   //  键盘样式
    
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(+COMMON_TEXTFIELD_TOP_SPACING);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).with.dividedBy(2);
    }];
    
    //add by neng ,get login data
    self.loginView.accountTextField.text = [[LoginCodeManager sharedInstance]getCurrentEmail];
}
#pragma mark - Utils
//  点击登录按钮
- (void)clickLoginBtn:(id)sender
{
    NSString* email = self.loginView.accountTextField.text;
    NSString* password = self.loginView.passwordTextField.text;
    
    //  验证邮箱格式
    BOOL isEmailValid = NSStringIsValidEmail(email);
    //  验证密码不为空
    BOOL isPasswordValid = password == nil || password.length == 0 ? NO : YES;
    
    if (!isEmailValid) {
        POST_ERROR(@"请输入正确的邮箱！");
    }else if (!isPasswordValid){
        POST_ERROR(@"密码不能为空！");
    }else{
        NSString* encryptPassword = [UserManager encryptPassword:password];
        [[UserService sharedInstance] loginUserByEmail:email
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
        [self clickLoginBtn:nil];
        return [textField resignFirstResponder];
    }else{
        return YES;
    }
}

//  textField完成编辑之后
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _loginView.accountTextField) {
        
        //add by neng , set login data
        [[LoginCodeManager sharedInstance]setCurrentEmail:textField.text];
        
        [_loginView.passwordTextField becomeFirstResponder];
    }else if (textField == _loginView.passwordTextField)
    {
        [textField resignFirstResponder];
    }
}
@end
