//
//  ChatToolView.m
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import "ChatToolView.h"
#import "Masonry.h"
#import "AudioManager.h"
#import "FileUtil.h"
#import "CommonService.h"
#import "FontInfo.h"
#import "ColorInfo.h"
#import "ViewInfo.h"


#define COMMON_ICON_SIZE 40.0f

@interface ChatToolView()
@end

@implementation ChatToolView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor] ;
        [self setupView];
       
       
    }
    return self;
}
-(void)setupView{
    _soundBtn = [[UIButton alloc]init];
    [_soundBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
    [_soundBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_press"] forState:UIControlStateHighlighted];
    [self addSubview:_soundBtn];
    [_soundBtn addTarget:self action:@selector(soundButtonTouchDownAciton) forControlEvents:UIControlEventTouchDown];
    [_soundBtn addTarget:self action:@selector(soundButtonTouchUpInsideAciton) forControlEvents:UIControlEventTouchUpInside];
    [_soundBtn addTarget:self action:@selector(soundButtonTouchTouchUpOutsideAction) forControlEvents:UIControlEventTouchUpOutside];
    
    [_soundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(COMMON_ICON_SIZE, COMMON_ICON_SIZE));
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    
    _contentView = [[UITextView alloc]init];
    _contentView.backgroundColor = BARRAGE_BG_COLOR;
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self).offset(COMMON_ICON_SIZE);
        make.centerY.equalTo(self);
#ifdef showFaceBtn
        make.right.equalTo(self).offset(-COMMON_ICON_SIZE*2);
#else
        make.right.equalTo(self).offset(-COMMON_ICON_SIZE);
#endif
        make.height.mas_equalTo(@(COMMON_ICON_SIZE - COMMON_ICON_SIZE/4));
    }];
    

#ifdef showFaceBtn
    _faceBtn = [[UIButton alloc]init];
    [_faceBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    [_faceBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_press"] forState:UIControlStateHighlighted];
    [_faceBtn addTarget:self action:@selector(faceBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_faceBtn];
    [_faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(COMMON_ICON_SIZE, COMMON_ICON_SIZE));
        make.right.equalTo(self).offset(-COMMON_ICON_SIZE);
        make.centerY.equalTo(self);
    }];
#endif
    _plusBtn = [[UIButton alloc]init];
    
    [_plusBtn setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
    [_plusBtn setImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateHighlighted];
    [_plusBtn addTarget:self action:@selector(plusBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_plusBtn];
    
    [_plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(COMMON_ICON_SIZE, COMMON_ICON_SIZE));
        make.right.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    
    _sendBtn = [[UIButton alloc]init];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn.titleLabel setFont:BARRAGE_IMAGEBUTTON_BENEATH_FONT];
//    [_sendBtn setTitleColor:BARRAGE_IMAGEBUTTON_BENEATH_FONT forState:UIControlStateNormal];
    [_sendBtn setTitleColor: BARRAGE_LABEL_COLOR forState:UIControlStateNormal];
    [_sendBtn setHidden:YES];
    [_sendBtn addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(COMMON_ICON_SIZE, COMMON_ICON_SIZE));
        make.right.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showSendButton) name:@"MESSAGE_HAVE_TEXT" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideSendButton) name:@"MESSAGE_HAVE_NO_TEXT" object:nil];
}
-(void)sendButtonAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sendMessageButtonSingleTouch:)]) {
        [self.delegate sendMessageButtonSingleTouch:_contentView.text];
    }
}
-(void)showSendButton{
    if (_sendBtn.isHidden) {
        [_sendBtn setHidden:NO];
        [_plusBtn setHidden:YES];
    }
    
}
-(void)hideSendButton{
    if (!_sendBtn.isHidden) {
        [_sendBtn setHidden:YES];
        [_plusBtn setHidden:NO];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)plusBtnAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(plusButtonSingleTouch)]) {

#warning -wait for image select
        [self.delegate plusButtonSingleTouch];
    }
}
-(void)faceBtnAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(expressionButtonSingleTouch)]) {
        [self.delegate expressionButtonSingleTouch];
    }
}
-(void)soundButtonTouchDownAciton{
    [[AudioManager sharedInstance] recorderStart];
    
}
-(void)soundButtonTouchUpInsideAciton{
    [[AudioManager sharedInstance] recorderEnd];
    
    
    [[AudioManager sharedInstance]playerStart];
#warning - todo save audio data
//    
//    NSString *docDir = [FileUtil getAppDocumentDir];
//    NSString *playname = [NSString stringWithFormat:@"%@/play.aac",docDir];

    
}
-(void)soundButtonTouchTouchUpOutsideAction{
    [[AudioManager sharedInstance] recorderEnd];
}
- (void)updateConstraints {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_viewHeight);
        make.centerX.mas_equalTo(self.superview);
    }];
    
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_viewHeight - COMMON_ICON_SIZE/2);
    }];
    [super updateConstraints];
}
@end
