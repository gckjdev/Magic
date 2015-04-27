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
#import "ChatService.h"
#import "UserManager.h"
#import "ChangeAvatar.h"
#import "ChatCellFrame.h"
#import "MessageTableView.h"
#import "TGRImageViewController.h"

@interface ChatViewController ()<UITextFieldDelegate,UITextViewDelegate,ChatToolViewDelegate>
@property (nonatomic,strong) ChatToolView   *toolView;
@property (nonatomic,strong) MessageTableView *tableView;
@property (nonatomic,strong) NSMutableArray*   messageFrames;
@property (nonatomic, assign) CGFloat      toolViewHeight;
@property (nonatomic,strong) ChangeAvatar   *changeAvatar;
@end



#define MAX_HEIGHT_INPUTVIEW  60.0f
#define CHATTOOLVIEW_HEIGHT  50.0f



@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
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

-(void)setupView{
    self.view.backgroundColor = [UIColor colorWithRed:235/255.00 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.title = @"聊天";
    _toolViewHeight = CHATTOOLVIEW_HEIGHT;
    self.changeAvatar = [[ChangeAvatar alloc] init];
}

-(void)setupTableView{
    
    CGFloat tableHeight =  -_toolViewHeight;
    self.tableView = [[MessageTableView alloc]init];
   
    _tableView.viewHeight = _toolViewHeight;
    
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(self.view).offset(tableHeight);
        make.width.equalTo(self.view);
        make.top.equalTo(self.view);
   
    }];
 
    [_tableView RefreshData];
    
    __weak typeof(self) weakSelf = self;
    _tableView.imageViewSinglePressBlock = ^(PBChat* pbChat,UIImage *image){
        TGRImageViewController *vc = [[TGRImageViewController alloc] initWithImage:image];
        [weakSelf presentViewController:vc animated:YES completion:nil];
    };
}

-(void)setupToolView{
    _toolView = [[ChatToolView alloc]init];
    _toolView.contentView.delegate = self;
    _toolView.viewHeight = _toolViewHeight;
    _toolView.delegate = self;
    [self.view addSubview:_toolView];
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(_toolView.viewHeight);
    }];
}
-(void)sendMessageButtonSingleTouch:(NSString*)text
{
//    [self addMessage:text type:MESSAGEFROMTYPE_ME];
    [[ChatService sharedInstance]sendChatWithText:text toUserId:nil callback:^(NSError *error) {
        [_tableView RefreshData];
    }];

}
-(void)expressionButtonSingleTouch{
//    [self addMessageImage:@"test" type:MESSAGEFROMTYPE_OTHER];
//    [[ChatService sharedInstance]sendChatWithImage:[UIImage imageNamed:@"test"] toUserId:nil callback:^(NSError *error) {
//        [_tableView RefreshData];
//    }];
  
 
}
-(void)plusButtonSingleTouch
{
    
    [self.changeAvatar showSelectionView:self
                                delegate:nil
                      selectedImageBlock:^(UIImage *image) {
                          
                          if (image){
                              [[ChatService sharedInstance]sendChatWithImage:image toUserId:nil callback:^(NSError *error) {
                                  [_tableView RefreshData];
                              }];
                              
                          }
                          
                      } didSetDefaultBlock:^{
                          
                      } title:@"请选择"
                         hasRemoveOption:NO
                            canTakePhoto:YES
                       userOriginalImage:YES];
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
    
    if (textView.text.length>0) {
        [_toolView.placeHolder setHidden:YES];
    }
    else{
        [_toolView.placeHolder setHidden:NO];
    }
    
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
//-(void)addMessageImage:(NSString*)image type:(MessageFromType)fromType{
//    // 1.数据模型
//    ChatMessage *msg = [[ChatMessage alloc] init];
//    msg.fromType = fromType;
//    msg.type = MESSAGETYPE_IMAGE;
//    
//    // 设置数据模型的时间
//    NSDate *now = [NSDate date];
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"HH:mm";
//    // NSDate  --->  NSString
//    // NSString ---> NSDate
//    //    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    //  2014-08-09 15:45:56
//    // 09/08/2014  15:45:56
//    msg.time = [fmt stringFromDate:now];
//    
//    // 看是否需要隐藏时间
//    ChatCellFrame *lastMf = [self.messageFrames lastObject];
//    ChatMessage *lastMsg = lastMf.message;
//    msg.hideTime = [msg.time isEqualToString:lastMsg.time];
//    msg.myImage = [UIImage imageNamed:image];
//    
//    // 2.frame模型
//    ChatCellFrame *mf = [[ChatCellFrame alloc] init];
//    mf.message = msg;
//    [self.messageFrames addObject:mf];
//    _tableView.messageFrames = [self.messageFrames copy];
//    // 3.刷新表格
//    [self.tableView reloadData];
//    
//    // 4.自动滚动表格到最后一行
//    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//}
//-(void)addMessage:(NSString*)text type:(MessageFromType)fromType
//{
//    // 1.数据模型
//    ChatMessage *msg = [[ChatMessage alloc] init];
//    msg.fromType = fromType;
//    msg.content  = text;
//    msg.type = MESSAGETYPE_TEXT;
//    
//    // 设置数据模型的时间
//    NSDate *now = [NSDate date];
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"HH:mm";
//    // NSDate  --->  NSString
//    // NSString ---> NSDate
//    //    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    //  2014-08-09 15:45:56
//    // 09/08/2014  15:45:56
//    msg.time = [fmt stringFromDate:now];
//    
//    // 看是否需要隐藏时间
//    ChatCellFrame *lastMf = [self.messageFrames lastObject];
//    ChatMessage *lastMsg = lastMf.message;
//    msg.hideTime = [msg.time isEqualToString:lastMsg.time];
//  
//    
//    // 2.frame模型
//    ChatCellFrame *mf = [[ChatCellFrame alloc] init];
//    mf.message = msg;
//    [self.messageFrames addObject:mf];
//    _tableView.messageFrames = [self.messageFrames copy];
//    // 3.刷新表格
//    [self.tableView reloadData];
//    
//    // 4.自动滚动表格到最后一行
//    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//}
@end
