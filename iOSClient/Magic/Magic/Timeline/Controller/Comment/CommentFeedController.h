//
//  CommentFeedController.h
//  BarrageClient
//
//  Created by pipi on 14/12/5.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//


#import "BCUIViewController.h"

#import <UIKit/UIKit.h>

@class Feed;

@interface CommentFeedController : BCUIViewController


+ (CommentFeedController*)showFromController:(UIViewController*)fromController
                                    withFeed:(Feed*)feed
                                    startPos:(CGPoint)point;

@end
