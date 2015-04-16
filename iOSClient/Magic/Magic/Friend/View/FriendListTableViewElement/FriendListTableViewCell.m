//
//  FriendListTableViewCell.m
//  BarrageClient
//
//  Created by HuangCharlie on 1/28/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "FriendListTableViewCell.h"
#import <Masonry.h>
#import "UserAvatarView.h"
#import "User.pb.h"
#import "UIViewUtils.h"
#import "UserManager.h"

#define BUTT_WIDTH 58
#define BUTT_HEIGHT 26

@interface FriendListTableViewCell ()
{
}

@property (nonatomic, strong) UserAvatarView *avatarView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *sigLabel;
@property (nonatomic, strong) UIButton *statusButt;


@end

@implementation FriendListTableViewCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中时候的灰色
    
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
    self.avatarView = [[UserAvatarView alloc] initWithUser:nil frame:avatarFrame borderWidth:0.0f];
    [self addSubview:self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(COMMON_PADDING);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(AVATAR_HEIGHT));
        make.height.equalTo(@(AVATAR_HEIGHT));
    }];
    
    self.nickLabel = [[UILabel alloc]init];
    [self.nickLabel setFont:BARRAGE_BUTTON_FONT];
    [self.nickLabel setTextColor:BARRAGE_LABEL_COLOR];
    [self addSubview:self.nickLabel];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).with.offset(COMMON_PADDING);
        make.centerY.equalTo(self.mas_centerY);
    }];

    //avatar, name && signature
    self.sigLabel = [[UILabel alloc]init];
    [self.sigLabel setFont:BARRAGE_LITTLE_LABEL_FONT];
    [self.sigLabel setTextColor:BARRAGE_LABEL_GRAY_COLOR];
    [self.sigLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:self.sigLabel];
    [self.sigLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-COMMON_PADDING);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).with.offset(self.frame.size.width/2);
    }];
    
    //avatar, name && status
    self.statusButt = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.statusButt setBackgroundColor:BARRAGE_RED_COLOR];
    [self.statusButt setTitleColor:BUTTON_TITLE_COLOR forState:UIControlStateNormal];
    [self.statusButt.titleLabel setFont:BARRAGE_LITTLE_LABEL_FONT];
    [self addSubview:self.statusButt];
    [self.statusButt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-COMMON_PADDING);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(BUTT_WIDTH));
        make.height.equalTo(@(BUTT_HEIGHT));
    }];
    SET_VIEW_ROUND_CORNER_RADIUS(self.statusButt, BUTT_HEIGHT/2)
    [self.statusButt addTarget:self action:@selector(clickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)updateWithUser:(PBUser*)pbUser indexPath:(NSIndexPath*)indexPath
{
    if (indexPath){
        self.indexPath = indexPath;
    }
    
    [self.avatarView updateUser:pbUser];
    [self.sigLabel setTextColor:BARRAGE_LABEL_GRAY_COLOR];
    
    //如果是自己，则昵称显示为“我”，而且不显示签名
    BOOL flag=([pbUser.userId isEqualToString:[[UserManager sharedInstance]userId]]);
    if(flag){
        [self.nickLabel setText:@"我"];
        [self.sigLabel setHidden:YES];
        [self.statusButt setHidden:YES];
        return;
    }
    
    //如果不是自己，则做一些好友状态判断
    [self.nickLabel setText:pbUser.nick];
    if(pbUser.hasAddStatus && pbUser.addStatus == FriendAddStatusTypeReqAccepted)
    {
        self.sigLabel.hidden = NO;
        self.statusButt.hidden = YES;
        [self.sigLabel setText:pbUser.signature];
    }
    else{
        if (pbUser.addDir == FriendRequestDirectionReqDirectionReceiver){
            if (pbUser.addStatus == FriendAddStatusTypeReqWaitAccept)
            {
                self.statusButt.hidden = NO;
                self.sigLabel.hidden = YES;
                [self.statusButt setTitle:@"同意" forState:UIControlStateNormal];
            }
            else if (pbUser.addStatus == FriendAddStatusTypeReqRejected)
            {
                self.statusButt.hidden = NO;
                self.sigLabel.hidden = YES;
                [self.statusButt setTitle:@"已拒绝" forState:UIControlStateNormal];
            }
            else{
                self.statusButt.hidden = YES;
                self.sigLabel.hidden = NO;
                [self.statusButt setTitle:@"" forState:UIControlStateNormal];
            }
        }
        else{
            // sender
            if (pbUser.addStatus == FriendAddStatusTypeReqWaitAccept)
            {
                self.statusButt.hidden = YES;
                self.sigLabel.hidden = NO;
                [self.sigLabel setText:@"待接受"];
                [self.sigLabel setTextColor:BARRAGE_RED_COLOR];
            }
            else if (pbUser.addStatus == FriendAddStatusTypeReqRejected)
            {
                self.statusButt.hidden = NO;
                self.sigLabel.hidden = YES;
                [self.statusButt setTitle:@"已拒绝" forState:UIControlStateNormal];
            }
            else{
                self.statusButt.hidden = YES;
                self.sigLabel.hidden = NO;
                [self.statusButt setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
}

- (void)clickStatusButton:(id)sender
{
    EXECUTE_BLOCK(self.clickAddActionBlock, self.indexPath);
}

@end
