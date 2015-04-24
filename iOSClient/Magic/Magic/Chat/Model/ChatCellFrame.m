//
//  ChatCellFrame.m
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import "ChatCellFrame.h"
#import "NSString+Extension.h"
#import "UIViewUtils.h"

#define kIconMarginX 5
#define kIconMarginY 5

#define ICONSIZE 40.0f

#define CELLPADDING 5.0f

#define COMMON_SPACE 10.0f

#define IMAGE_MAX_SIZE 150.0f

#define TEXT_MAX_WIDTH 200.0f

@implementation ChatCellFrame
-(void)setMessage:(ChatMessage *)message
{
    _message = message;
//    CGFloat padding = 10;
   
    if (message.hideTime == NO) {
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeW = kScreenWidth;
        CGFloat timeH = ICONSIZE;
        _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    }
    else{
        _timeF = CGRectZero;
    }
    CGFloat iconY = CGRectGetMaxY(_timeF)+CELLPADDING;
    CGFloat iconW = ICONSIZE;
    CGFloat iconH = ICONSIZE;
    CGFloat iconX;
  
    if (message.fromType == MESSAGEFROMTYPE_OTHER) {
        iconX = COMMON_SPACE;
    }else{
        iconX = kScreenWidth - COMMON_SPACE - iconW;
    }
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat textX;
    CGFloat textY = iconY;
    CGSize showSize;
    if (_message.type == MESSAGETYPE_IMAGE) {
        CGSize imageMaxSize = CGSizeMake(IMAGE_MAX_SIZE, IMAGE_MAX_SIZE);
        showSize = imageMaxSize;
        
    }
    else if(_message.type == MESSAGETYPE_TEXT){
        CGSize textMaxSize = CGSizeMake(TEXT_MAX_WIDTH, MAXFLOAT);
        CGSize textRealSize = [message.content sizeWithFont:MJTextFont maxSize:textMaxSize];
        CGSize textBtnSize = CGSizeMake(textRealSize.width + MJTextPadding*2, textRealSize.height + MJTextPadding*2);
        showSize = textBtnSize;
    }
    
    
    
    if (message.fromType == MESSAGEFROMTYPE_OTHER) {
        textX = CGRectGetMaxX(_iconF) + COMMON_SPACE;
    }else{
        textX = iconX - COMMON_SPACE - showSize.width;
    }
    
    _textF = (CGRect){{textX,textY},showSize};
    CGFloat textMaxY = CGRectGetMaxY(_textF);
    CGFloat iconMaxY = CGRectGetMaxY(_iconF);
    _cellHeight = MAX(textMaxY,iconMaxY)+CELLPADDING;
    
    _imageF = (CGRect){{textX,textY},showSize};
    
}
@end
