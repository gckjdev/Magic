//
//  ShareToWhichFriendViewController.h
//  BarrageClient
//
//  Created by HuangCharlie on 1/25/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShareToFriendCallBack)(NSArray* shareToWhoList);

@interface ShareToWhichFriendViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *shareToList;
@property (nonatomic,strong) ShareToFriendCallBack callBack;

- (NSMutableArray*)getFinalShareToList;

@end
