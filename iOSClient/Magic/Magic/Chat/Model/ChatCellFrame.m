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
#import "UIImageView+WebCache.h"

#define kIconMarginX 5
#define kIconMarginY 5

#define ICONSIZE 40.0f

#define SMALL_ICON_SIZE 20.0f

#define CELLPADDING 0.0f

#define COMMON_SPACE 6.0f

#define COMMON_MID_SPACE 20.0f


#define IMAGE_MAX_SIZE (150.0f)

#define TEXT_MAX_WIDTH 200.0f

#define CONTENT_MAX_WIDTH 200.0f
#define CONTENT_MIN_WIDTH 70.0f

#define CONTENT_MIN_HEIGHT 50.0f

@implementation ChatCellFrame
-(void)setMessage:(ChatMessage *)message
{
    _message = message;

   
    if (message.hideTime == NO) {
        CGFloat timeX = 0;
        CGFloat timeY = CELLPADDING;
        CGFloat timeW = kScreenWidth;
        CGFloat timeH = ICONSIZE;
        _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    }
    else{
        _timeF = CGRectZero;
    }
    CGFloat iconY = CGRectGetMaxY(_timeF)+COMMON_SPACE;
    CGFloat iconW = ICONSIZE;
    CGFloat iconH = ICONSIZE;
    CGFloat iconX;
  
    if (message.fromType == MESSAGEFROMTYPE_OTHER) {
        iconX = COMMON_SPACE;
    }else{
        iconX = kScreenWidth - COMMON_SPACE - iconW;
    }
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat contentX;
    CGFloat contentY = iconY;
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
    else if (_message.type == MESSAGETYPE_VOICE){
        
        CGSize textBtnSize = [self getVoiceContentSize:message.voiceDuration];
        showSize = textBtnSize;
    }
    
    
    if (message.fromType == MESSAGEFROMTYPE_OTHER) {
        contentX = CGRectGetMaxX(_iconF) + COMMON_SPACE;
    }else{
        contentX = iconX - COMMON_SPACE - showSize.width;
    }
    
  
    if (_message.type == MESSAGETYPE_IMAGE) {
        _imageF = (CGRect){{contentX,contentY},showSize};
        _contentF = CGRectMake(contentX, contentY, IMAGE_MAX_SIZE, IMAGE_MAX_SIZE);
    }
    else if(_message.type == MESSAGETYPE_TEXT){
        _textF = (CGRect){{contentX,contentY},showSize};
        _contentF = (CGRect){{contentX,contentY},showSize};
    }
    else if(_message.type == MESSAGETYPE_VOICE){
        
         _contentF = (CGRect){{contentX,contentY},showSize};
        
        if (_message.fromType == MESSAGEFROMTYPE_ME) {
            CGFloat voicePosX = contentX + showSize.width - SMALL_ICON_SIZE - MJTextPadding;
            CGFloat voicePosY = contentY + (showSize.height - SMALL_ICON_SIZE)/2;
            _voiceAnimationF = (CGRect){{voicePosX,voicePosY},CGSizeMake(SMALL_ICON_SIZE, SMALL_ICON_SIZE)};
           
            
            CGFloat durationPoxX = CGRectGetMinX(_contentF) - COMMON_MID_SPACE ;
            CGFloat durationPoxY = CGRectGetMinY(_contentF);
            CGFloat durationWidth = SMALL_ICON_SIZE;
            CGFloat durationHeight = CGRectGetHeight(_contentF);
            _voiceDurationF = CGRectMake(durationPoxX, durationPoxY, durationWidth, durationHeight);
        }
        else{
            CGFloat contentMaxX = CGRectGetMaxX(_contentF);
            CGFloat voicePosX = CGRectGetMinX(_contentF)  + MJTextPadding;
            CGFloat voicePosY = contentY + (showSize.height - SMALL_ICON_SIZE)/2;
            _voiceAnimationF = (CGRect){{voicePosX,voicePosY},CGSizeMake(SMALL_ICON_SIZE, SMALL_ICON_SIZE)};
            
            
            CGFloat durationPoxX = contentMaxX  ;
            CGFloat durationPoxY = CGRectGetMinY(_contentF);
            CGFloat durationWidth = SMALL_ICON_SIZE;
            CGFloat durationHeight = CGRectGetHeight(_contentF);
            _voiceDurationF = CGRectMake(durationPoxX, durationPoxY, durationWidth, durationHeight);
        }
     
        
    }
    
    
    CGFloat contentMaxY = CGRectGetMaxY(_contentF);
    CGFloat iconMaxY = CGRectGetMaxY(_iconF);
    _cellHeight = MAX(contentMaxY,iconMaxY)+CELLPADDING;
}

-(CGSize)getVoiceContentSize:(NSInteger)duration{
    CGSize result;
    if (duration<1) {
        result = CGSizeMake(CONTENT_MIN_WIDTH, CONTENT_MIN_HEIGHT);
    }
    else if (duration<60){
        CGFloat resultWidth = CONTENT_MIN_WIDTH + (CONTENT_MAX_WIDTH - CONTENT_MIN_HEIGHT)*(duration/60.f);
        
        result = CGSizeMake(resultWidth, CONTENT_MIN_HEIGHT);
        
    }
    else{
        result = CGSizeMake(CONTENT_MAX_WIDTH, CONTENT_MIN_HEIGHT);
    }
    return result;
}
@end
