//
//  StyleController.m
//  BarrageClient
//
//  Created by 蔡少武 on 15/1/6.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "StyleController.h"

@interface StyleController ()

@property (nonatomic,strong)NSArray *itemArr;

@end

@implementation StyleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData
{
    self.itemArr = [[NSArray alloc]init];
    
    self.itemArr = @[@"风格1",
                     @"风格2",
                     @"风格3",
                     ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStyleCell];
    
    cell.textLabel.text = self.itemArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}
@end
