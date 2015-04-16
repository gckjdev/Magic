//
//  PhoneRegisterView.m
//  BarrageClient
//
//  Created by Teemo on 15/3/17.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "PhoneRegisterView.h"
#import "UIViewUtils.h"
#import "Masonry.h"
#import "ColorInfo.h"
#import "FontInfo.h"
#import "ViewInfo.h"

#define HINT_MESSAGE_WAIT_TIME 30
#define HINT_MESSAGE_WAIT   @"%d秒后重发"
#define HINT_MESSAGE_SEND   @"点击重发"

#define LINELABEL_HEIGHT 20
#define LINELABEL_PADDING -7

@interface PhoneRegisterView()
@property(nonatomic,strong)NSTimer *timeChangeLabel;
@property (nonatomic, assign) int   timeCount;
@end
@implementation PhoneRegisterView
-(instancetype)initWithVerify:(NSString *)verifyPlaceholder
                       button:(NSString *)buttonTitle
                   controller:(id)controller
                 buttonAction:(SEL)buttonAction;
                
{
    self = [super init];
    if (self) {
     
        
        //  输入验证码
        self.verifyCodeField = [UITextField defaultTextField:verifyPlaceholder
                                                    superView:self];
        [self.verifyCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self);
        }];
        
        self.verifyCodeField.delegate = controller;
        
        
        // 提示重发
        NSString *tmpText = [NSString stringWithFormat:HINT_MESSAGE_WAIT,HINT_MESSAGE_WAIT_TIME];
        self.lineLabel = [UILineLabel initWithText:tmpText
                                              Font:BARRAGE_LITTLE_LABEL_FONT
                                                Color:[UIColor grayColor]
                                              Type:UILINELABELTYPE_DOWN];
  

       
        
        [self addSubview:self.lineLabel];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.verifyCodeField.mas_bottom).with.offset(COMMON_TEXTFIELD_PADDING);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, LINELABEL_HEIGHT));
        }];
        
        [self.lineLabel addTapGestureWithTarget:self selector:@selector(labelAction)];
        
        //  提交按钮
//        self.button = [UIButton defaultTextButton:buttonTitle
//                                        superView:self];
//        [self.button addTarget:controller
//                        action:buttonAction
//              forControlEvents:UIControlEventTouchUpInside];   //  点击提交按钮触发的事件
//        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.lineLabel.mas_bottom).with.offset(COMMON_TEXTFIELD_PADDING);
//        }];
        
        [self startTime];
       
    }
    return self;
}

-(void)startTime{
    //Time
    _timeChangeLabel =[NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(updateTime)
                                                     userInfo:nil
                                                      repeats:YES];
    _timeCount = 0;
    
    self.lineLabel.textColor = [UIColor grayColor];
    self.lineLabel.lineColor = [UIColor grayColor];
}
-(void)updateTime{
    _timeCount++;
    if (_timeCount>=HINT_MESSAGE_WAIT_TIME)
    {
        self.lineLabel.text = HINT_MESSAGE_SEND;
        self.lineLabel.textColor = BARRAGE_LABEL_COLOR;
        self.lineLabel.lineColor = BARRAGE_LABEL_COLOR;
    
        [_timeChangeLabel invalidate];
        
        return;
    }
    self.lineLabel.text=[NSString stringWithFormat:HINT_MESSAGE_WAIT,HINT_MESSAGE_WAIT_TIME-_timeCount];
}
-(void)labelAction{
    if (_timeCount >=HINT_MESSAGE_WAIT_TIME) {
        [self startTime];
        EXECUTE_BLOCK(self.labelActoinBlock);
    }
}
@end
