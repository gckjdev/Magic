//
//  CommonFeedBarrageView.h
//  BarrageClient
//
//  Created by HuangCharlie on 3/30/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoadImageCallBackBlock) (NSError *error);

#define BARRAGE_VIEW_WIDTH              (800.0f)
#define BARRAGE_VIEW_HEIGHT             (800.0f) // + 87.5f)

// 弹幕头像宽度
#define BARRAGE_AVATAR_VIEW_WIDTH               86.0f

// 弹幕文本默认宽度
//#define BARRAGE_TEXT_VIEW_DEFAULT_WIDTH         400.0f

// 弹幕文本默认高度
#define BARRAGE_TEXT_VIEW_DEFAULT_HEIGHT        86.0f

// 弹幕头像白边宽度
#define BARRAGE_AVATAR_BORDER_WIDTH             5.0f

// 弹幕VIEW的字体大小
#define BARRAGE_TEXT_FONT               ([UIFont boldSystemFontOfSize:32])


#define BARRAGE_RATIO_WIDTH             (BARRAGE_VIEW_WIDTH*1.0f/BARRAGE_VIEW_HEIGHT)
#define BARRAGE_WIDTH(height)           (height*BARRAGE_RATIO_WIDTH)
#define BARRAGE_HEIGHT(width)           (width/BARRAGE_RATIO_WIDTH)


#define VIEW_TAG_BARRAGE_BEGIN        2014900000
#define VIEW_TAG_BARRAGE_END          2014999999

#define IS_BARRAGE_VIEW(tag)        ( (tag >= VIEW_TAG_BARRAGE_BEGIN) && (tag <= VIEW_TAG_BARRAGE_END) )

/*
 这个view先默认按照800*800设计，在生成的时候再使用holderview去缩放
 */

@interface CommonFeedBarrageView : UIImageView

@property (nonatomic,strong) UIImage* image;

@property (nonatomic,strong) NSArray* feedActions;
//every object is a barrage text view
@property (nonatomic,strong) NSArray* barrageViews;

-(id)initWithFrame:(CGRect)frame;

-(void)addBgImage:(UIImage*)image;
-(void)addBarrageWithActions:(NSArray*)actions;

-(void)showAllBarrages;
-(void)hideAllBarrages;
-(void)removeAllBarrageViews;

//add by neng
-(void)addClickBarrageAction;
-(void)updateViewsPosWithPoints:(NSArray*)points;
-(void)updateImageWithURL:(NSURL*)url
                 callback:(LoadImageCallBackBlock)callback;
@end
