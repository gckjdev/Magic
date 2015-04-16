//
//  UIViewUtils.h
//  three20test
//
//  Created by qqn_pipi on 10-3-19.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PPDebug.h"
#import "DeviceDetection.h"
#import "ColorInfo.h"
#import "FontInfo.h"
#import "ViewInfo.h"
#import "MessageCenter.h"
#import "LocaleUtils.h"
#import "Reachability.h"

typedef void (^ButtonClickActionBlock) (id sender);

#define kNavigationBarHeight		44
#define kToolBarHeight				44
#define kTabBarHeight				60
#define kStatusBarHeight			20
#define kSearchBarHeight			50
#define kKeyboadHeight              216

#define IS_NETWORK_OK               ([Reachability isNetworkOK])
#define IS_WIFI                     ([Reachability isWifiNetwork])

#define isRetina					([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
												CGSizeEqualToSize(CGSizeMake(640, 960), \
												[[UIScreen mainScreen] currentMode].size) : NO)

#define isIPad						(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kScreenWidth				([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight				([UIScreen mainScreen].bounds.size.height)

#define activityViewTag				0x98751234

#define UD_SET(k, v)                    \
if (k != nil) { \
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; \
  PPDebug(@"store key(%@) value(%@)", k, v); \
  [ud setObject:v forKey:k]; \
  [ud synchronize]; \
}

#define UD_GET(k)                   ( (k != nil) ? [[NSUserDefaults standardUserDefaults] objectForKey:k] : nil )
#define UD_REMOVE(k)                ( (k != nil) ? [[NSUserDefaults standardUserDefaults] removeObjectForKey:k] : nil )

#define STATUSBAR_DELTA             20

#define SET_VIEW_ROUND_CORNER_RADIUS(view, radius) \
{           \
[view.layer setCornerRadius:radius];  \
[view.layer setMasksToBounds:YES];    \
}

#define SET_VIEW_ROUND_CORNER(view) \
{           \
SET_VIEW_ROUND_CORNER_RADIUS(view, TEXT_VIEW_CORNER_RADIUS)\
}

#define SET_VIEW_ROUND(view) \
{           \
[view.layer setCornerRadius:CGRectGetWidth(view.frame)/2.0f];  \
[view.layer setMasksToBounds:YES];    \
view.clipsToBounds = YES; \
}

typedef enum{
    AnchorTypeLeftTop = 1,
    AnchorTypeRightTop,
    AnchorTypeLeftBottom,
    AnchorTypeRightBottom,
    AnchorTypeCenter,
}AnchorType;

typedef enum{
    ConstTypeNone = 1,
    ConstTypeHeight,
    ConstTypeWidth,
}ConstType;

@interface UIView (UIViewUtils)

- (void)setBackgroundImageView:(NSString *)imageName;
- (UIView *)findFirstResonder;

- (void)showActivityViewAtCenter;
- (void)hideActivityViewAtCenter;
- (UIActivityIndicatorView*)createActivityViewAtCenter:(UIActivityIndicatorViewStyle)style;
- (UIActivityIndicatorView*)getActivityViewAtCenter;

- (void)createButtonsInView:(NSArray*)buttonTextArray templateButton:(UIButton*)templateButton
                     target:(id)target action:(SEL)action;

- (void)removeAllSubviews;

- (void)moveTtoCenter:(CGPoint)center needAnimation:(BOOL)need animationDuration:(NSTimeInterval)interval;

+ (id)createViewWithXibIdentifier:(NSString *)identifier;
+ (id)createViewWithXibIdentifier:(NSString *)identifier ofViewIndex:(NSUInteger) index;

- (void)updateOriginX:(CGFloat)originX;
- (void)updateOriginY:(CGFloat)originY;
- (void)updateBottom:(CGFloat)bottom;
- (void)updateCenterX:(CGFloat)centerX;
- (void)updateCenterY:(CGFloat)centerY;
- (void)updateWidth:(CGFloat)width;
- (void)updateHeight:(CGFloat)height;

- (UIView *)PPRootView;
- (void)setShadowOffset:(CGSize)offset
                   blur:(float)blur
            shadowColor:(UIColor*)color;//this method requires a high pressure calculation, do not use it in lots of pictures, recommend value:(0,3),0.6,black color


//reset the frame with the new size(may be scale by const type), anchor type make the point stable
- (void)scaleWithSize:(CGSize)size
       anchorType:(AnchorType)anchorType
        constType:(ConstType)constType;

- (UIView *)theTopView;
- (UIViewController *)theViewController;

- (UIView *)reuseViewWithTag:(NSInteger)tag
                   viewClass:(Class)viewClass
                       frame:(CGRect)frame;

- (UILabel *)reuseLabelWithTag:(NSInteger)tag
                         frame:(CGRect)frame
                          font:(UIFont *)font
                          text:(NSString *)text;

- (UIButton *)reuseButtonWithTag:(NSInteger)tag
                           frame:(CGRect)frame
                            font:(UIFont *)font
                            text:(NSString *)text;


- (BOOL)containsSubView:(UIView *)view;
- (BOOL)containsSubViewWithClass:(Class)viewClass;
- (void)reverseViewHorizontalContent;
- (void)reverseViewVerticalContent;
- (void)enumSubviewsWithClass:(Class)viewClass handler:(void (^)(id view))handler;
- (void)removeSubviewsWithClass:(Class)viewClass;

- (UITapGestureRecognizer*)addTapGestureWithTarget:(id)target selector:(SEL)selector;

- (UIImage *)createSnapShotWithScale:(CGFloat)scale;
- (UIImage *)createSnapShotWithScale:(CGFloat)scale size:(CGSize)size;

- (void)updateOriginDataViewTableY:(CGFloat)originY;

// 缩放当前view
- (void)scaleView:(CGFloat)scale;

// 在父view中缩放
- (CGFloat)scaleInView:(UIView*)superView;

+ (UIButton*)createButton:(NSString*)imageName;

+ (UIButton*)defaultTextButton:(NSString*)title;

+ (UIButton*)defaultTextButton:(NSString*)title
                     superView:(UIView*)superView;
+ (UIButton*)createButton:(NSString*)title
                superView:(UIView*)superView;


+(UITextField*)defaultTextField:(NSString*)placeHoleder
                      superView:(UIView*)superView;
+(UILabel*)defaultLabel:(NSString*)text
              superView:(UIView*)superView;
//  生成其他注册方式按钮 其他登录方式的也暂时用这个 暂时弃用
+ (UIButton*)registerStyleWithsuperView:(UIView*)superView
                         normalBgImg:(NSString*)normalBgImg
                    highlightedBgImg:(NSString*)highlightedBgImg;
//  生成其他注册方式按钮 其他登录方式的也暂时用这个
+ (UIButton*)registerStyleWithsuperView:(UIView*)superView
                                  title:(NSString*)title
                                   icon:(NSString*)icon
                                bgColor:(UIColor*)bgColor;
//  用于UITableViewCell下方的横线
+(void)addSingleLineWithColor:(UIColor *)color
                  borderWidth:(CGFloat)borderWidth
                    superView:(id)superView;
//  普通横线 
+(UIView*)creatSingleLineWithColor:(UIColor *)color
                  borderWidth:(CGFloat)borderWidth
                    superView:(id)superView;
//  上方横线
+(void)addTopLineWithColor:(UIColor *)color
               borderWidth:(CGFloat)borderWidth
                 superView:(id)superView;
//  下方横线
+(void)addBottomLineWithColor:(UIColor *)color
               borderWidth:(CGFloat)borderWidth
                 superView:(id)superView;

+(UIView*)defaultSpacingInSuperView:(UIView*)superView;

//删除时候的抖动
- (void)setShaking;

//淡入效果
- (void)setEaseInWithDuration:(CGFloat)duration;
//淡出效果
- (void)setEaseOutWithDuration:(CGFloat)duration;

//- (void)pullDownWithDuration:(CGFloat)duration superView:(UIView *)superView height:(float)height;
//- (void)pullUpWithDuration:(CGFloat)duration superView:(UIView *)superView height:(float)height;
@end

@interface UISearchBar (UISearchBarUtils)

- (void)setSearchBarBackgroundByView:(UIImageView*)imageView;
- (void)setSearchBarBackgroundByImage:(NSString*)imageName;

@end

CGPoint CGRectGetCenter(CGRect rect);