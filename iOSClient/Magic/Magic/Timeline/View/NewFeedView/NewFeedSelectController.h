//
//  NewFeedSelectController.h
//  BarrageClient
//
//  Created by Teemo on 15/3/25.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "BCUIViewController.h"
#import "Feed.h"

@interface NewFeedSelectController : BCUIViewController
+(instancetype)initWithFeed:(Feed*)feed;
-(void)updateData:(Feed*)feed;
@end
