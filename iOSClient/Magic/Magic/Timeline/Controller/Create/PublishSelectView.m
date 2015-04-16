//
//  PublishSelectView.m
//  BarrageClient
//
//  Created by gckj on 15/2/2.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "PublishSelectView.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "UIViewUtils.h"
#import "PPDebug.h"
#import "FeedService.h"
#import "FontInfo.h"
#import "ColorInfo.h"
#import "UIImageUtil.h"
#import "UserTimelineFeedController.h"

#define SELECT_BUTTON_FONT                  ([UIFont systemFontOfSize:14])
#define SELECT_BUTTON_IMAGE_INSETS_BOTTOM   34.0f
#define SELECT_LABEL_OFFSET_BOTTOM          -35.0f

#define DIVIDER_UIVIEW_WIDTH                1.0f
#define DIVIDER_UIVIEW_HEIGHT               52.0f
#define DIVIDER_UIVIEW_TOP                  29.0f
#define PUBLISHSELECTVIEW_WIDTH             240.0f
#define PUBLISHSELECTVIEW_HEIGHT            120.0f

@interface PublishSelectView ()

@end

@implementation PublishSelectView

- (void) layoutSubviews
{

    /**
     *  背景
     */

    UIView *bgView = [[UIView alloc]init];
    UIButton *bgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    [bgView addSubview:bgBtn];
    [bgBtn addTarget:self action:@selector(onBgBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:bgView];
    [bgBtn setBackgroundColor:ALPHA_COLOR(0, 0, 0, 0.3f)];

    [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.center.equalTo(self);
    }];
   
    
    UIView *opView = [[UIView alloc]init];
    /**
     *  选择框背景图片
     */
    UIImage *selectBgImage =[UIImage resizableImage:@"published_bg"];
    UIImageView* selectBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,PUBLISHSELECTVIEW_WIDTH,PUBLISHSELECTVIEW_HEIGHT)];
    [selectBgImageView setImage:selectBgImage];
    [opView addSubview:selectBgImageView];
    
    /**
     相册
     */
    UIButton* photoalbumBtn = [[UIButton alloc]init];
    [photoalbumBtn addTarget:self action:@selector(onPhotoalbum:) forControlEvents:UIControlEventTouchUpInside];
    UIImage* photoalbumLogo =[UIImage imageNamed:@"photoalbum_normal"];
    [photoalbumBtn setImage:photoalbumLogo forState:UIControlStateNormal];
    [photoalbumBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, SELECT_BUTTON_IMAGE_INSETS_BOTTOM,0.0)];
  
    [opView addSubview:photoalbumBtn];
    [photoalbumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(opView.mas_width).dividedBy(2);
        make.height.equalTo(opView.mas_height);
        make.top.equalTo(opView.mas_top);
        //make.centerY.equalTo(opView.mas_centerY);
        make.centerX.equalTo(opView.mas_centerX).dividedBy(2);
    }];
   
  
    UILabel* photoalbumTitle = [[UILabel alloc]init];
    [photoalbumTitle setText:@"相册"];
    [photoalbumTitle setFont:SELECT_BUTTON_FONT];
    [photoalbumTitle setTextColor:BARRAGE_LABEL_COLOR];

    [opView addSubview:photoalbumTitle];
    [photoalbumTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(photoalbumBtn.mas_bottom);
        make.bottom.equalTo(opView.mas_bottom).with.offset(SELECT_LABEL_OFFSET_BOTTOM);
        make.centerX.equalTo(photoalbumBtn.mas_centerX);
    }];
    
    

    /**
     分割线
     */
    UIColor* DIVIDER_BG_COLOR = OPAQUE_COLOR(0xd9, 0xd9, 0xd9);
    CGRect dividerFrame = CGRectMake(PUBLISHSELECTVIEW_WIDTH/2.0,
                                     DIVIDER_UIVIEW_TOP,
                                     DIVIDER_UIVIEW_WIDTH,
                                     DIVIDER_UIVIEW_HEIGHT);
    UIView *divider = [[UIView alloc]initWithFrame:dividerFrame];
    [divider setBackgroundColor:DIVIDER_BG_COLOR];
    [opView addSubview:divider];
    
    /**
     照相
     */
    UIButton* cameraBtn = [[UIButton alloc]init];
    [cameraBtn addTarget:self action:@selector(onCameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage* cameraLogo =[UIImage imageNamed:@"camera_normal"];
    [cameraBtn setImage:cameraLogo forState:UIControlStateNormal];
    [cameraBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, SELECT_BUTTON_IMAGE_INSETS_BOTTOM,0.0)];
    [opView addSubview:cameraBtn];
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(opView.mas_width).dividedBy(2);
        make.height.equalTo(opView.mas_height);
        make.top.equalTo(opView.mas_top);
        //make.centerY.equalTo(opView.mas_centerY);
        make.centerX.equalTo(opView.mas_centerY).dividedBy(1/3.0);
    }];
    
    UILabel* cameraTitle = [[UILabel alloc]init];
    [cameraTitle setText:@"拍照"];
    [cameraTitle setFont:SELECT_BUTTON_FONT];
    [cameraTitle setTextColor:BARRAGE_LABEL_COLOR];
    [opView addSubview:cameraTitle];
    [cameraTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(photoalbumBtn.mas_bottom);
        make.bottom.equalTo(opView.mas_bottom).with.offset(SELECT_LABEL_OFFSET_BOTTOM);
        make.centerX.equalTo(cameraBtn.mas_centerX);
    }];
    
    
    [self addSubview: opView];
    [opView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(PUBLISHSELECTVIEW_WIDTH,  PUBLISHSELECTVIEW_HEIGHT));
        make.center.equalTo(self);
    }];
    
    [super layoutSubviews];

//    return self;

}

-(void)onBgBtn:(id)sender
{
    [self removeFromSuperview];
}

-(void)onPhotoalbum:(id)sender
{
    [[FeedService sharedInstance] selectPhoto];
    [self removeFromSuperview];

}

-(void)onCameraBtn:(id)sender
{
    [[FeedService sharedInstance] selectCamera];
    [self removeFromSuperview];
}



@end
