//
//  TimelineTableView.m
//  BarrageClient
//
//  Created by HuangCharlie on 4/9/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "TimelineTableView.h"
#import "TimelineCell.h"
#import "FeedManager.h"
#import "CommentFeedController.h"
#import <Masonry.h>

@interface TimelineTableView ()
{
    
}

@property (nonatomic,assign) BOOL hasNewMessage;
@property (nonatomic,strong) UIViewController* superController;

@end

@implementation TimelineTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithSuperController:(UIViewController*)superController
{
    self = [super init];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.superController = superController;
    
    [self registerClass:TimelineCell.class forCellReuseIdentifier:kTimelineCellReuseIdentifier]; //  注册头像那个cell的类
    
    /**
     *  tableview style
     */
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.allowsSelection = NO;
    
    return self;
}

- (Feed*)getFeed:(NSIndexPath*)indexPath
{
    NSUInteger count = [[FeedManager sharedInstance] totalTimelineCount];
    if (indexPath.row >= count){
        return nil;
    }
    Feed* feed = [[[FeedManager sharedInstance] userTimelineFeedList] objectAtIndex:indexPath.row];
    
    return feed;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimelineCell *cell = (TimelineCell*)[tableView dequeueReusableCellWithIdentifier:kTimelineCellReuseIdentifier forIndexPath:indexPath];

    Feed* feed = [self getFeed:indexPath];
    [cell setSuperController:self.superController];
    [cell updateCellData:feed];

    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimelineCell* tcell;
    if([cell isKindOfClass:[TimelineCell class]])
        tcell = (TimelineCell*)cell;
    
    [tcell hideAllPopUps];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kTimelineCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[FeedManager sharedInstance] totalTimelineCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.hasNewMessage){
        return kTimelineNewMessageHeaderHeight;
    }
    else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.hasNewMessage){
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width, kTimelineNewMessageHeaderHeight);
        UIView* view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = BARRAGE_BG_COLOR;    //  背景颜色
        UILabel* label = [[UILabel alloc] init];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:@"3条新消息"];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:TABLE_NEW_MESSAGE_FONT];
        [label setBackgroundColor:BARRAGE_NEWS_BG_COLOR];
        
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(view).with.multipliedBy(0.6);   //  高度约为view的64/120
            make.width.equalTo(view).with.multipliedBy(0.375);   //  宽度为view的120/320
            make.center.equalTo(view);
        }];
        label.center = view.center;
        SET_VIEW_ROUND_CORNER(label);
        return view;
    }
    else{
        return 0;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Feed* feed = [self getFeed:indexPath];
    [CommentFeedController showFromController:self.superController
                                     withFeed:feed
                                     startPos:CGPointMake(0, 0)];
    FeedManager *feedManager = [FeedManager sharedInstance];
    NSInteger lastIndex = [feed.feedBuilder.actions count] - 1;
    [feedManager updateFeedPlayIndex:feed.feedId playIndex: lastIndex];
    
    
}


@end
