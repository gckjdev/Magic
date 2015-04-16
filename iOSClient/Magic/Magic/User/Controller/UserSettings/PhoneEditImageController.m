//
//  PhoneEditImageController.m
//  BarrageClient
//
//  Created by Teemo on 15/3/19.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "PhoneEditImageController.h"
#import "RegisterByPhoneVerifyCotroller.h"
#import "Masonry.h"
#import "PPDebug.h"
#import "ColorInfo.h"
#import "FontInfo.h"
#import "UIViewUtils.h"
#import "UIViewController+Utils.h"
#import "MessageCenter.h"
#import "StringUtil.h"

#define kMargin 20  //  边距

@interface PhoneEditImageController ()

@end

@implementation PhoneEditImageController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = BARRAGE_BG_COLOR;
    
    [self loadTextField];
    
    [self loadSaveButton];
}

- (id)initWithText:(NSString*)text
       placeHolder:(NSString*)placeHolder
              tips:(NSString*)tips
   saveActionBlock:(EditSaveBlock)saveActionBlock
{
    self = [super init];
    
    self.editText = text;
    self.placeHolder = placeHolder;
    self.tips = tips;
    self.saveActionBlock = saveActionBlock;
    
    return self;
}

- (void)loadTextField
{
    self.textField = [UITextField defaultTextField:self.placeHolder
                                         superView:self.view];
    self.textField.text = self.editText;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kMargin);
        make.centerX.equalTo(self.view);
    }];
}

- (void)loadTipsLabel
{
    self.tipsLabel = [[UILabel alloc]init];
    self.tipsLabel.text = self.tips;
    self.tipsLabel.font = BARRAGE_LABEL_FONT;   //  字体
    self.tipsLabel.textAlignment =  NSTextAlignmentCenter;
    [self.view addSubview:self.tipsLabel];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(+kMargin);
        make.right.equalTo(self.view).with.offset(-kMargin);
        make.top.equalTo(self.textField.mas_bottom).with.offset(+kMargin);
        make.centerX.equalTo(self.view);
    }];
}

- (void)loadSaveButton
{
    [self addRightButtonWithTitle:@"下一步" target:self action:@selector(clickSaveButton:)];
}

- (void)clickSaveButton:(id)sender
{
    
    BOOL isValiddNum = NSStringIsValidMobile(self.textField.text);
    if (!isValiddNum) {
        POST_ERROR(@"请输入正确的手机号码！");
        return;
    }
    RegisterByPhoneVerifyCotroller *registerByPhoneVerifyCotroller = [RegisterByPhoneVerifyCotroller initWithPhoneNum:self.textField.text];
    
    
    [self.navigationController pushViewController :registerByPhoneVerifyCotroller animated:YES];
    
    __weak typeof(self) weakSelf = self;
    registerByPhoneVerifyCotroller.verifyPassBlock= ^(){
        [weakSelf save];
    };
    
}

- (void)save
{
    EXECUTE_BLOCK(self.saveActionBlock, self.textField.text);
    [self.navigationController popViewControllerAnimated:YES];
}


@end
