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
@interface MessageTableView()<UITableViewDataSource,UITableViewDelegate>

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
    self.backgroundColor =BARRAGE_BG_COLOR;
    self.dataSource = self;
    self.delegate = self;
    [self registerClass:ChatCell.class forCellReuseIdentifier:@"cellIdentifier"]; //  注册头像那个cell的类
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.allowsSelection = NO;
    
    

}

-(void)RefreshData{
    
    [[ChatService sharedInstance]getChatList:^(NSArray *chatArray, NSError *error) {
        if (error == nil) {
            NSMutableArray *messageFArray = [NSMutableArray array];
            NSInteger len = [chatArray count];
            for (int i = 0; i< len;i++) {
                PBChat * tmpChat = chatArray[len - i - 1];
                ChatMessage *message = [ChatMessage messageWithPBChat:tmpChat];
                ChatCellFrame *lastMessageF = [messageFArray lastObject];
                ChatMessage *lastMassage = lastMessageF.message;
                //                msg.hideTime = [msg.time isEqualToString:lastMsg.time];
                NSTimeInterval secondsInterval = [message.time timeIntervalSinceDate:lastMassage.time];
                if (secondsInterval>30) {
                    message.hideTime = NO;
                }
                else{
                    message.hideTime = YES;
                }
                //                [self isHideTime:msg.time lastTime:lastMsg.time];
                ChatCellFrame *messageF = [[ChatCellFrame alloc] init];
                messageF.message = message;
                [messageFArray addObject:messageF];
            }
            
            _messageFrames = messageFArray;
            
            [self reloadData];
            
            
            NSInteger sectionNum = [self numberOfSections];
            if (sectionNum<1) return;
            NSInteger rowNum = [self numberOfRowsInSection:sectionNum-1];
            if (rowNum<1) return;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNum-1 inSection:sectionNum-1];
            [self scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        else{
            POST_ERROR(@"加载数据失败");
        }
    }];

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCellFrame *cellFrame = self.messageFrames[indexPath.row];
 
}
#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    ChatCell *cell = [ChatCell cellWithTableView:tableView];
    
    // 2.给cell传递模型
    cell.messageFrame = self.messageFrames[indexPath.row];
    
    // 3.返回cell
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
    }];
    [super updateConstraints];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 退出键盘
    [self.superview endEditing:YES];
}
@end
