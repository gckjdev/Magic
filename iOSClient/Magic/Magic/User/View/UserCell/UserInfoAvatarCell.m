//
//  UserCell.m
//  BarrageClient
//
//  Created by gckj on 15/1/2.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "UserInfoAvatarCell.h"
#import "UserAvatarView.h"
#import "UserManager.h"
#import "ColorInfo.h"
#import "FontInfo.h"
#import "ViewInfo.h"
#import "TGRImageViewController.h"

#define kMargin 20

@implementation UserInfoAvatarCell

#pragma mark - Public Methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                         user:(PBUser *)user
{
    self = [super initWithStyle:style reuseIdentifier: reuseIdentifier];
    
    if (self) {
        CGRect frame = CGRectMake(0, 0, kUserInfoAvatarHeight, kUserInfoAvatarHeight);
        self.avatar = [[UserAvatarView alloc]initWithUser:user frame:frame];
        [self.contentView addSubview:self.avatar];
        [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-kMargin);
            make.width.equalTo(@(kUserInfoAvatarHeight));
            make.height.equalTo(@(kUserInfoAvatarHeight));
        }];
        
        __block UIViewController *currentController = self.superController;
        
        self.avatar.clickOnAvatarBlock = ^(void){
            NSURL *avatarUrl = [NSURL URLWithString:user.avatar];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:avatarUrl]];
            TGRImageViewController *vc = [[TGRImageViewController alloc] initWithImage:image];
            [currentController presentViewController:vc animated:YES completion:nil];
        };
        
        self.textLabel.font = BARRAGE_LABEL_FONT; //  字体
        self.textLabel.textColor = BARRAGE_LABEL_COLOR;   //  颜色
        //  添加横线
        [UIView addSingleLineWithColor:BARRAGE_CELL_LAYER_COLOR
                           borderWidth:COMMON_LAYER_BORDER_WIDTH
                             superView:self.contentView];
 
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               user:(PBUser*)user
    superController:(UIViewController *)controller
{
    self.superController = controller;
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier user:user];
}
@end
