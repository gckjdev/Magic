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
#define MENUITEM_COUNT 3
#define MENUITEM_WIDTH 54

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
    
}
-(void)setupTableView{
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - MENUITEM_WIDTH * MENUITEM_COUNT) / 2.0f, self.view.frame.size.width, MENUITEM_WIDTH * MENUITEM_COUNT) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin ;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
    
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
    return MENUITEM_WIDTH;
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
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
#warning TODO
    NSArray *titles = @[@"Home",  @"Profile", @"Settings", @"Calendar",@"Log Out"];
    NSArray *images = @[@"IconHome",  @"IconProfile", @"IconSettings",@"IconCalendar", @"IconEmpty"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}
@end
