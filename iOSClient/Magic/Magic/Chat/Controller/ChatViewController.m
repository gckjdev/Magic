//
//  ChatViewController.m
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatToolView.h"
#import "Masonry.h"
#import "UIViewUtils.h"
#import "ChatCell.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

#import "ChatCellFrame.h"
#import "MessageTableView.h"
@interface ChatViewController ()<UITextFieldDelegate,UITextViewDelegate,ChatToolViewDelegate>
@property (nonatomic,strong) ChatToolView   *toolView;
@property (nonatomic,strong) MessageTableView *tableView;
@property (nonatomic,strong) NSMutableArray*   messageFrames;
@property (nonatomic, assign) CGFloat      toolViewHeight;
@end

#define cellIdentifier @"cellIdentifier"


#define MAX_HEIGHT_INPUTVIEW  60.0f
#define CHATTOOLVIEW_HEIGHT  50.0f



@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.00 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.title = @"聊天";
    _toolViewHeight = CHATTOOLVIEW_HEIGHT;

    [self setupTableView];
    [self setupToolView];
    
   
    [self addLeftMenuButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)addLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
#pragma mark - setup
-(void)setupTableView{
    
    CGFloat tableHeight = -kStatusBarHeight -_toolViewHeight;
    self.tableView = [[MessageTableView alloc]init];
    _tableView.messageFrames = [self.messageFrames copy];
    _tableView.viewHeight = _toolViewHeight;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(self.view).offset(tableHeight);
        make.width.equalTo(self.view);
   
    }];
 
    
}
-(void)setupToolView{
    _toolView = [[ChatToolView alloc]init];
    _toolView.contentView.delegate = self;
    _toolView.viewHeight = 50;
    _toolView.delegate = self;
    [self.view addSubview:_toolView];
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(_toolView.viewHeight);
    }];
}
-(void)sendMessageAction:(NSString*)text
{
    [self addMessage:text type:MESSAGEFROMTYPE_ME];

}
-(void)sendImageMessageAction:(NSString *)image{
    [self addMessageImage:@"test" type:MESSAGEFROMTYPE_OTHER];
}
- (NSMutableArray *)messageFrames
{
    if (_messageFrames == nil) {
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil]];
        
        NSMutableArray *mfArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dictArray) {
            // 消息模型
            ChatMessage *msg = [ChatMessage messageWithDict:dict];
            
            // 取出上一个模型
            ChatCellFrame *lastMf = [mfArray lastObject];
            ChatMessage *lastMsg = lastMf.message;
            
            // 判断两个消息的时间是否一致
            msg.hideTime = [msg.time isEqualToString:lastMsg.time];
            
            // frame模型
            ChatCellFrame *mf = [[ChatCellFrame alloc] init];
            mf.message = msg;
            
            // 添加模型
            [mfArray addObject:mf];
        }
        
        _messageFrames = mfArray;
    }
    return _messageFrames;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

#pragma mark - InputView
- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = textView.contentSize;
    if (size.height<MAX_HEIGHT_INPUTVIEW) {
        _toolViewHeight = CHATTOOLVIEW_HEIGHT + (size.height - MAX_HEIGHT_INPUTVIEW/2);
        _toolView.viewHeight = _toolViewHeight;
        [_toolView setNeedsUpdateConstraints];
        [_toolView updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.4 animations:^{
            [_toolView layoutIfNeeded];
        }];
        
       
        
        _tableView.viewHeight = _toolViewHeight;
        [_tableView updateConstraintsIfNeeded];
        [_tableView  setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.4 animations:^{
            [_tableView layoutIfNeeded];
        }];
    }
    if (textView.text.length>0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_HAVE_TEXT
                                                            object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:MESSAGE_HAVE_NO_TEXT object:nil];
    }
   
}
-(void)addMessageImage:(NSString*)image type:(MessageFromType)fromType{
    // 1.数据模型
    ChatMessage *msg = [[ChatMessage alloc] init];
    msg.fromType = fromType;
    msg.type = MESSAGETYPE_IMAGE;
    
    // 设置数据模型的时间
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    // NSDate  --->  NSString
    // NSString ---> NSDate
    //    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //  2014-08-09 15:45:56
    // 09/08/2014  15:45:56
    msg.time = [fmt stringFromDate:now];
    
    // 看是否需要隐藏时间
    ChatCellFrame *lastMf = [self.messageFrames lastObject];
    ChatMessage *lastMsg = lastMf.message;
    msg.hideTime = [msg.time isEqualToString:lastMsg.time];
    msg.myImage = [UIImage imageNamed:image];
    
    // 2.frame模型
    ChatCellFrame *mf = [[ChatCellFrame alloc] init];
    mf.message = msg;
    [self.messageFrames addObject:mf];
    _tableView.messageFrames = [self.messageFrames copy];
    // 3.刷新表格
    [self.tableView reloadData];
    
    // 4.自动滚动表格到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(void)addMessage:(NSString*)text type:(MessageFromType)fromType
{
    // 1.数据模型
    ChatMessage *msg = [[ChatMessage alloc] init];
    msg.fromType = fromType;
    msg.content  = text;
    msg.type = MESSAGETYPE_TEXT;
    
    // 设置数据模型的时间
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    // NSDate  --->  NSString
    // NSString ---> NSDate
    //    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //  2014-08-09 15:45:56
    // 09/08/2014  15:45:56
    msg.time = [fmt stringFromDate:now];
    
    // 看是否需要隐藏时间
    ChatCellFrame *lastMf = [self.messageFrames lastObject];
    ChatMessage *lastMsg = lastMf.message;
    msg.hideTime = [msg.time isEqualToString:lastMsg.time];
  
    
    // 2.frame模型
    ChatCellFrame *mf = [[ChatCellFrame alloc] init];
    mf.message = msg;
    [self.messageFrames addObject:mf];
    _tableView.messageFrames = [self.messageFrames copy];
    // 3.刷新表格
    [self.tableView reloadData];
    
    // 4.自动滚动表格到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
@end
