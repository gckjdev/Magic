//
//  ChangePwdController.m
//  BarrageClient
//
//  Created by 蔡少武 on 15/3/1.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "ChangePwdController.h"
#import "UIViewUtils.h"
#import "Masonry.h"
#import "ViewInfo.h"
#import "UserManager.h"
#import "UserService.h"

#define OLD_PWD_TEXTFIELD_PLACEHOLDER @"请输入旧密码"
#define NEW_PWD_TEXTFIELD_PLACEHOLDER @"请输入新密码"
#define CONFIRM_PWD_TEXTFIELD_PLACEHOLDER @"请重复新密码"
#define TITILE_SUBMIT_BTN   @"提交"

@interface ChangePwdController ()

@property (nonatomic,strong)UITextField *OldPwdTextField;   //  old password
@property (nonatomic,strong)UITextField *NewPwdTextField;      //  new password
@property (nonatomic,strong)UITextField *confirmPwdTextField;   //  confirm password
@property (nonatomic,strong)UIButton *submitBtn;    //  submit button
@property (nonatomic,strong)PBUser *user;
@end

@implementation ChangePwdController

#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView
{
    [super loadView];
    self.title = @"修改密码";
    self.user = [[UserManager sharedInstance]pbUser];
    [self loadOldPwdTextField];
    [self loadNewPwdTextField];
    [self loadConfirmPwdTextField];
    [self loadSubmitBtn];
}
#pragma mark - Private methods
- (void)loadOldPwdTextField
{
    self.OldPwdTextField = [UITextField defaultTextField:OLD_PWD_TEXTFIELD_PLACEHOLDER superView:self.view];
    self.OldPwdTextField.secureTextEntry = YES;
    [self.OldPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(+COMMON_TEXTFIELD_TOP_SPACING);
    }];
    self.OldPwdTextField.hidden = ![_user hasPassword];
}
- (void)loadNewPwdTextField
{
    self.NewPwdTextField = [UITextField defaultTextField:NEW_PWD_TEXTFIELD_PLACEHOLDER superView:self.view];
    self.NewPwdTextField.secureTextEntry = YES;
    [self.NewPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        if (self.OldPwdTextField.hidden == YES) {
            make.top.equalTo(self.OldPwdTextField);
        }else{
            make.top.equalTo(self.OldPwdTextField.mas_bottom);
        }
    }];
}
- (void)loadConfirmPwdTextField
{
    self.confirmPwdTextField = [UITextField defaultTextField:CONFIRM_PWD_TEXTFIELD_PLACEHOLDER superView:self.view];
    self.confirmPwdTextField.secureTextEntry = YES;
    [self.confirmPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.NewPwdTextField.mas_bottom);
    }];
}
- (void)loadSubmitBtn
{
    self.submitBtn = [UIButton defaultTextButton:TITILE_SUBMIT_BTN superView:self.view];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPwdTextField.mas_bottom).with.offset(+COMMON_PADDING);
    }];
    [self.submitBtn addTarget:self
                       action:@selector(clickChangePwdBtn:)
             forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Utils
- (void)clickChangePwdBtn:(id)sender
{
    NSString *oldPassword = self.OldPwdTextField.text;
    NSString *newPassword = self.NewPwdTextField.text;
    NSString *confirmPassword = self.confirmPwdTextField.text;
    
    NSString* encryptOldPassword = [UserManager encryptPassword:oldPassword];       //  if oldPassword == @"" then encryptOldPassword is nil
    if ([encryptOldPassword isEqualToString:_user.password] || ![_user hasPassword]) {
        if ([newPassword isEqualToString:confirmPassword]) {
            if ([newPassword length] != 0) {
                NSString *encryptNewPassword = [UserManager encryptPassword:newPassword];
                
                [[UserService sharedInstance]updateUserPwd:encryptNewPassword callback:^(PBUser *pbUser, NSError *error) {
                    PPDebug(@"save user gender successfully");
                    POST_SUCCESS_MSG(@"修改密码成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                POST_ERROR(@"新密码不能为空，请重新输入");
            }
        }else{
            POST_ERROR(@"两次输入新密码不一致，请重新输入");
        }
    }else
    {
        POST_ERROR(@"请输入正确的旧密码");
    }
}
@end
