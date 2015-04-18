//
//  ChatCellFrame.m
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import "ChatCellFrame.h"
#import "NSString+Extension.h"

#define kIconMarginX 5
#define kIconMarginY 5

@implementation ChatCellFrame
-(void)setMessage:(ChatMessage *)message
{
    _message = message;
    CGFloat padding = 10;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    if (message.hideTime == NO) {
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeW = screenW;
        CGFloat timeH = 40;
        _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    }
    CGFloat iconY = CGRectGetMaxY(_timeF)+padding;
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    CGFloat iconX;
    if (message.type == MESSAGETYPE_OTHER) {
        iconX = padding;
    }else{
        iconX = screenW - padding - iconW;
    }
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat textX;
    CGFloat textY = iconY;
    CGSize showSize;
    if (_message.hasImage) {
        CGSize imageMaxSize = CGSizeMake(150, 150);
        showSize = imageMaxSize;
        
    }
    else if(_message.hasText){
        CGSize textMaxSize = CGSizeMake(200, MAXFLOAT);
        CGSize textRealSize = [message.content sizeWithFont:MJTextFont maxSize:textMaxSize];
        CGSize textBtnSize = CGSizeMake(textRealSize.width + MJTextPadding*2, textRealSize.height + MJTextPadding*2);
        showSize = textBtnSize;
    }
    
    
    
    if (message.type == MESSAGETYPE_OTHER) {
        textX = CGRectGetMaxX(_iconF) + padding;
    }else{
        textX = iconX - padding - showSize.width;
    }
    
    _textF = (CGRect){{textX,textY},showSize};
    CGFloat textMaxY = CGRectGetMaxY(_textF);
    CGFloat iconMaxY = CGRectGetMaxY(_iconF);
    _cellHeight = MAX(textMaxY,iconMaxY)+padding;
    
    _imageF = (CGRect){{textX,textY},showSize};
    
}
@end
