//
//  FriendAvatarCollectionViewCell.h
//  BarrageClient
//
//  Created by HuangCharlie on 1/30/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.pb.h"

#define CELL_AVATAR_HEIGHT 50
#define CELL_NAME_HEIGHT 20
#define CELL_PADDING 5

@interface FriendAvatarCollectionViewCell : UICollectionViewCell

- (void)updateWithUser:(PBUser*)pbUser
   superViewController:(id)superViewController;

- (void)updateWithAddButt;
- (void)updateWithDelButt;

- (void)showDeleteImg;
- (void)hideDeleteImg;

@end
