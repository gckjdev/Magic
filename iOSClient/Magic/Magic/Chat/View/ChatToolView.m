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
#import "UIImageUtil.h"


#define COMMON_ICON_SIZE 40.0f

@interface ChatToolView()
@property (nonatomic,strong) UIButton       *soundBtn;

@property (nonatomic,strong) UIButton       *sendBtn;
@property (nonatomic,strong) UIButton       *faceBtn;
@property (nonatomic,strong) UIButton       *plusBtn;

@property (nonatomic,strong) UIButton       *talkButton;
@property (nonatomic, assign) BOOL          isTalkMode;
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
#pragma mark - setup
-(void)setupView{
    
    _isTalkMode = NO;
    
    [self setupSoundButton];
    [self setupContentView];
    [self setupPlaceHolder];
    [self setupTalkButton];
    [self setupPlusButton];
    [self setupSendButton];
 

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showSendButton) name:@"MESSAGE_HAVE_TEXT" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideSendButton) name:@"MESSAGE_HAVE_NO_TEXT" object:nil];
}

-(void)setupSoundButton{
    _soundBtn = [[UIButton alloc]init];
    [_soundBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
    [_soundBtn setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
    
    [self addSubview:_soundBtn];
    [_soundBtn addTarget:self action:@selector(soundButtonTouchUpInsideAciton) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_soundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(COMMON_ICON_SIZE, COMMON_ICON_SIZE));
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
}

-(void)setupContentView{
    
    _contentView = [[UITextView alloc]init];
    _contentView.backgroundColor = BARRAGE_BG_COLOR;
    [self addSubview:_contentView];
}

-(void)setupPlaceHolder{
    
    _placeHolder = [[UILabel alloc]init];
    [_placeHolder setUserInteractionEnabled:NO];
    [_placeHolder setText:@"请问需要什么服务"];
    [_placeHolder setFont:BARRAGE_LITTLE_LABEL_FONT];
    [_placeHolder setTextColor:COLOR255(0,0,0,100)];
    [_placeHolder setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:_placeHolder];
    [_placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(COMMON_ICON_SIZE+5);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-COMMON_ICON_SIZE);
        make.height.equalTo(self);
    }];
    
}

-(void)setupTalkButton{
    
    _talkButton = [[UIButton alloc]init];
    [_talkButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_talkButton setTitle:@"松开 结束"  forState:UIControlStateHighlighted];
    [_talkButton.titleLabel  setFont:BARRAGE_TEXTFIELD_FONT];
    [_talkButton setTitleColor:COLOR255(0,0,0,200) forState:UIControlStateNormal];
    [_talkButton setBackgroundImage:[UIImage imageWithColor:COLOR255(0,0,0,60)] forState:UIControlStateHighlighted];
    [_talkButton setHidden:YES];
    [_talkButton.layer setBorderWidth:1.0];
    [_talkButton setClipsToBounds:YES];
    [_talkButton.layer setCornerRadius:5.0];
    UIColor *borderColor = COLOR255(0,0,0,100);
    [_talkButton.layer setBorderColor: borderColor.CGColor];
    [self addSubview:_talkButton];
    [_talkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(COMMON_ICON_SIZE);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-COMMON_ICON_SIZE);
        make.height.mas_equalTo(@(COMMON_ICON_SIZE - COMMON_ICON_SIZE/4));
    }];
    
    [_talkButton addTarget:self action:@selector(talkButtonTouchDownAction) forControlEvents:UIControlEventTouchDown];
    [_talkButton addTarget:self action:@selector(talkButtonTouchUpInsideAction) forControlEvents:UIControlEventTouchUpInside];
    [_talkButton addTarget:self action:@selector(talkButtonTouchCancelAction) forControlEvents:UIControlEventTouchCancel];
}


-(void)setupPlusButton{
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
}

-(void)setupSendButton{
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
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    [_contentView becomeFirstResponder];
}

#pragma mark - Action



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
    _isTalkMode = !_isTalkMode;
    
    if (_isTalkMode) {
        [_talkButton setHidden:NO];
        [_contentView setHidden:YES];
        [_placeHolder setHidden:YES];
        
        [_soundBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard"]
                   forState:UIControlStateNormal];
        [_soundBtn setImage:[UIImage imageNamed:@"ToolViewKeyboardHL"]
                   forState:UIControlStateHighlighted];
    }
    else{
        [_talkButton setHidden:YES];
        [_contentView setHidden:NO];
        [_placeHolder setHidden:NO];
        [_soundBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [_soundBtn setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
    }
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(changeInputMode:textView:)]) {
        [self.delegate changeInputMode:_isTalkMode textView:_contentView];
    }
    
}


-(void)talkButtonTouchDownAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkButtonTouchDown)]) {
        [self.delegate talkButtonTouchDown];
    }
}

-(void)talkButtonTouchUpInsideAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkButtonTouchUpInside)]) {
        [self.delegate talkButtonTouchUpInside];
    }
}

-(void)talkButtonTouchCancelAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(talkButtonTouchCancel)]) {
        [self.delegate talkButtonTouchCancel];
    }
}

- (void)updateConstraints {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_viewHeight);
        make.centerX.mas_equalTo(self.superview);
        
        make.bottom.mas_equalTo(self.superview.mas_bottom);
        make.width.mas_equalTo(kScreenWidth);
      
        
    }];
    
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_viewHeight - COMMON_ICON_SIZE/2);
        
        make.left.equalTo(self).offset(COMMON_ICON_SIZE);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-COMMON_ICON_SIZE);
    }];
    [super updateConstraints];
}
@end
