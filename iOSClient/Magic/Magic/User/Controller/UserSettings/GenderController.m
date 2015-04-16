//
//  SexController.m
//  BarrageClient
//
//  Created by 蔡少武 on 15/1/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "GenderController.h"
#import "PPDebug.h"

@interface GenderController ()

@end

@implementation GenderController

-(id)initWithGender:(BOOL)Gender saveActionBlock:(GenderSaveBlock)saveActionBlock
{
    self.Gender = Gender;
    self.saveActionBlock  = saveActionBlock;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSaveButton];
    self.tableView.tableFooterView = [[UIView alloc]init];
}


- (void)loadSaveButton
{
    self.saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(buttonSave)];
    
    [self.navigationItem setRightBarButtonItem:self.saveButton];
}

- (void)buttonSave
{
    [self save];
}

- (void)save
{
    EXECUTE_BLOCK(self.saveActionBlock, self.Gender);
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUserGenderCell];

    cell.textLabel.text = (indexPath.row == 0) ? @"男" : @"女";
    return cell;
}

#warning 如何实现点击一行，另外一行不能点击，还有点击之后如何修改用户数据
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

@end
