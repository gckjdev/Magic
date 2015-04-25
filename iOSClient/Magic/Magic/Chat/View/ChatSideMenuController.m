//
//  ChatSideMenuController.m
//  Magic
//
//  Created by Teemo on 15/4/22.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "ChatSideMenuController.h"
#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "ViewInfo.h"
#import "ColorInfo.h"
#import "FontInfo.h"
#import "UIViewUtils.h"

#define MENUITEM_COUNT 3
#define MENUITEM_HEIGHT 52
#define CHATSIDEMENUCELL         @"CHATSIDEMENUCELL"

@interface ChatSideMenuController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView   *tableView;
@end

@implementation ChatSideMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupView{
    [self.view setBackgroundColor:BARRAGE_BG_COLOR];
}
-(void)setupTableView{
    
    self.tableView = ({
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - MENUITEM_HEIGHT * MENUITEM_COUNT) / 2.0f, 200, MENUITEM_HEIGHT * MENUITEM_COUNT) ];
   UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, CHATSIDEMENUVIEW_WIDTH, self.view.frame.size.height) ];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor whiteColor];
      
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       
    
        tableView;
    });
    [self.view addSubview:self.tableView];
    
}
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self dismissViewControllerAnimated:YES completion:^{
                 [[AppDelegate sharedInstance]showNormalHome];
            }];
            break;
        case 1:
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
            }];
            break;
    }
}
#pragma mark - tableView Source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MENUITEM_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return MENUITEM_COUNT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *normalCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                         reuseIdentifier:CHATSIDEMENUCELL];
    
    normalCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    normalCell.textLabel.font = BARRAGE_LABEL_FONT; //  字体
    normalCell.textLabel.textColor = BARRAGE_TEXTFIELD_COLOR;   //  颜色
    normalCell.backgroundColor = [UIColor whiteColor];

    NSArray *titles = @[@"个人资料",  @"系统设置", @"意见反馈"];
    NSArray *images = @[@"friends",  @"setting", @"invite.png"];
    normalCell.textLabel.text = titles[indexPath.row];
    normalCell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return normalCell;
}
@end
