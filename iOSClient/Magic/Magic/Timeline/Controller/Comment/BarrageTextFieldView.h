//
//  BarrageTextFieldView.h
//  BarrageClient
//
//  Created by Teemo on 15/2/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#define BARRAGETEXTVIEW_CONTENT_TOP_INSET               22.0f
#define BARRAGETEXTVIEW_CONTENT_LEFT_INSET              90.0f
#define BARRAGETEXTVIEW_CONTENT_BOTTOM_INSET            0.0f
#define BARRAGETEXTVIEW_CONTENT_RIGHT_INSET             30.0
#define BARRAGETEXTVIEW_CONTENT_TOP_NOT_INSET           5.0f

#define BARRAGETEXTVIEW_LEFT_MOVE                       0.0f




#define BARRAGETEXTVIEW_CORNERRADIUS            45.0f
#define BARRAGETEXTVIEW_FONT                    [UIFont boldSystemFontOfSize:30.0f]

#define BARRAGETEXTVIEW_WIDTH_MAX               500.0f
#define BARRAGETEXTVIEW_HEIGHT                  86.0f
#define BARRAGETEXTVIEW_SHOW_WIDTH_MIN          (BARRAGETEXTVIEW_CONTENT_LEFT_INSET - 20)
#define BARRAGETEXTVIEW_EDIT_WIDTH_MIN          130.0f



#define BARRAGETEXTVIEW_ANIMATION_DURATION      0.3F

#define BARRAGETEXTVIEW_JUDGE_WIDTH             (BARRAGETEXTVIEW_WIDTH_MAX -BARRAGETEXTVIEW_CONTENT_LEFT_INSET - BARRAGETEXTVIEW_CONTENT_RIGHT_INSET)

#define BARRAGETEXTVIEW_HINT_TEXT               @"请输入评论"
#define BARRAGETEXTVIEW_HINT_ALPHA              0.5



#import <UIKit/UIKit.h>
#import "ViewInfo.h"
#import "Barrage.pb.h"
typedef enum{
    BARRAGE_EDITMODE,//编辑模式
    BARRAGE_SHOWMODE ,// 显示模式
} BarrageTextModeType;

typedef void (^WidthChangeBlock) (CGFloat width);

@interface BarrageTextFieldView : UITextView

+(instancetype)FieldViewWithAction:(PBFeedActionBuilder*)action
                              mode:(BarrageTextModeType)mode;

-(void)updateViewWithData:(PBFeedActionBuilder*)action;
-(void) setTextInset:(NSString*)text;
-(void) hiddenHintText;
-(void) showHintText;
-(void) editMode;
-(void) showMode;



@property (nonatomic, assign) BOOL      isBreakLine;
@property (nonatomic, assign) double      viewMaxWidth;//这个View最大的宽度
@property (nonatomic, assign) BOOL      isReversal;
@property (nonatomic,copy) WidthChangeBlock   widthChangeBlock;
@property (nonatomic,strong) PBFeedActionBuilder   *action;

@end
