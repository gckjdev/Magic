//
//  PickFriendListViewController.m
//  BarrageClient
//
//  Created by HuangCharlie on 2/2/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "PickFriendListViewController.h"
#import <Masonry.h>
#import "User.pb.h"
#import "FriendManager.h"
#import "UserAvatarView.h"
#import "PickFriendTableViewCell.h"

@interface PickFriendListViewController ()<UITableViewDataSource,UITableViewDelegate>
{

}

@property (nonatomic,strong) UITableView *pickTableView;
@property (nonatomic,strong) UIBarButtonItem *doneButt;

@property (nonatomic,strong) NSMutableArray* statusArray;

@end

@implementation PickFriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"选择好友"];
    self.doneButt = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onButton:)];
    [self.navigationItem setRightBarButtonItem:self.doneButt];
    
    [self addPickFriendListTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addPickFriendListTableView
{
    self.pickTableView = [[UITableView alloc]init];
    self.pickTableView.delegate = self;
    self.pickTableView.dataSource = self;
    self.pickTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.pickTableView];
    [self.pickTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    //init status array
    self.statusArray = [[NSMutableArray alloc]init];
    for(int i = 0 ; i < [self getTableViewCount];i++)
    {
        [self.statusArray addObject:@(NO)];
    }
}

- (void)onButton:(id)sender
{
    self.pickedFriends = [[NSMutableArray alloc]init];
    NSArray *allFriends = [[FriendManager sharedInstance]friendList];
    for(int i = 0; i < [self.statusArray count];i++)
    {
        if([[self.statusArray objectAtIndex:i]boolValue] == YES)
            [self.pickedFriends addObject:[allFriends objectAtIndex:i]];
    }

    PPDebug(@"<picked friend count> %d", [self.pickedFriends count]);
    [self.navigationController popViewControllerAnimated:YES];

    // invoke callback here
    EXECUTE_BLOCK(self.pickFriendCallback, self.pickedFriends);
}

#pragma mark --- getter of user and count
- (NSUInteger)getTableViewCount
{
    NSArray* friendList = [[FriendManager sharedInstance]friendList];
    NSUInteger count = [friendList count];
    return count;
}

- (PBUser*)getUser:(NSUInteger)row
{
    NSArray* friendList = [[FriendManager sharedInstance] friendList];
    NSUInteger friendCount = [friendList count];
    
    if (row >= friendCount)
        return nil;
    else
        return [friendList objectAtIndex:row];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --- tableview delegate
//for building up cell of table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"PickFriendCell";
    PickFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[PickFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellWithIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    PBUser* pbUser = [self getUser:row];
    [cell updateWithUser:pbUser];
    [UIView addBottomLineWithColor:BARRAGE_BG_COLOR borderWidth:1 superView:cell];
    
    BOOL status = [[self.statusArray objectAtIndex:row]boolValue];
    if(status == YES)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

//for the number of rows that displays
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getTableViewCount];
}

//每一行的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//对每一行进行不同的操作，通过行的index进行区分
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBUser* user = [self getUser:indexPath.row];
    if([self.originPickedArray containsObject:user])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //TODO:考虑合适的交互方式
        cell.userInteractionEnabled = NO;
    }
}
//选中某一行的时候，进行的一些action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL old = [[self.statusArray objectAtIndex:indexPath.row]boolValue];
    [self.statusArray replaceObjectAtIndex:indexPath.row withObject:@(!old)];
    [tableView reloadData];
}
//对某一行进行删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"执行删除操作");
}





@end
