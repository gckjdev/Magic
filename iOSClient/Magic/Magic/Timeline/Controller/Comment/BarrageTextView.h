//
//  BarrageTextView.h
//  BarrageClient
//
//  Created by pipi on 14/12/17.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "Barrage.pb.h"
#import "BarrageTextFieldView.h"

@class BarrageTextView;



typedef void (^LongPressBlock) (BarrageTextView* bView);
typedef void (^KeyboardFinishBlock) ();

@interface BarrageTextView : UIView

@property (nonatomic, strong)       LongPressBlock longPressBlock;
@property (nonatomic,strong)        KeyboardFinishBlock keyboardFinishBlock;
@property (nonatomic, strong)       PBFeedActionBuilder* textBuilder;
@property (nonatomic,   copy)       NSString *editText;
@property (nonatomic, strong)       BarrageTextFieldView* textFieldView;



+(instancetype)initWithFeedAction:(PBFeedAction*)feedAction
                             mode:(BarrageTextModeType) modeType;
- (void)updateViewWithData:(PBFeedActionBuilder*)data;

-(void)setBackgroundColorTrans:(BOOL)hasBg
                    animation :(BOOL)animation;

-(void)setTextColor:(UIColor*)color;


-(void)setIsReversal:(BOOL)isReversal
           animation:(BOOL)animation;

-(PBFeedAction*)getBarrageData;
@end
