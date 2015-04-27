//
//  ChatToolView.h
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MESSAGE_HAVE_TEXT       @"MESSAGE_HAVE_TEXT"
#define MESSAGE_HAVE_NO_TEXT    @"MESSAGE_HAVE_NO_TEXT"

@protocol ChatToolViewDelegate <NSObject>

@optional
-(void)sendMessageButtonSingleTouch:(NSString*)text;
-(void)plusButtonSingleTouch;
-(void)expressionButtonSingleTouch;
@end

@interface ChatToolView : UIView

@property (nonatomic, assign)  id<ChatToolViewDelegate>  delegate;
@property (nonatomic, assign) CGFloat      viewHeight;
@property (nonatomic,strong) UITextView     *contentView;
@property (nonatomic,strong) UILabel        *placeHolder;
@end
