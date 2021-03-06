//
//  MessageTableView.m
//  talking
//
//  Created by Teemo on 15/4/10.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import "MessageTableView.h"
#import "ChatCell.h"
#import "ChatCellFrame.h"
#import "Masonry.h"
#import "ChatService.h"
#import "ColorInfo.h"
#import "UIScrollView+MJRefresh.h"
#import "PPDebug.h"
#import "ChatManager.h"

@interface MessageTableView()<UITableViewDataSource,UITableViewDelegate,ChatCellDelegate>
@property (nonatomic,strong) NSArray   *localChatArray;
@end

@implementation MessageTableView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = BARRAGE_BG_COLOR;
    self.dataSource = self;
    self.delegate = self;
    _playingCellPath = nil;
    
    [self registerClass:ChatCell.class forCellReuseIdentifier:CHAT_CELL_IDENTIFIER]; //  注册头像那个cell的类
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.allowsSelection = NO;
    
    [self addHeaderWithTarget:self action:@selector(headRefreshAction)];
    
    self.headerPullToRefreshText = @"下拉可刷新更多消息";
    self.headerReleaseToRefreshText = @"松开马上刷新";
    self.headerRefreshingText = @"奋力刷新中";

}

-(void)headRefreshAction{
    
    NSString *offsetId;
    if ([_messageFrames count]>0) {
        ChatCellFrame *tmpMessageFrame = _messageFrames[0];
        offsetId = tmpMessageFrame.message.pbChat.chatId;
    }
    else{
        offsetId = [NSString stringWithFormat:@""];
    }
    [[ChatService sharedInstance]getChatList:offsetId callback:^(NSArray *chatArray, NSError *error) {
        if (error == nil) {
            
            NSArray *newChatArray = [[ChatManager sharedInstance]chatList];
            
            if ([_localChatArray count] != [newChatArray count]) {
                
                [self dealWithChatArray:newChatArray];
                
                [self updatePlayingCellIndex:[_localChatArray count] newDataCount:[newChatArray count]];
                
                [self reloadData];
                
                _localChatArray = newChatArray;
            }
            [self headerEndRefreshing];
        }
        else{
            POST_ERROR(@"加载数据失败");
        }
    }];
}

-(void)refreshData{
    
    _localChatArray = [[ChatManager sharedInstance]chatList];
    if (_localChatArray!=nil) {
        [self dealWithChatArray:_localChatArray];
        [self reloadData];
        [self tableViewScrollToBottom];
    }
    
    [[ChatService sharedInstance]getChatList:@"" callback:^(NSArray *chatArray, NSError *error) {
        if (error == nil) {
            
            NSArray *newChatArray = [[ChatManager sharedInstance]chatList];
            
            if ([_localChatArray count] != [newChatArray count]) {
                
                [self dealWithChatArray:newChatArray];
                
                [self updatePlayingCellIndex:[_localChatArray count] newDataCount:[newChatArray count]];
                [self reloadData];
                
               
                [self tableViewScrollToBottom];
                
                _localChatArray = newChatArray;
            }
          
            
        }
        else{
            POST_ERROR(@"加载数据失败");
        }
    }];
}
-(void)stopPlayingCellAnimation{
    ChatCell *cell = (ChatCell*)[self cellForRowAtIndexPath:_playingCellPath];
    [cell voiceAnimationStop];
    _playingCellPath = nil;
}
-(void)startPlayingCellAnimation
{
    ChatCell *cell = (ChatCell*)[self cellForRowAtIndexPath:_playingCellPath];
    [cell voiceAnimationStart];
}
-(void)updatePlayingCellIndex:(NSInteger)localDataCount newDataCount:(NSInteger)newDataCount{
    
    if (_playingCellPath == nil) {
        return;
    }
    NSInteger row = [_playingCellPath row];
    row += newDataCount - localDataCount;
    _playingCellPath = [NSIndexPath indexPathForRow:row inSection:_playingCellPath.section];
}
-(void)dealWithChatArray:(NSArray *)chatArray{
    NSMutableArray *messageFArray = [NSMutableArray array];
    NSInteger len = [chatArray count];
    for (int i = 0; i< len;i++) {
        PBChat * tmpChat = chatArray[len - i - 1];
        ChatMessage *message = [ChatMessage messageWithPBChat:tmpChat];
        ChatCellFrame *lastMessageF = [messageFArray lastObject];
        ChatMessage *lastMassage = lastMessageF.message;
        
        NSTimeInterval secondsInterval = [message.time timeIntervalSinceDate:lastMassage.time];
        if (secondsInterval>60||i == 0) {
            message.hideTime = NO;
        }
        else{
            message.hideTime = YES;
        }
        
        ChatCellFrame *messageF = [[ChatCellFrame alloc] init];
        messageF.message = message;
        [messageFArray addObject:messageF];
    }
    
    _messageFrames = messageFArray;
    
}
-(void) tableViewScrollToBottom{
    
    NSInteger sectionNum = [self numberOfSections];
    if (sectionNum<1) return;
    NSInteger rowNum = [self numberOfRowsInSection:sectionNum-1];
    if (rowNum<1) return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNum-1 inSection:sectionNum-1];
    [self scrollToRowAtIndexPath:indexPath
                atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    ChatCell *cell = [ChatCell cellWithTableView:tableView];
    
    
    cell.messageFrame = self.messageFrames[indexPath.row];
    cell.delegate = self.controller;
    
    if (_playingCellPath == indexPath) {
        [cell voiceAnimationStart];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatCellFrame *mf = self.messageFrames[indexPath.row];
    return mf.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageFrames.count;
}

-(void)setMessageFrames:(NSArray *)messageFrames{
    _messageFrames = messageFrames;
    
    [self reloadData];
}

-(void)updateConstraints{
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.superview).with.offset(-self.viewHeight);
        
        make.centerX.equalTo(self.superview);
        make.width.equalTo(self.superview);
        make.top.equalTo(self.superview);
    }];
    [super updateConstraints];
}



@end
