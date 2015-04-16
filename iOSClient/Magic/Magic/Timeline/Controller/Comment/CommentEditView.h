//
//  CommentEditView.h
//  BarrageClient
//
//  Created by pipi on 14/12/17.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Barrage.pb.h"
#import "BarrageTextView.h"

@class Feed;

@interface CommentEditView : UIView

@property (nonatomic, assign) CGPoint      barragePos;
@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic,copy) NSString *editText;
@property (nonatomic, strong) Feed* feed;
@property (nonatomic, strong) BarrageTextView* textInputView;
@property (nonatomic, assign) BOOL      hasGridsView;
@property (nonatomic, assign) BOOL      hasBarrageViews;

+(instancetype)editViewWithFeed:(Feed*)feed
                     barragePos:(CGPoint)barragePos;
- (void)setScale:(CGFloat)scale;

- (void)updateView:(Feed*)feed feedAction:(PBFeedActionBuilder*)actionBuilder;
- (void)resignKeyboard;
- (CGFloat)barragePosX;
- (CGFloat)barragePosY;
- (NSString*)barrageText;


@end
