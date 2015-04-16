//
//  FriendAvatarCollectionViewCell.m
//  BarrageClient
//
//  Created by HuangCharlie on 1/30/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "FriendAvatarCollectionViewCell.h"
#import "UserAvatarView.h"
#import <Masonry.h>
#import "ColorInfo.h"
#import "FontInfo.h"
#import "PPDebug.h"
#import "UserManager.h"

@interface FriendAvatarCollectionViewCell ()
{

}

@property (nonatomic,strong) UserAvatarView *avatarView;
@property (nonatomic,strong) UIImageView *deleteImg;
@property (nonatomic,strong) UILabel *userNameView;

@end

@implementation FriendAvatarCollectionViewCell

- (void)updateWithUser:(PBUser*)pbUser
   superViewController:(id)superViewController
{
    for (UIView* subview in self.contentView.subviews){
        [subview removeFromSuperview];
    }
    
    CGRect avatarFrame = CGRectMake(0, 0, CELL_AVATAR_HEIGHT,CELL_AVATAR_HEIGHT);
    self.avatarView = [[UserAvatarView alloc]initWithUser:nil frame:avatarFrame borderWidth:0];
    self.avatarView.delegate = superViewController;
    [self.contentView addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(CELL_PADDING);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@(CELL_AVATAR_HEIGHT));
    }];
    
    self.deleteImg = [[UIImageView alloc]init];
    [self.deleteImg setImage:[UIImage imageNamed:@"delete_topright.png"]];
    [self.contentView addSubview:self.deleteImg];
    [self.deleteImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top).with.offset(CELL_PADDING);
    }];
    
    self.userNameView = [[UILabel alloc]init];
    [self.userNameView setFont:FRIEND_AVATAR_LABEL_FONT];
    [self.userNameView setTextColor:BARRAGE_LABEL_GRAY_COLOR];
    [self.userNameView setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.userNameView];
    [self.userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_left);
        make.right.equalTo(self.avatarView.mas_right);
        make.top.equalTo(self.avatarView.mas_bottom);
        make.height.equalTo(@(20));//TODO
    }];
    
    if(pbUser == nil)
    {
        PPDebug(@"<tag detail> pbuser nil ");
    }
    else{
        if([pbUser.userId isEqualToString:[[UserManager sharedInstance] userId]])
            [self.userNameView setText:@"我"];
        else
            [self.userNameView setText:pbUser.nick];
        
        [self.avatarView updateUser:pbUser];
    }
    
}


- (void)updateWithAddButt
{
    UIImage *addImg = [UIImage imageNamed:@"pick_friend_add.png"];
    UIImageView *addImgView = [[UIImageView alloc]initWithImage:addImg];
    [self.contentView addSubview:addImgView];
    [addImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(CELL_PADDING);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(CELL_AVATAR_HEIGHT));
    }];
}

- (void)updateWithDelButt
{
    UIImage *delImg = [UIImage imageNamed:@"pick_friend_delete.png"];
    UIImageView *delImgView = [[UIImageView alloc]initWithImage:delImg];
    [self.contentView addSubview:delImgView];
    [delImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(CELL_PADDING);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(CELL_AVATAR_HEIGHT));
    }];
}

- (void)showDeleteImg
{
    self.deleteImg.hidden = NO;
}

- (void)hideDeleteImg
{
    self.deleteImg.hidden = YES;
}


@end
