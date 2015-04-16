//
//  CommonBarrageCell.h
//  BarrageClient
//
//  Created by Teemo on 15/3/25.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
#import "Barrage.pb.h"

#define kTimelineNewMessageHeaderHeight 60


#define kTimelineCellHeight             (TIMELINE_CELL_HEADER_HEIGHT + TIMELINE_CELL_FOOTER_HEIGHT + BARRAGE_HEIGHT(kScreenWidth) + TIMELINE_INTERVAL_VIEW_HEIGHT)


typedef enum CommonBarrageCellType :NSUInteger{
    
    BARRAGE_CELL_SIMPLE,//只有显示弹幕
    BARRAGE_CELL_WITH_HEAD_FOOT ,// 有headView和footView
    
} CommonBarrageCellType;


@protocol CommonBarrageCellDelegate <NSObject>

@optional
-(void)didClickShare:(Feed*)feed;
-(void)singleTapCellActon:(Feed*)feed  position:(CGPoint)position;
@end



@interface CommonBarrageCell : UIView


@property (nonatomic, weak) UIViewController* superController;
@property (nonatomic,assign) id<CommonBarrageCellDelegate> actionDelegate;

@property (nonatomic, assign) CommonBarrageCellType      type;

+(instancetype)initWithFrame:(CGRect)frame
                        type:(CommonBarrageCellType)type;

- (void)updateCellData:(Feed*)feed;
@end
