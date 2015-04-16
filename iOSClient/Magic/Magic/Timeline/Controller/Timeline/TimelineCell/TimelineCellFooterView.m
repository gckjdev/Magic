//
//  TimelineCellFooterView.m
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "TimelineCellFooterView.h"
#import "Masonry.h"
#import "FontInfo.h"
#import "Feed.h"
#import "TimeUtils.h"
#import "UIViewUtils.h"

@interface TimelineCellFooterView()

@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UIButton* shareButton;
@property (nonatomic, strong) UIButton* playButton;

@property (nonatomic, strong) ButtonClickActionBlock clickPlayBlock;
@property (nonatomic, strong) ButtonClickActionBlock clickShareBlock;

@end

@implementation TimelineCellFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
    self = [super init];
    if (self){
        
        // add share button
        self.shareButton = [UIView createButton:@"share.png"];
        [self addSubview:self.shareButton];
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(self.mas_height);
            make.width.equalTo(@(TIMELINE_BUTTON_WIDTH));
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right);
        }];
        [self.shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // TODO add TEXT at the bottom of barrge view
        
        self.playButton = [UIView createButton:@"play.png"];
        [self addSubview:self.playButton];
        [self.playButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(self.mas_height);
            make.width.equalTo(@(TIMELINE_BUTTON_WIDTH));
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.shareButton.mas_left).with.offset(TIMELINE_BUTTON_RIGHT_SPACE);
        }];
        [self.playButton addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // add time label
        self.timeLabel = [[UILabel alloc] init];
        [self.timeLabel setText:@"1小时前"];
        [self.timeLabel setFont:CELL_SMALL_FONT];
        [self.timeLabel setTextColor:BARRAGE_TIME_COLOR];
        [self.timeLabel setFont:CELL_TIME_FONT];
        [self addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(self.mas_height);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(TIMELINE_TIME_LABEL_LEFT_SPACE);
            make.right.equalTo(self.playButton.mas_left).with.offset(-TIMELINE_TIME_LABEL_LEFT_SPACE);
        }];
        
    }
    
    return self;
}

- (void)updateData:(Feed*)feed
{
    NSString* str = dateToTimeLineString([NSDate dateWithTimeIntervalSince1970:feed.feedBuilder.date]);
    [self.timeLabel setText:str];
}

- (void)setClickShareButtonBlock:(ButtonClickActionBlock)block
{
    self.clickShareBlock = block;
}

- (void)setClickPlayButtonBlock:(ButtonClickActionBlock)block
{
    self.clickPlayBlock = block;
}

- (void)clickShareButton:(id)sender
{
    EXECUTE_BLOCK(self.clickShareBlock, sender);
}

- (void)clickPlayButton:(id)sender
{
    EXECUTE_BLOCK(self.clickPlayBlock, sender);
}

@end
