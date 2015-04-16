//
//  SelectionController.m
//  BarrageClient
//
//  Created by gckj on 15/1/7.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "SelectionController.h"
#import "PPDebug.h"
#import "ColorInfo.h"
#import "FontInfo.h"
#import "UIViewUtils.h"

#define kSelection @"kSelection"

@interface SelectionController ()

@end

@implementation SelectionController

#pragma mark - Public methods

-(id)initWithItemArray:(NSArray *)itemArray currentSelected:(int)currentSelected saveActionBlock:(SelectionSaveBlock)saveActionBlock
{
    self = [super init];
    self.itemArray = itemArray;
    self.currentSelected = currentSelected;
    self.saveActionBlock = saveActionBlock;
    return self;
    
}

#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView
{
    [super loadView];
    [self loadSaveButton];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}
- (void)loadSaveButton
{
    self.saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(clickSaveButton:)];
    
    [self.navigationItem setRightBarButtonItem:self.saveButton];
}

#pragma mark - Util
- (void)clickSaveButton:(id)sender
{
    [self save];
}

- (void)save
{
    EXECUTE_BLOCK(self.saveActionBlock, self.currentSelected);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSelection];
    cell.textLabel.text = self.itemArray[indexPath.row];
    cell.textLabel.textColor = BARRAGE_LABEL_COLOR; //  颜色
    cell.textLabel.font = BARRAGE_LABEL_FONT;   //  字体
    [UILabel addSingleLineWithColor:BARRAGE_CELL_LAYER_COLOR
                        borderWidth:COMMON_LAYER_BORDER_WIDTH
                          superView:cell];
    if (indexPath.row == self.currentSelected ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.currentSelected inSection:0];
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndexPath];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *Cell = [tableView cellForRowAtIndexPath:indexPath];
    Cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.currentSelected = indexPath.row;

    [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:5];
}

@end
