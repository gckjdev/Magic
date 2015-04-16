//
//  PickFriendTableViewCell.h
//  BarrageClient
//
//  Created by HuangCharlie on 2/2/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.pb.h"

@interface PickFriendTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier;

- (void)updateWithUser:(PBUser*)pbUser;

@end
