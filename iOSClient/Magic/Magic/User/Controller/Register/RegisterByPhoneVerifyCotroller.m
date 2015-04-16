//
//  RegisterByPhoneVerifyCotroller.m
//  BarrageClient
//
//  Created by Teemo on 15/3/18.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "RegisterByPhoneVerifyCotroller.h"
#import "PhoneRegisterView.h"
#import "MessageCenter.h"
#import "PPDebug.h"
#import "ViewInfo.h"
#import "UIViewUtils.h"
#include "ColorInfo.h"
#import "SMSManager.h"
#import <SMS_SDK/SMS_SDK.h>
#import <SMS_SDK/CountryAndAreaCode.h>
#include "UIViewController+Utils.h"


#define REGISTERVIEW_HEIGHT 200.0f

@interface RegisterByPhoneVerifyCotroller ()
@property(nonatomic,strong)PhoneRegisterView* phoneRegisterView;
@property(nonatomic,strong)NSString* phoneNum;
@end

@implementation RegisterByPhoneVerifyCotroller
+(RegisterByPhoneVerifyCotroller*)initWithPhoneNum:(NSString*)phoneNum
{
    RegisterByPhoneVerifyCotroller *controller = [[RegisterByPhoneVerifyCotroller alloc]init];
    controller.phoneNum = [phoneNum copy];
    return controller;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BARRAGE_BG_COLOR];
    [self setTitle:@"验证手机"];
    [self sendVerifyMessage];
    [self initPhoneRegisterView];
    [self addRightButtonWithTitle:@"提交"
                           target:self
                           action:@selector(buttonAction)];
}
-(void)initPhoneRegisterView{
    
    NSMutableString *hintText = [[NSMutableString alloc]init];
    [hintText appendFormat:@"请输入: %@ 的验证码",_phoneNum];
    PhoneRegisterView *phoneRegisterView = [[PhoneRegisterView alloc]initWithVerify:hintText button:@"提交" controller:self buttonAction:@selector(buttonAction)];
    phoneRegisterView.frame = CGRectMake(0,COMMON_PADDING, kScreenWidth, REGISTERVIEW_HEIGHT);
    
    phoneRegisterView.verifyCodeField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneRegisterView.verifyCodeField becomeFirstResponder];
     __weak typeof(self) weakSelf = self;
    phoneRegisterView.labelActoinBlock = ^(){
        [weakSelf sendVerifyMessage];
    };
    _phoneRegisterView = phoneRegisterView;
    
    
   

    [self.view addSubview:phoneRegisterView];
}
-(void)buttonAction{
    NSString* code = _phoneRegisterView.verifyCodeField.text;
    [SMS_SDK commitVerifyCode:code result:^(enum SMS_ResponseState state) {
        if (state == SMS_ResponseStateSuccess) {
            POSTMSG(@"验证成功");
            PPDebug(@"Verifty Success");
            [self.navigationController popViewControllerAnimated:YES];
            EXECUTE_BLOCK(self.verifyPassBlock);
           
        }
        else
        {
            PPDebug(@"Verifty fail");
            POSTMSG(@"验证码错误");
            
        }
    }];
}
-(void)sendVerifyMessage{

    [SMS_SDK getVerifyCodeByPhoneNumber:_phoneNum AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        if (state == SMS_ResponseStateGetVerifyCodeSuccess) {
            PPDebug(@"send phone : +%@-%@ message succes",_phoneNum,@"86");
            POSTMSG(@"验证码已发送");
        }
        else
        {
            PPDebug(@"send phone : +%@-%@ message fail",_phoneNum,@"86");
            POSTMSG(@"验证码发送失败");
        }
        
    }];
}



@end
