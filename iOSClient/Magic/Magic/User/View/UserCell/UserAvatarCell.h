//
//  UserAvatarCell.h
//  BarrageClient
//
//  Created by 蔡少武 on 14/12/26.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewUtils.h"

@class UserAvatarView;
@class PBUser;

typedef void (^ClickNickNameLabelBlock)(void);

@interface UserAvatarCell : UITableViewCell
{
    float buttonWidthHeight;
}
@property (nonatomic,strong) UserAvatarView *userAvatarView;
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UILabel *nickNameLabel;
@property (nonatomic,strong) UIViewController  *superViewController;
@property (nonatomic,strong) PBUser *user;
@property (nonatomic,assign) BOOL hasBackgroundImageView;
@property (nonatomic,strong) ClickNickNameLabelBlock clickNickNameLabelBlock;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               user:(PBUser*)user;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               user:(PBUser*)user
superViewController:(UIViewController *)superViewController;

@end
