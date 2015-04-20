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
    
    
    [self addMessage:@"haha" type:MESSAGETYPE_ME];
   
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
    [self addMessage:text type:MESSAGETYPE_ME];
//     [self addMessageImage:@"test" type:MESSAGETYPE_OTHER];
}
-(void)sendImageMessageAction:(NSString *)image{
    [self addMessageImage:@"test" type:MESSAGETYPE_OTHER];
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

//- (void)keyboardWillShow:(NSNotification *)note
//{
//    // 设置窗口的颜色
//    self.view.window.backgroundColor = self.tableView.backgroundColor;
//    
//    // 0.取出键盘动画的时间
//    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    // 1.取得键盘最后的frame
//    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    // 2.计算控制器的view需要平移的距离
////    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
//    
//    CGFloat tmp =  keyboardFrame.size.height;
//    // 3.执行动画
//    [UIView animateWithDuration:duration animations:^{
//        self.view.transform = CGAffineTransformMakeTranslation(0, -50);
//    }];
//}
//- (void)keyboardWillHide:(NSNotification *)note
//{
//    // 设置窗口的颜色
//    self.view.window.backgroundColor = self.tableView.backgroundColor;
//    
//    // 0.取出键盘动画的时间
//    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    
//    
//    // 1.取得键盘最后的frame
//    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    CGFloat tmp =  keyboardFrame.size.height;
//    
//    // 2.计算控制器的view需要平移的距离
////    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
//    
//    // 3.执行动画
//    [UIView animateWithDuration:duration animations:^{
//        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
//    }];
//}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//     [[NSNotificationCenter defaultCenter]removeObserver:self];
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
-(void)addMessageImage:(NSString*)image type:(MessageType)type{
    // 1.数据模型
    ChatMessage *msg = [[ChatMessage alloc] init];
    msg.type = type;
    msg.hasText = NO;
    
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
    msg.hasImage =YES;
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
-(void)addMessage:(NSString*)text type:(MessageType)type
{
    // 1.数据模型
    ChatMessage *msg = [[ChatMessage alloc] init];
    msg.type = type;
    msg.content  = text;
    msg.hasText = YES;
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
