//
//  MessageTableView.h
//  talking
//
//  Created by Teemo on 15/4/10.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.pb.h"


@interface MessageTableView : UITableView

@property (nonatomic, strong) NSArray   *messageFrames;
@property (nonatomic, assign) CGFloat   viewHeight;
@property (nonatomic, assign) id      controller;
@property (nonatomic,strong) NSIndexPath   *playingCellPath;

-(void)refreshData;
-(void)stopPlayingCellAnimation;
-(void)startPlayingCellAnimation;
@end
