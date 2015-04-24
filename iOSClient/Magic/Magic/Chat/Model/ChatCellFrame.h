//
//  ChatCellFrame.h
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessage.h"
#import <UIKit/UIKit.h>

#define MJTextFont [UIFont systemFontOfSize:15]
// 正文的内边距
#define MJTextPadding 20



@interface ChatCellFrame : NSObject
@property (nonatomic,assign,readonly) CGRect        iconF;
@property (nonatomic,assign,readonly) CGRect        timeF;
@property (nonatomic,assign,readonly) CGRect        textF;
@property (nonatomic, assign,readonly) CGRect       imageF;
@property (nonatomic, assign,readonly) CGRect       contentF;
@property (nonatomic,assign,readonly) CGFloat       cellHeight;
@property (nonatomic,strong) ChatMessage *message;
@end
