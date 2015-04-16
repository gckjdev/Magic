//
//  EnterInviteCodeController.m
//  BarrageClient
//
//  Created by pipi on 14/12/27.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "EnterInviteCodeController.h"
#import "Masonry.h"
#import "InviteCodePassController.h"
#import "UserService.h"
#import "UIViewController+Utils.h"
#import "MessageCenter.h"
#import "InviteCodeManager.h"

#define kPadding 20
#define kBtnPadding 16  //  按钮间距

@interface EnterInviteCodeController ()

@property (nonatomic,strong)UIView *holderViewOne;
@property (nonatomic,strong)UIView *holderViewTwo;

@property (nonatomic,strong)UILabel *inputTipsLabel;
@property (nonatomic,strong)UITextField *inputTextField;
@property (nonatomic,strong)UIButton *inputSubmitBtn;

@property (nonatomic,strong)UILabel *imgTipsLabel;
@property (nonatomic,strong)UILabel *examineStateLabel;
@property (nonatomic,strong)UILabel *failureInfoLabel;
@property (nonatomic,strong)UIButton *addImgBtn;
@property (nonatomic,strong)UIButton *imgSubmitBtn;

@end

@implementation EnterInviteCodeController

#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView{
    [super loadView];
    [self setDefaultBackButton:@selector(clickBack:)];
    self.view.backgroundColor = BARRAGE_BG_COLOR;
    [self loadHolderViewOne];
    //  内测阶段，暂时隐藏
//    [self loadHolderViewTwo];
}

#pragma mark - Private methods
- (void)loadHolderViewOne{
    //  子页面1
    self.holderViewOne = [[UIView alloc]init];
    [self.view addSubview:self.holderViewOne];
    [self.holderViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).with.multipliedBy(0.4);
    }];
    
    [self loadTextField];
    [self loadInputSubmitBtn];
//    [self loadFailureInfoLabel];
}
- (void)loadTextField
{
    //  输入邀请码
    self.inputTextField = [UITextField defaultTextField:@"请输入邀请码"
                                              superView:self.holderViewOne];
    [self.inputTextField setBackgroundColor:[UIColor whiteColor]];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.holderViewOne).with.dividedBy(2);
    }];
    self.inputTextField.delegate = self;
    self.inputTextField.text = [[InviteCodeManager sharedInstance] getCurrentInviteCode];
    self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
}
- (void)loadInputSubmitBtn
{
    //  提交
    self.inputSubmitBtn = [UIButton defaultTextButton:@"提交" superView:self.holderViewOne];
    [self.inputSubmitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextField.mas_bottom).with.offset(+kBtnPadding);
    }];
    [self.inputSubmitBtn addTarget:self action:@selector(clickInputSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];   //  点击提交按钮触发的事件
}
- (void)loadFailureInfoLabel
{
    //  验证失败信息
    self.failureInfoLabel = [[UILabel alloc]init];
    self.failureInfoLabel.textAlignment = NSTextAlignmentCenter;
    self.failureInfoLabel.font = [UIFont systemFontOfSize:13];
    [self.holderViewOne addSubview:self.failureInfoLabel];
    [self.failureInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.holderViewOne);
        make.top.equalTo(self.inputSubmitBtn.mas_bottom).with.offset(+kPadding);
    }];
}

- (void)loadHolderViewTwo{
    //  子页面2
    self.holderViewTwo = [[UIView alloc]init];
    [self.view addSubview:self.holderViewTwo];
    [self.holderViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.holderViewOne.mas_bottom);
        make.height.equalTo(self.view).with.multipliedBy(0.6);
        make.width.equalTo(self.view);
    }];
    //  提交相片tips
    self.imgTipsLabel = [[UILabel alloc]init];
    [self.holderViewTwo addSubview:self.imgTipsLabel];
    self.imgTipsLabel.text = @"或者拍一张你觉得非常有趣的图片给我们审核，以获得邀请码";
    self.imgTipsLabel.textAlignment = NSTextAlignmentCenter;
    self.imgTipsLabel.numberOfLines = 0;    //  多行显示
    [self.imgTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.holderViewTwo);
        make.top.equalTo(self.holderViewTwo).with.offset(+kPadding);
        make.width.equalTo(self.holderViewTwo).with.offset(-kPadding*2);
    }];
    //  添加图片按钮
    self.addImgBtn = [[UIButton alloc]init];
    [self.holderViewTwo addSubview:self.addImgBtn];
    [self.addImgBtn setTitle:@"添加照片" forState:UIControlStateNormal];
    [self.addImgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.holderViewTwo);
        make.top.equalTo(self.imgTipsLabel.mas_bottom).with.offset(+kPadding);
    }];
    //  审核进程情况
    self.examineStateLabel = [[UILabel alloc]init];
    self.examineStateLabel.text = @"审核中";
    self.examineStateLabel.font = [UIFont systemFontOfSize:13];
    self.examineStateLabel.textAlignment = NSTextAlignmentCenter;
    [self.holderViewTwo addSubview:self.examineStateLabel];
    [self.examineStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.holderViewTwo);
        make.top.equalTo(self.addImgBtn.mas_bottom).with.offset(+kPadding);

    }];
    //  照片提交按钮
    self.imgSubmitBtn = [[UIButton alloc]init];
    [self.imgSubmitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.imgSubmitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.holderViewTwo addSubview:self.imgSubmitBtn];
    [self.imgSubmitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.holderViewTwo);
        make.top.equalTo(self.examineStateLabel.mas_bottom).with.offset(+kPadding);
        make.width.equalTo(self.holderViewTwo.mas_width).with.dividedBy(3);
    }];
}

#pragma mark - Utils
- (void)clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isCodeValid:(NSString*)code
{
    // TODO check is code empty
    return (code.length == 0) ? NO : YES;
}

- (void)clickInputSubmitBtn:(id)sender
{
    NSString* code = self.inputTextField.text;
    if ([self isCodeValid:code] == NO){
        self.failureInfoLabel.text = @"验证码输入为空！请重新输入！";
        return;
    }
    [self.inputTextField resignFirstResponder];
    
    SHOW_LOADING(SENDING_TEXT, self.view);
    [[UserService sharedInstance] verifyInviteCode:code callback:^(NSString *code, NSError *error) {
        
        HIDE_LOADING(self.view);
        if (error == nil){
            POST_SUCCESS_MSG(@"邀请码验证通过，欢迎注册...");
            [[InviteCodeManager sharedInstance] setCurrentInviteCode:code];
            // verify pass
            InviteCodePassController *vc = [[InviteCodePassController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            POST_ERROR(@"邀请码姿势不对，请检查输入是否正确");
        }
    }];
}
//  UITextField 点击输入框以外地方执行
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_inputTextField resignFirstResponder]; //  注销第一响应者
}

@end
