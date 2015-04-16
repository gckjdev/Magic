//
//  FriendListTableView.h
//  BarrageClient
//
//  Created by HuangCharlie on 2/6/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.pb.h"


@protocol FriendListActionDelegate <NSObject>

@required
- (void)clickOnItem:(PBUser*)user;

@optional
- (void)clickDeteleButton;

@end


@interface FriendListTableView : UITableView

@property(nonatomic,strong) NSArray* pbFriendList;
@property(nonatomic,assign) id<FriendListActionDelegate> actionDelegate;

-(id)init;
-(void)updateTableView;

@end
