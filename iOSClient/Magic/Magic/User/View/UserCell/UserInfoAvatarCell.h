//
//  UserCell.h
//  BarrageClient
//
//  Created by gckj on 15/1/2.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//  个人详细资料中，头像那一行的Cell

#import <UIKit/UIKit.h>
#import "Masonry.h"

#define kUserInfoAvatarCellHeight 80    
#define kUserInfoAvatarHeight kUserInfoAvatarCellHeight*0.618

@class UserAvatarView;
@class PBUser;
@interface UserInfoAvatarCell : UITableViewCell

@property (nonatomic,strong) UserAvatarView *avatar;
@property (nonatomic,strong) UIViewController *superController;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               user:(PBUser*)user;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               user:(PBUser*)user
    superController:(UIViewController *)controller;
@end
