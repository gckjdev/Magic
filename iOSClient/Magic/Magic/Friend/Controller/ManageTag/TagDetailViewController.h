//
//  TagDetailViewController.h
//  BarrageClient
//
//  Created by HuangCharlie on 1/30/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.pb.h"
#import "BCUIViewController.h"

@interface TagDetailViewController : BCUIViewController

@property (nonatomic,strong) PBUserTag *currentTag;
@property (nonatomic,strong) NSArray* currentUserList;

- (instancetype)initWithPbUserTag:(PBUserTag*)userTag;

@end
