//
//  PickFriendTableViewCell.m
//  BarrageClient
//
//  Created by HuangCharlie on 2/2/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "PickFriendTableViewCell.h"
#import "UserAvatarView.h"
#import "ColorInfo.h"
#import "UIViewUtils.h"
#import <Masonry.h>

#define LARGE_PADDING 18

@interface PickFriendTableViewCell ()
{
    UserAvatarView *avatarView;
    UILabel *nickLabel;
}

@end

@implementation PickFriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.backgroundColor = BUTTON_TITLE_COLOR;
    
    //clever line
    UIView* lineView = [[UIView alloc]init];
    lineView.backgroundColor = TABLE_CELL_LINE_COLOR;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    CGRect avatarFrame = CGRectMake(0, 0, AVATAR_HEIGHT, AVATAR_HEIGHT);
    avatarView = [[UserAvatarView alloc] initWithUser:nil frame:avatarFrame];
    [self addSubview:avatarView];
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(LARGE_PADDING);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(AVATAR_HEIGHT));
        make.height.equalTo(@(AVATAR_HEIGHT));
    }];
    
    nickLabel = [[UILabel alloc]init];
    [nickLabel setFont:BARRAGE_BUTTON_FONT];
    [nickLabel setTextColor:BARRAGE_LABEL_COLOR];
    [self addSubview:nickLabel];
    [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).with.offset(COMMON_PADDING);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    return self;
}

- (void)updateWithUser:(PBUser*)pbUser
{
    [avatarView updateUser:pbUser];
    [nickLabel setText:pbUser.nick];
}

@end
