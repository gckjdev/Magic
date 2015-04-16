//
//  PlusMenuTableViewController.m
//  BarrageClient
//
//  Created by gckj on 15/2/3.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "PlusMenuTableViewController.h"
#import "Masonry.h"
#import "ColorInfo.h"
#import "FontInfo.h"
#import "ViewInfo.h"
#import "UIViewUtils.h"
#import "SearchUserController.h"
#import "UserHomeController.h"
#import "UMFeedback.h"
#import "PPDebug.h"
#import "AppDelegate.h"
#import "FeedbackController.h"
#import "CMPopTipView.h"
#import "EditingController.h"
#import "FriendService.h"
#import "User.pb.h"
#import "TagManager.h"
#import "FriendListController.h"
#import "TagInfoViewController.h"

#define plusMenuTableViewCell @"plusMenuTableViewCell"
#define PLUS_MENU_TABLEVIEW_WIDTH 155   //  整个tableView宽度
#define PLUS_MENU_ROW_HEIGHT 42 //  tableView每行高度
#define TITLE_ACTION_FEEDBACK @"意见反馈"
#define TITLE_ADD_FRIEND      @"添加好友"
#define TITLE_MY_PROFILE      @"个人资料"
#define TITLE_ADD_TAG         @"添加标签"

@interface PlusMenuTableViewController ()

@property (nonatomic,strong)NSArray *itemArr;   //  textLabel中的text
@property (nonatomic,strong)NSArray *imageArr;  //  cell中的图片
@property (nonatomic,assign)NSInteger sectionRowCount; //  辅助行数计算
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic,assign)CGFloat tabelViewHeight;

@end

@implementation PlusMenuTableViewController

#pragma mark - Public methods
+ (id)menuForHome
{
    NSArray* homeTitles = @[TITLE_ADD_FRIEND,TITLE_MY_PROFILE,TITLE_ACTION_FEEDBACK];
    NSArray* homeImages = @[@"plus_menu_add_friend.png",
                            @"plus_menu_home.png",
                            @"plus_menu_feedback.png"];
    
    PlusMenuTableViewController* vc = [[PlusMenuTableViewController alloc] initWithTitle:homeTitles
                                                                              imageNames:homeImages];
    
    return vc;
}

+ (id)menuForFriend
{
    NSArray* homeTitles = @[TITLE_ADD_FRIEND,TITLE_ADD_TAG,TITLE_MY_PROFILE,TITLE_ACTION_FEEDBACK];
    NSArray* homeImages =  @[@"plus_menu_add_friend.png",
                             @"plus_menu_add_tag.png",
                             @"plus_menu_home.png",
                             @"plus_menu_feedback.png"];
    
    PlusMenuTableViewController* vc = [[PlusMenuTableViewController alloc] initWithTitle:homeTitles
                                                                              imageNames:homeImages];
    
    return vc;
}

#pragma mark - Private methods
-(id)initWithTitle:(NSArray*)titles imageNames:(NSArray*)imageNames
{
    self = [super init];
    self.itemArr = titles;
    self.imageArr = imageNames;
    self.sectionRowCount = [titles count];
    self.tabelViewHeight = PLUS_MENU_ROW_HEIGHT*[_itemArr count];
    return self;
}
#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
}
//  加载页面
- (void)loadView
{
    [super loadView];
    self.view.bounds = CGRectMake(0, 0, PLUS_MENU_TABLEVIEW_WIDTH, self.tabelViewHeight);
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:plusMenuTableViewCell];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:plusMenuTableViewCell];
    cell.textLabel.font = BARRAGE_HOME_PULL_DOWN_LABEL_FONT;
    cell.textLabel.textColor = BARRAGE_BG_WHITE_COLOR;
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.text = self.itemArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [UIView addSingleLineWithColor:BARRAGE_HOME_PULL_DOWN_LAYER_COLOR
                       borderWidth:COMMON_LAYER_BORDER_WIDTH
                         superView:cell.contentView];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PLUS_MENU_ROW_HEIGHT;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.popTipView dismissAnimated:NO];
    
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    UINavigationController* currentController = app.currentNavigationController;
    
    NSString *title = self.itemArr[indexPath.row];
    if ( [title isEqualToString: TITLE_ACTION_FEEDBACK] ){
        FeedbackController *vc = [[FeedbackController alloc]init];
        [currentController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString: TITLE_ADD_FRIEND]){
        SearchUserController* vc = [[SearchUserController alloc] init];
        [currentController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString: TITLE_MY_PROFILE]){
        UserHomeController* vc = [[UserHomeController alloc] init];
        [currentController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString: TITLE_ADD_TAG]){

        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        UINavigationController *controller = delegate.currentNavigationController;
        
        TagInfoViewController *tagInfoCont = [[TagInfoViewController alloc]initWithType:IsCreating andPBTag:nil orPBUsers:nil];
        if([controller.visibleViewController isKindOfClass:[FriendListController class]]){
            FriendListController* cont = (FriendListController*)controller.visibleViewController;
            tagInfoCont.delegate = cont;
        }
        [controller pushViewController:tagInfoCont animated:YES];
    }
    else{
        
    }
}
@end
