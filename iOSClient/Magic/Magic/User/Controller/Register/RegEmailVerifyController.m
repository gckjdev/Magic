//
//  RegEmailVerifyController.m
//  BarrageClient
//
//  Created by Teemo on 15/3/31.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "RegEmailVerifyController.h"
#import "PhoneRegisterView.h"
#import "ViewInfo.h"
#import "UIViewUtils.h"
#import "UserService.h"
#import "RegisterCodeManager.h"
#import "ColorInfo.h"


#define REGISTERVIEW_HEIGHT 200.0f

@interface RegEmailVerifyController ()
@property (nonatomic,strong) NSString*   destEmail;
@property(nonatomic,strong)PhoneRegisterView* phoneRegisterView;
@end

@implementation RegEmailVerifyController


+(instancetype)controllerWithEmail:(NSString*)destEmail
{
    RegEmailVerifyController *vc = [[RegEmailVerifyController alloc]init];
    vc.destEmail = [destEmail copy];
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"验证邮箱"];
    [self sendVerifyMessage];
    [self setupRegisterView];
    self.view.backgroundColor = BARRAGE_BG_COLOR; 
}


-(void)setupRegisterView{
    NSMutableString *hintText = [[NSMutableString alloc]init];
    [hintText appendFormat:@"请输入: %@ 的验证码",_destEmail];
    PhoneRegisterView *phoneRegisterView = [[PhoneRegisterView alloc]initWithVerify:hintText button:@"提交" controller:self buttonAction:@selector(submitAction)];
    phoneRegisterView.frame = CGRectMake(0,COMMON_PADDING, kScreenWidth, REGISTERVIEW_HEIGHT);
    
    phoneRegisterView.verifyCodeField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneRegisterView.verifyCodeField becomeFirstResponder];
    __weak typeof(self) weakSelf = self;
    phoneRegisterView.labelActoinBlock = ^(){
        [weakSelf sendVerifyMessage];
    };
    [self.view addSubview:phoneRegisterView];
    _phoneRegisterView = phoneRegisterView;
}
-(void)submitAction{
    NSString* code = _phoneRegisterView.verifyCodeField.text;
    NSString *numStr = [[RegisterCodeManager sharedInstance]getEmailVerify];
    
    if ([code isEqual:numStr]) {
        POSTMSG(@"验证成功");
        EXECUTE_BLOCK(self.verifyPassBlock);
    }else{
        POSTMSG(@"验证码错误");
    }
   
}


-(void)sendVerifyMessage{
    NSInteger num = arc4random()%10000;
    NSString *numStr = [NSString stringWithFormat:@"%ld",num];
    PPDebug(@"sendVerifyMessage code : %d",num);
    [[RegisterCodeManager sharedInstance]setEmailVerify:numStr];
    [[UserService sharedInstance]veriftyUserEmail:_destEmail code: numStr callback:^(NSError *error) {
        if (error == nil) {
           POSTMSG(@"验证码已发送");
        }
        else{
            POSTMSG(@"验证码发送失败");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
