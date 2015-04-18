//
//  ChatToolView.m
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import "ChatToolView.h"
#import "Masonry.h"
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
    _leftBtn = [[UIButton alloc]init];
    [_leftBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_press"] forState:UIControlStateHighlighted];
    [self addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    
    _contentView = [[UITextView alloc]init];
    _contentView.backgroundColor = [UIColor colorWithWhite:0.870 alpha:1.000];
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self).offset(40);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-80);
        make.height.mas_equalTo(@30);
    }];
    
    _sendBtn = [[UIButton alloc]init];
    _sendBtn.hidden = YES;
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self addSubview:_sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    
    _faceBtn = [[UIButton alloc]init];
    [_faceBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    [_faceBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_press"] forState:UIControlStateHighlighted];
    [_faceBtn addTarget:self action:@selector(faceBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_faceBtn];
    [_faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(self).offset(-40);
        make.centerY.equalTo(self);
    }];
    
    _plusBtn = [[UIButton alloc]init];
    
    [_plusBtn setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
    [_plusBtn setImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateHighlighted];
    [_plusBtn addTarget:self action:@selector(plusBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_plusBtn];
    
    [_plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    
    
}
-(void)plusBtnAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sendMessageAction:)]) {
        [self.delegate sendMessageAction:_contentView.text];
    }
}
-(void)faceBtnAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sendImageMessageAction:)]) {
        ;
    }
}
- (void)updateConstraints {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_viewHeight);
    }];
    
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_viewHeight - 20);
    }];
    [super updateConstraints];
}
@end
