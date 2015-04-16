//
//  SpeedController.m
//  BarrageClient
//
//  Created by 蔡少武 on 15/1/6.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "SpeedController.h"

@interface SpeedController ()

@property (nonatomic,strong)NSArray *itemArr;

@end

@implementation SpeedController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData
{
    self.itemArr = [[NSArray alloc]init];
    self.itemArr = @[@"速度1",
                     @"速度2",
                     @"速度3",
                     ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSpeedCell];
    cell.textLabel.text = self.itemArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}
@end
