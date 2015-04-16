//
//  EmailEditingController.m
//  BarrageClient
//
//  Created by Teemo on 15/3/31.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "EmailEditingController.h"
#import "StringUtil.h"
#import "MessageCenter.h"
#import "RegEmailVerifyController.h"
#import "UIViewController+Utils.h"

@interface EmailEditingController ()

@end

@implementation EmailEditingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadSaveButton
{
    
    
    [self addRightButtonWithTitle:@"下一步" target:self action:@selector(clickNextButton)];
    
    
}
-(void)clickNextButton{
    BOOL isValiddNum = NSStringIsValidEmail(self.textField.text);
    if (!isValiddNum) {
        POST_ERROR(@"请输入正确的邮箱！");
        return;
    }
    RegEmailVerifyController *vc = [RegEmailVerifyController controllerWithEmail:self.textField.text];
    
    
    [self.navigationController pushViewController :vc animated:YES];
    
    __weak typeof(self) weakSelf = self;
    vc.verifyPassBlock= ^(){
        [weakSelf save];
    };
}
-(void)save{
    
}
@end
