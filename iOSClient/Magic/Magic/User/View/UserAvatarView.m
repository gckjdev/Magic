//
//  UserAvatarView.m
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "UserAvatarView.h"
#import "UIViewUtils.h"
#import "UIImageView+WebCache.h"
#import "ColorInfo.h"
#import "Masonry.h"
#import "FriendDetailController.h"
#import "AppDelegate.h"
#import "TGRImageViewController.h"
#import "QNImageToolURL.h"

@implementation UserAvatarView

#define BORDER_WIDTH    (3)

- (void)setAsRound{
    
//    PPDebug(@"<setAsRound> frame=%@", NSStringFromCGRect(self.frame));
//    PPDebug(@"<setAsRound> frame=%@", NSStringFromCGRect(self.bgView.frame));
//    PPDebug(@"<setAsRound> frame=%@", NSStringFromCGRect(self.imageView.frame));
    
    SET_VIEW_ROUND(self);
    SET_VIEW_ROUND(self.bgView);
    SET_VIEW_ROUND(self.imageView);
    
    [self.bgView setImage:nil];
}

- (void)setBackgroundImage:(UIImage *)image
{
    [self.bgView setImage:image];
    [self.bgView setFrame:self.bounds];
    [self sendSubviewToBack:self.bgView];
}

- (void)setBorderWidth:(CGFloat)width
{
    self.layer.borderWidth = width;
}

- (void)setContentInset:(CGSize)contentInset
{
    _contentInset = contentInset;
    [self.imageView setFrame:CGRectInset(self.bounds, contentInset.width, contentInset.height)];
    self.bgView.frame = self.bounds;
}

- (void)setAsSquare{
    self.layer.cornerRadius = 0;
    self.layer.masksToBounds = NO;
    self.bgView.layer.cornerRadius = 0;
    self.bgView.layer.masksToBounds = NO;
    self.imageView.layer.cornerRadius = 0;
    self.imageView.layer.masksToBounds = NO;
}

#define BADGE_VIEW_TAG 32445
- (void)setBadge:(NSInteger)number
{
    BadgeView *badge = [self badgeView];
    if (badge == nil) {
        badge = [BadgeView badgeViewWithNumber:number];
        badge.tag = BADGE_VIEW_TAG;
        [self addSubview:badge];
        [badge updateOriginX:(CGRectGetWidth(self.bounds)-CGRectGetWidth(badge.bounds))];
        [badge updateOriginY:(CGRectGetHeight(badge.bounds))];
    }
}

- (BadgeView *)badgeView
{
    BadgeView *badge = (id)[self viewWithTag:BADGE_VIEW_TAG];
    return badge;
}

- (void)addTapGuesture
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnAvatar)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (id)init
{
    return [self initWithUser:nil frame:CGRectZero];
}

- (id)initWithUser:(PBUser*)user frame:(CGRect)frame
{
    return [self initWithUser:user frame:frame borderWidth:BORDER_WIDTH];
}

- (id)initWithUser:(PBUser*)user frame:(CGRect)frame borderWidth:(CGFloat)borderWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.user = user;
        
        self.backgroundColor = [UIColor clearColor];

        self.bgView = [[UIImageView alloc] init];
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height);
            make.center.equalTo(self);
        }];
        [self setAvatarSelected:NO];
        
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height);
            make.center.equalTo(self);
        }];
        
        [self loadAvatarImage:user];
        [self addTapGuesture];

//        [self setAsRound];
        if (borderWidth > 0.0f){
            self.layer.borderWidth = borderWidth;
            self.layer.borderColor = [UIColor whiteColor].CGColor;
        }
    }

    return self;
}
- (id)initWithUser:(PBUser *)user borderWidth:(CGFloat)borderWidth
{
    CGRect frame = CGRectMake(0, 0, 200, 200);
    return [self initWithUser:user frame:frame borderWidth:borderWidth];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setAsRound];
}

//- (id)initWithUrlString:(NSString *)urlString frame:(CGRect)frame gender:(BOOL)gender level:(int)level vip:(int)vip
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        bgView = [[UIImageView alloc] initWithFrame:[self calAvatarFrame]];
//        [self addSubview:bgView];
//        [self setAvatarSelected:NO];
//        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        [self addSubview:imageView];
//        [self setAvatarUrl:urlString gender:gender];
//        [self addTapGuesture];
//        [self setAvatarSelected:NO level:level];
//        
//        [self setAsRound];
//        self.layer.borderWidth = BORDER_WIDTH;
//        self.layer.borderColor = [COLOR_GRAY_AVATAR CGColor];
//        
//        //#ifdef DEBUG
//        //        [self setIsVIP:YES];
//        //#endif
//    }
//    
//    return self;
//}

//- (id)initWithFrame:(CGRect)frame user:(PBGameUser *)user
//{
//    AvatarView *av = [self initWithUrlString:user.avatar frame:frame gender:user.gender level:user.level vip:user.vip];
//    av.user = user;
//    //    PPDebug(@"<AvatarView> initWithFrame, addr = %@", av);
//    return av;
//}

- (void)clear
{
    
}

- (void)setImage:(UIImage *)image
{
    [self.imageView setImage:image];
}

- (void)clickOnAvatar
{
    PPDebug(@"avatar click");
    if (_clickOnAvatarBlock) {
        EXECUTE_BLOCK(self.clickOnAvatarBlock);
    }else if (_delegate && [_delegate respondsToSelector:@selector(didClickOnAvatarView:)]) {
        [_delegate didClickOnAvatarView:self];
    }else{
        [UserAvatarView clickAvatarAction:self.user];
    }
}

+ (void)clickAvatarAction:(PBUser*)user
{
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    UINavigationController* currentNavigationController = delegate.currentNavigationController;
    //  show user detail
    FriendDetailController *vc = [[FriendDetailController alloc]initWithUser:user];
    [currentNavigationController pushViewController:vc animated:YES];
}


+ (UIImage*)maleDefaultAvatarImage
{
    return [UIImage imageNamed:@"man.png"];
}

+ (UIImage*)femaleDefaultAvatarImage
{
    return [UIImage imageNamed:@"female.png"];
}

+ (UIImage*)avatarImageByGender:(BOOL)gender
{
    if (gender) {
        return [self maleDefaultAvatarImage];
    }else{
        return [self femaleDefaultAvatarImage];
    }
}

- (void)loadAvatarImage:(PBUser*)user
{
    [self setAsRound];
    UIImage *placeHolderImage = [UIImage imageNamed:@"default_user_avatar"];
    int width = self.frame.size.width*3;    //按像素的大小
    int height = self.frame.size.height*3;
    NSString* imageUrl = [QNImageToolURL GetThumbnailSizeImageUrl:user.avatar width: width height:height];

    NSURL* url = [NSURL URLWithString:imageUrl];
    if (url){
        [self.imageView sd_setImageWithURL:url
                          placeholderImage:placeHolderImage
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                                     PPDebug(@"avatar image (%@) load done, error=%@", user.avatar, error);
                                     
                                 }];
    }
    else{
        [self setImage:placeHolderImage];
    }
    
}

- (void)updateUser:(PBUser*)user
{
    self.user = user;
    [self loadAvatarImage:user];
}

- (void)setAvatarSelected:(BOOL)selected
{
    // TODO
//    if (selected) {
//        [self.bgView setImage:[[ShareImageManager defaultManager] avatarSelectImage]];
//    }else{
//        [self.bgView setImage:[[ShareImageManager defaultManager] avatarUnSelectImage]];
//    }
}

- (void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                  byRoundingCorners:corners
                                                        cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    view.layer.mask = shape;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self updateMaskToBounds:self.bounds];
//}
//
//- (void)updateMaskToBounds:(CGRect)maskBounds {
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    
//    CGPathRef maskPath = CGPathCreateWithEllipseInRect(maskBounds, NULL);
//    
//    maskLayer.bounds = maskBounds;
//    maskLayer.path = maskPath;
//    maskLayer.fillColor = [UIColor blackColor].CGColor;
//    
//    CGPoint point = CGPointMake(maskBounds.size.width/2, maskBounds.size.height/2);
//    maskLayer.position = point;
//    
//    [self.layer setMask:maskLayer];
//    
//    self.layer.cornerRadius = CGRectGetHeight(maskBounds) / 2.0;
////    self.layer.borderColor = [self.borderColor colorWithAlphaComponent:0.7].CGColor;
////    self.layer.borderWidth = self.borderSize;
////    
////    self.highLightView.frame = self.bounds;
//}

@end
