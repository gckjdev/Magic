//
//  SettingsController.m
//  BarrageClient
//
//  Created by 蔡少武 on 15/1/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "SettingsController.h"
#import "SelectionController.h"
#import "UserService.h"
#import "NormalCell.h"
#import "AboutController.h"
#import "UserManager.h"
#import "FeedbackController.h"

#define kSettingCell @"kSettingCell"

#define TITLE_STYLE @"风格"
#define TITLE_SPEED @"速度"
#define TITLE_SOUND @"声音"
#define TITLE_ABOUT @"关于"
#define TITLE_FEEDBACK @"意见反馈"
#define TITLE_CHECK_UPDATE @"检查新版本"

@interface SettingsController ()

@property (nonatomic,strong) PBUser *user;
@property (nonatomic,assign) int indexOfSection;  //  Section索引，计数功能
@property (nonatomic,assign) int sectionBasic;  //  “基本”Section
@property (nonatomic,assign) int sectionAbout;  //  “关于”Section
@property (nonatomic,strong) NSArray *itemArrBasic; //  “基本”Section中text内容
@property (nonatomic,strong) NSArray *itemArrAbout; //  “关于”Section中text内容
@property (nonatomic,strong) NSArray *styleArray; //  风格内容数组
@property (nonatomic,strong) NSArray *speedArray; //  速度内容数组
@property (nonatomic,strong) NSArray* soundArray; //  开关声音选项，也许以后会增加不同声音选择

@end

@implementation SettingsController

#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)loadView
{
    [super loadView];
    [self loadData];
    [self.tableView registerClass:[NormalCell class] forCellReuseIdentifier:kSettingCell];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BARRAGE_BG_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"设置";
    
}

#pragma mark - Private methods
//  加载数据
- (void)loadData
{
    self.sectionBasic = self.indexOfSection++;
    self.sectionAbout = self.indexOfSection++;
    self.itemArrBasic = @[TITLE_STYLE,TITLE_SPEED,TITLE_SOUND];
    self.itemArrAbout = @[TITLE_ABOUT,TITLE_FEEDBACK,TITLE_CHECK_UPDATE];
    
    //  风格内容数组
    self.styleArray = @[
                        @"摩擦",
                        @"弹簧",
                        @"匀速",
                        @"加速",
                        @"减速",
                        @"先加速再减速",
                        ];
    //  速度内容数组
    self.speedArray = @[
                        @"正常",
                        @"超高速",
                        @"高速",
                        @"低速",
                        @"超低速",
                        ];
    
    self.soundArray = @[
                        @"开",
                        @"关",
                        ];
    
    self.user = [[UserManager sharedInstance] pbUser];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    if (section == self.sectionBasic) {
        num = self.itemArrBasic.count;
    }else if (section == self.sectionAbout) {
        num = self.itemArrAbout.count;
    }else{
        //  TO BE APPENDED
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCell forIndexPath:indexPath];
    if (indexPath.section == self.sectionBasic) {
        NSString *title = self.itemArrAbout[indexPath.row];
        cell.textLabel.text = self.itemArrBasic[indexPath.row];
        
        if ([title isEqualToString:TITLE_STYLE]) {
            cell.detailTextLabel.text = self.styleArray[self.user.bStyle];
        }else if ([title isEqualToString:TITLE_SPEED]) {
            cell.detailTextLabel.text = self.speedArray[self.user.bSpeed];
        }else if ([title isEqualToString:TITLE_SOUND]){
            cell.detailTextLabel.text = self.soundArray[indexPath.row];
            //TODO!!!!!!!!
        }
    }else if (indexPath.section == self.sectionAbout) {
        cell.textLabel.text = self.itemArrAbout[indexPath.row];
    }else{
            //  TO BE APPENDED
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int height = 0;
    if (section == self.sectionBasic) {
        height = 0;
    }else if (section == self.sectionAbout) {
        height = COMMON_TABLEVIEW_HEADER_HEIGHT;
    }else{
        //  TODO
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return COMMON_TABLEVIEW_ROW_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
     UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
    
    /*
     “基本”section
    */
    if (indexPath.section == self.sectionBasic) {
        //风格按钮
        if ([self.itemArrBasic[indexPath.row] isEqualToString:TITLE_STYLE]) {
            
            int currentSelected = self.user.bStyle;
            
            SelectionSaveBlock block = ^(NSInteger selected) {
                if (selected != currentSelected) {
                    PBBarrageStyle selectedBarrageStyle = (SInt32)selected;
                    [[UserService sharedInstance]updateUserBarrageStyle:(selectedBarrageStyle) callback:^(PBUser *pbUser, NSError *error) {
                        PPDebug(@"save BarrageStyle successfully");
                    }];
                    //add by neng,save data
                    [[UserManager sharedInstance]setUserBtyle:(int)selected];
                    [[UserManager sharedInstance]storeUser];
                    
                    cell.detailTextLabel.text = weakSelf.styleArray[selected];
                }
            };
            SelectionController *vc = [[SelectionController alloc]initWithItemArray:self.styleArray  currentSelected:currentSelected saveActionBlock:block];
                                       
            [self.navigationController pushViewController:vc animated:YES];
        }
        //速度按钮
        else if ([self.itemArrBasic[indexPath.row] isEqualToString:TITLE_SPEED]) {
            
            int currentSelected = self.user.bSpeed;
            
            SelectionSaveBlock block =  ^(NSInteger selected) {
                if (selected != currentSelected)
                {
                    PBBarrageSpeed selectedBarrageSpeed = (SInt32)selected;
                    //
                    [[UserService sharedInstance]updateUserBarrageSpeed:(selectedBarrageSpeed) callback:^(PBUser *pbUser, NSError *error) {
                        PPDebug(@"save BarrageSpeed successfully");
                    }];
                    //add by neng,save data
                    [[UserManager sharedInstance]setUserBSpeed:(int)selected];
                    [[UserManager sharedInstance]storeUser];
                    cell.detailTextLabel.text = weakSelf.speedArray[selected];
                }
            };
            
            SelectionController *vc = [[SelectionController alloc]initWithItemArray:self.speedArray currentSelected:currentSelected saveActionBlock:block];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        //声音开关
        else if([self.itemArrBasic[indexPath.row] isEqualToString:TITLE_SOUND]){
            int currentSelected = 0;

            SelectionSaveBlock block =  ^(NSInteger selected) {

            };
            
            SelectionController *vc = [[SelectionController alloc]initWithItemArray:self.soundArray currentSelected:currentSelected saveActionBlock:block];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        else
        {
            //TO BE APPENDED
        }
    }
    /*
     “关于”section
     */
    else if(indexPath.section == self.sectionAbout){
        NSString *title = self.itemArrAbout[indexPath.row];
        if ( [title isEqualToString:TITLE_ABOUT]) {
            AboutController *vc = [[AboutController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if([title isEqualToString:TITLE_FEEDBACK]){
            FeedbackController *vc = [[FeedbackController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if([title isEqualToString:TITLE_CHECK_UPDATE]){
            //  TODO
        }
    }
    /*
     其他
     */
    else{
        //  TODO
    }
}
@end
