//
//  ChatToolView.h
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatToolViewDelegate <NSObject>

-(void)sendMessageAction:(NSString*)text;
-(void)sendImageMessageAction:(NSString*)image;
@end

@interface ChatToolView : UIView
@property (nonatomic,strong) UIButton       *leftBtn;
@property (nonatomic,strong) UITextView     *contentView;
@property (nonatomic,strong) UIButton       *sendBtn;
@property (nonatomic,strong) UIButton       *faceBtn;
@property (nonatomic,strong) UIButton       *plusBtn;
@property (nonatomic, assign) CGFloat      viewHeight;
@property (nonatomic, assign)  id<ChatToolViewDelegate>  delegate;
@end
