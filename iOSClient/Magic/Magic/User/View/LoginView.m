//
//  LoginView.m
//  BarrageClient
//
//  Created by gckj on 15/1/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "LoginView.h"
#import "UIViewUtils.h"
#import "Masonry.h"
#import "ViewInfo.h"

#define kBtnPadding 16  //  按钮间距

@implementation LoginView

#pragma mark - Public methods
-(instancetype)initWithAccount:(NSString *)accountPlaceholder
                      password:(NSString *)passwordPlaceholder
                        button:(NSString *)buttonTitle
                    controller:(id)controller
                  buttonAction:(SEL)action
{
    self = [super init];
    if (self) {
        //  输入账户
        self.accountTextField = [UITextField defaultTextField:accountPlaceholder
                                                   superView:self];
        [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
        }];

        self.accountTextField.delegate = controller;
        //  输入密码
        self.passwordTextField = [UITextField defaultTextField:passwordPlaceholder
                                                     superView:self];
        self.passwordTextField.secureTextEntry = YES;
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.accountTextField.mas_bottom);
        }];
        [self.passwordTextField setBackgroundColor:[UIColor whiteColor]];

        self.passwordTextField.returnKeyType = UIReturnKeyDone; //  键盘“换行”变成“完成”
        self.passwordTextField.delegate = controller;
        
        //  提交按钮
        self.button = [UIButton defaultTextButton:buttonTitle
                                        superView:self];
        [self.button addTarget:controller
                        action:action
              forControlEvents:UIControlEventTouchUpInside];   //  点击提交按钮触发的事件
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordTextField.mas_bottom).with.offset(+kBtnPadding);
        }];
    }
    return self;
}

@end
