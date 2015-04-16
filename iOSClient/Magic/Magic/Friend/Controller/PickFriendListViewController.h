//
//  PickFriendListViewController.h
//  BarrageClient
//
//  Created by HuangCharlie on 2/2/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PickFriendCallback) (NSArray* friendList); // friendList is PBUser list

@interface PickFriendListViewController : UIViewController

//一开始就已经选中的人
@property (nonatomic,strong) NSArray* originPickedArray;

//用户选择后得出的结果
@property (nonatomic,strong) NSMutableArray* pickedFriends;

@property (nonatomic,strong) PickFriendCallback pickFriendCallback;

@end
