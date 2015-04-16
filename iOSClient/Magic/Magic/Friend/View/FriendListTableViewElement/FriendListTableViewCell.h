//
//  FriendListTableViewCell.h
//  BarrageClient
//
//  Created by HuangCharlie on 1/28/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.pb.h"

typedef void (^ClickButtonAction) (NSIndexPath* indexPath);

@interface FriendListTableViewCell : UITableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier;

- (void)updateWithUser:(PBUser*)pbUser indexPath:(NSIndexPath*)indexPath;

@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic,copy) ClickButtonAction clickAddActionBlock;

@end
