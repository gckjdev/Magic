//
//  TimelineCellHeaderView.m
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "TimelineCellHeaderView.h"
#import "UserAvatarView.h"
#import "Masonry.h"
#import "FontInfo.h"
#import "Feed.h"
#import "UIViewUtils.h"
#import "ViewInfo.h"
#import "DeviceDetection.h"
#import "Feed.h"

#define avatarMaxNum (ISIPAD ? 9 : 5)    //  头像最多显示数目
const CGFloat padding = 12;  //  相邻两个头像的间距

@interface TimelineCellHeaderView()

@property (nonatomic, strong) UILabel* userNickLabel;
@property (nonatomic, strong) UILabel* targetUsersLabel;

@property (nonatomic, strong) ButtonClickActionBlock clickDisplayUserBlock;

@property (nonatomic,assign) NSInteger avatarNum; //  要显示的avatar数目
@property (nonatomic,strong) UIView *avatarHolderview;  //  辅助view

@end

@implementation TimelineCellHeaderView

- (id)init
{
    self = [super init];
    if (self){
        
        // add avatar view
//        CGRect frame = CGRectMake(0, 0, TIMELINE_CELL_HEADER_AVATAR_WIDTH, TIMELINE_CELL_HEADER_AVATAR_HEIGHT);
//        self.avatarView = [[UserAvatarView alloc] initWithUser:nil frame:frame];
//        [self addSubview:self.avatarView];
//        [_avatarView mas_makeConstraints:^(MASConstraintMaker *make){
//            make.height.equalTo(@(TIMELINE_CELL_HEADER_AVATAR_HEIGHT));
//            make.width.equalTo(@(TIMELINE_CELL_HEADER_AVATAR_WIDTH));
//            make.centerY.equalTo(self.mas_centerY);
//            make.centerX.equalTo(self.mas_centerX);
//        }];
        
        
        // click arrow down users button
        self.displayUserButton = [UIView createButton:@"arrow_down.png"]; //[UIButton buttonWithType:UIButtonTypeContactAdd];
        [self addSubview:self.displayUserButton];
        [self.displayUserButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(@(TIMELINE_BUTTON_WIDTH));
            make.width.equalTo(@(TIMELINE_BUTTON_WIDTH));
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).with.offset(-TIMELINE_BUTTON_LEFT_SPACE);
        }];
        [self.displayUserButton addTarget:self action:@selector(clickDisplayUserButton:) forControlEvents:UIControlEventTouchUpInside];

        /*
        // add user nick label
        self.userNickLabel = [[UILabel alloc] init];
        [self.userNickLabel setText:@"皮皮彭"];
        [self.userNickLabel setFont:CELL_MAIN_FONT];
        [self addSubview:_userNickLabel];
        [_userNickLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.mas_centerY).with.dividedBy(2);
            make.left.equalTo(self.avatarView.mas_right).with.offset(5);
            make.right.equalTo(self.modifyUserButton.mas_left).with.offset(5);
        }];
        
        // add target users label
        self.targetUsersLabel = [[UILabel alloc] init];
        [self.targetUsersLabel setText:@"[参与] 皮皮彭、Mark Peng、Low"];
        [self.targetUsersLabel setFont:CELL_MAIN_FONT];
        [self addSubview:_targetUsersLabel];
        [_targetUsersLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.mas_centerY).with.dividedBy(2.0f/3.0f);
            make.left.equalTo(self.avatarView.mas_right).with.offset(5);
            make.right.equalTo(self.modifyUserButton.mas_left).with.offset(5);
        }];
        */

        
    }
    
    return self;
}

- (void)updateData:(Feed*)feed
{
    [self.userNickLabel setText:feed.feedBuilder.createUser.nick];
    CGRect frame = CGRectMake(0, 0, TIMELINE_CELL_HEADER_AVATAR_WIDTH, TIMELINE_CELL_HEADER_AVATAR_HEIGHT);
    
    if (_avatarHolderview) {
        [_avatarHolderview removeFromSuperview];
    }

    //  add creatUser on the first

    NSMutableArray *userArray = [[NSMutableArray alloc]initWithArray:[feed.feedBuilder toUsers]];

    _avatarNum = [userArray count] < avatarMaxNum ? [userArray count] : avatarMaxNum;     //    要显示的用户数目
    
    PBUser *user;
    NSMutableArray *avatarViewArr = [[NSMutableArray alloc]init];

    for (int i = 0; i<_avatarNum; i++) {
        user = (PBUser*)[userArray objectAtIndex:i];
        UserAvatarView *avatarView = [[UserAvatarView alloc]initWithUser:user
                                                                   frame:frame
                                                             borderWidth:0.0f];
        [avatarViewArr addObject:avatarView];
    }
    
    [self loadAvatarViewsWithNum:_avatarNum avatarViewArr:avatarViewArr];
}
//  加载分享好友的头像
- (void)loadAvatarViewsWithNum:(NSInteger)avatarNum avatarViewArr:(NSArray*)avatarViewArr
{
    self.avatarHolderview = [[UIView alloc]init];    //  辅助的view
    [self addSubview:_avatarHolderview];
    
    for (int i = 0; i<avatarNum ; i++) {
        UserAvatarView *avatarView = [avatarViewArr objectAtIndex:i];
        [_avatarHolderview addSubview:avatarView];
        
        if (i == 0) {
            [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_avatarHolderview).with.offset(+(padding/2));   //  距离最左边应该是边距的一半
                make.centerY.equalTo(_avatarHolderview);
                make.width.equalTo(@(TIMELINE_CELL_HEADER_AVATAR_WIDTH));
                make.height.equalTo(@(TIMELINE_CELL_HEADER_AVATAR_HEIGHT));
            }];
        }else{
            UserAvatarView *formerView = [_avatarHolderview.subviews objectAtIndex:i-1]; //  取出前一个avatarview
            
            [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(formerView.mas_right).with.offset(+padding);
                make.centerY.equalTo(_avatarHolderview);
                make.width.equalTo(@(TIMELINE_CELL_HEADER_AVATAR_WIDTH));
                make.height.equalTo(@(TIMELINE_CELL_HEADER_AVATAR_HEIGHT));
            }];
        }
    }
    
    CGFloat width = (TIMELINE_CELL_HEADER_AVATAR_WIDTH + padding)*avatarNum;    //  view的宽度
    
    [_avatarHolderview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(@(width));
    }];
}

- (void)setClickDisplayUserButtonBlock:(ButtonClickActionBlock)block
{
    self.clickDisplayUserBlock = block;
}

- (void)clickDisplayUserButton:(id)sender
{
    EXECUTE_BLOCK(self.clickDisplayUserBlock, sender);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
