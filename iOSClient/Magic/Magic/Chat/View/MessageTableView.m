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
    self.backgroundColor = [UIColor colorWithRed:235/255.00 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.dataSource = self;
    self.delegate = self;
    [self registerClass:ChatCell.class forCellReuseIdentifier:@"cellIdentifier"]; //  注册头像那个cell的类
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.allowsSelection = NO;
    
    

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
