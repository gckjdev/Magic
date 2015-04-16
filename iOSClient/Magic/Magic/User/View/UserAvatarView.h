//
//  UserAvatarView.h
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeView.h"
#import "User.pb.h"

@class UserAvatarView;

@protocol AvatarViewDelegate <NSObject>

@optional
- (void)didClickOnAvatarView:(UserAvatarView *)avatarView;
@end

typedef void (^ClickOnAvatarBlock)(void);

@interface UserAvatarView : UIView

- (id)initWithUser:(PBUser*)user frame:(CGRect)frame;
- (id)initWithUser:(PBUser*)user frame:(CGRect)frame borderWidth:(CGFloat)borderWidth;
- (id)initWithUser:(PBUser *)user borderWidth:(CGFloat)borderWidth;
- (void)setAvatarSelected:(BOOL)selected;
- (void)setAsSquare;
- (void)setAsRound;
- (void)setBackgroundImage:(UIImage *)image;
- (void)updateUser:(PBUser*)user;
+ (UIImage*)avatarImageByGender:(BOOL)gender;
- (void)setBorderWidth:(CGFloat)width;

@property(nonatomic, assign) id<AvatarViewDelegate> delegate;
@property(nonatomic, strong) ClickOnAvatarBlock clickOnAvatarBlock;
@property(nonatomic, assign) CGSize contentInset;
@property(nonatomic, strong) PBUser *user;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIButton *markButton;
@property(nonatomic, strong) UIImageView *bgView;

- (void)setBadge:(NSInteger)number;
- (BadgeView *)badgeView;

+ (void)clickAvatarAction:(PBUser*)user;

@end
