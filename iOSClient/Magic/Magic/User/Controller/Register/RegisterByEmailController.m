//
//  RegisterByEmailController.m
//  BarrageClient
//
//  Created by gckj on 15/1/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "RegisterByEmailController.h"
#import "LoginView.h"
#import "UserService.h"
#import "InviteCodeManager.h"
#import "Masonry.h"
#import "ColorInfo.h"
#import "StringUtil.h"
#import "AppDelegate.h"
#import "UserManager.h"
#import "RegisterCodeManager.h"

@interface RegisterByEmailController ()

@property (nonatomic,strong)LoginView *loginView;   //  暂时使用LoginView，如果风格与LoginView不一样，再自定义registerView

@end

@implementation RegisterByEmailController

#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = BARRAGE_BG_COLOR;
    self.title = @"邮箱注册";
    [self loadRegisterView];
}

#pragma mark - Private methods
- (void)loadRegisterView
{
    self.loginView = [[LoginView alloc]initWithAccount:@"请输入邮箱"
                                              password:@"请输入密码"
                                                button:@"提交"
                                            controller:self
                                          buttonAction:@selector(clickRegisterBtn:)];
    
    self.loginView.accountTextField.keyboardType = UIKeyboardTypeEmailAddress;   //  键盘样式
    
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(+COMMON_TEXTFIELD_TOP_SPACING);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).with.dividedBy(2);
    }];
    
    //add by neng,get user data
    self.loginView.accountTextField.text  = [[RegisterCodeManager sharedInstance]getCurrentEmail];
    self.loginView.passwordTextField.text = [[RegisterCodeManager sharedInstance]getCurrentPassword];
}
#pragma mark - Utils
//  点击注册按钮
-(void)clickRegisterBtn:(id)sender
{
    NSString* email = _loginView.accountTextField.text;
    NSString* password = _loginView.passwordTextField.text;
    
    //  邀请码
    NSString* inviteCode = [[InviteCodeManager sharedInstance] getCurrentInviteCode];
    //  验证邮箱格式
    BOOL isMoblieValid = NSStringIsValidEmail(email);
    //  验证密码不为空
    BOOL isPasswordValid = password == nil || password.length == 0 ? NO : YES;
    
    if (!isMoblieValid) {
        POST_ERROR(@"请输入正确的邮箱！");
    }else if (!isPasswordValid){
        POST_ERROR(@"密码不能为空！");
    }else{
        NSString* encryptPassword = [UserManager encryptPassword:password];
        [[UserService sharedInstance] regiseterUserByEmail:email
                                                   password:encryptPassword
                                                 inviteCode:inviteCode
                                                   callback:^(PBUser *pbUser, NSError *error) {
                                                       if (error == nil){
                                                           POST_SUCCESS_MSG(@"注册成功");
                                                           
                                                           //add by neng ,clear register data
                                                           [[RegisterCodeManager sharedInstance]clearCurrentEmail];
                                                           [[RegisterCodeManager sharedInstance]clearCurrentPassword];
                                                           
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                            EXECUTE_BLOCK(self.verifyPassBlock);
                                                       }
                                                       else{
                                                           POST_ERROR(@"注册失败，请稍后再试");
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
        [self clickRegisterBtn:nil];
        return [textField resignFirstResponder];
    }else{
        return YES;
    }
}

//  textField完成编辑之后
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _loginView.accountTextField) {
        [_loginView.passwordTextField becomeFirstResponder];
        
        //add by neng,set user data
        [[RegisterCodeManager sharedInstance]setCurrentEmail:textField.text];
    }else if (textField == _loginView.passwordTextField)
    {
        [textField resignFirstResponder];
        //add by neng,set user data
        [[RegisterCodeManager sharedInstance]setCurrentPassword:textField.text];
    }
}

@end
