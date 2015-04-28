//
//  MessageTableView.h
//  talking
//
//  Created by Teemo on 15/4/10.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.pb.h"

@class ChatCell;
typedef void  (^ImageViewSinglePressBlock)(PBChat* pbChat,UIImage *image);
typedef void  (^VoiceViewSinglePressBlock)(PBChat* pbChat,ChatCell *cell);

@interface MessageTableView : UITableView

@property (nonatomic, strong) NSArray   *messageFrames;
@property (nonatomic, assign) CGFloat   viewHeight;
@property (nonatomic, assign) id      controller;
@property (nonatomic,copy) ImageViewSinglePressBlock imageViewSinglePressBlock;
@property (nonatomic,copy) VoiceViewSinglePressBlock voiceViewSinglePressBlock;
-(void)RefreshData;

@end
