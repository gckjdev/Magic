//
//  UserDetailCell.h
//  BarrageClient
//
//  Created by 蔡少武 on 15/3/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAvatarView.h"
#import "THLabel.h"

@class PBUser;

@interface UserDetailCell : UITableViewCell
@property (nonatomic,strong)UserAvatarView *avatarView;
@property (nonatomic,strong)THLabel *nickNameLabel;
@property (nonatomic,strong)THLabel *sinatureLabel;
//@property (nonatomic,strong)UILabel *tagTextLabel;
@property (nonatomic,strong)UILabel *tagDetailTextLabel;
//@property (nonatomic,strong)UILabel *locationTextLabel;
@property (nonatomic,strong)UILabel *locationDetailTextLabel;
@property (nonatomic,strong)UIImageView *backgroundImageView;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               user:(PBUser*)user;

@end
