//
//  UserHomeController.m
//  BarrageClient
//
//  Created by pipi on 14/11/28.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "UserHomeController.h"
#import "UserAvatarCell.h"
#import "Masonry.h"
#import "UIViewUtils.h"
#import "UserSettingController.h"
#import "SettingsController.h"
#import "InviteCodeListController.h"
#import "InviteCodeManager.h"
#import "ChangeAvatar.h"
#import "UserService.h"
#import "UserSettingController.h"
#import "UserManager.h"
#import "UserAvatarView.h"
#import "UIViewController+Utils.h"
#import "EditingController.h"
#import "RDVTabBarController.h"
#import "AppDelegate.h"
#import "UserAlbumViewController.h"
#import "ChatViewController.h"

#ifdef DEBUG

#import "LoginHomeWithInviteCodeController.h"
#import "InviteCodePassController.h"
#import "LoginController.h"

#endif

const float kCellRowHeight = 52;    //  除了首个Section外，每行的高度
const float kHeaderHeight = 10;     //  除了首个Section外，每个header的高度
#define TITLE_CHANGE_NICKNAME       @"昵称"
#define TITLE_CHANGE_SINATURE       @"签名"
#define TITLE_CANCEL                @"取消"
#define TITLE_CHANGE_ACTION_SHEET   @"请选择要修改的内容"
#define kUserSettingsAvatarCell         @"kUserSettingsAvatarCell"
#define kUserSettingsNormalCell         @"kUserSettingsNormalCell"

@interface UserHomeController ()<AvatarViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong)PBUser *user;
@property (nonatomic,assign) int indexOfsection;  //  辅助section计算的

@property (nonatomic,assign)int sectionAvatar;  //  头像
@property (nonatomic,assign)int sectionBasic;   //  基本
@property (nonatomic,assign)int sectionContract;    //  联系
@property (nonatomic,assign)int sectionSettings;    //  设置

@property (nonatomic,assign) int sectionBasicRowCount;  //  辅助“基本”那个section的计算

@property (nonatomic,assign) int rowAvatar; //  头像行号

@property (nonatomic,assign) int rowFriends;    //  我的好友行号
@property (nonatomic,assign) int rowInvite;     //  邀请好友行号

@property (nonatomic,assign) int row2DCode;     //  我的二维码名片行号

@property (nonatomic,assign) int rowSetting;    //  设置 行号

@property (nonatomic,strong) ChangeAvatar* changeAvatar;
@property (nonatomic,strong) NSArray *changeActionSheetTitleArray;

@end

@implementation UserHomeController

#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
#warning 作为测试入口
#ifdef DEBUG
    [self addRightButtonWithTitle:@"test" target:self action:@selector(clickTestButton)];
#endif
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication]setStatusBarHidden:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //reload view with data
    //  加载用户数据
    self.user = [[UserManager sharedInstance] pbUser];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication]setStatusBarHidden:NO];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loadView
{
    [super loadView];
    self.title = @"我的主页";
    [self.tableView registerClass:[UserAvatarCell class]
           forCellReuseIdentifier:kUserSettingsAvatarCell]; //  注册的必须用identifier
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BARRAGE_BG_COLOR;
}

#pragma mark - Private methods

- (void)loadData
{
    //  排列Section
    self.indexOfsection = 0;
    self.sectionAvatar = self.indexOfsection++;
    self.sectionBasic = self.indexOfsection++;
    self.sectionContract = self.indexOfsection++;
    self.sectionSettings = self.indexOfsection++;
    
    //  排列Avatar这个section的行
    self.rowAvatar = 0;
    
    //  排列Basic这个section的行
    self.sectionBasicRowCount = 0;
    self.rowFriends = self.sectionBasicRowCount++;
    self.rowInvite = self.sectionBasicRowCount++;
    
    //  排列2DCode这个section的行
    self.row2DCode = 0;
    
    //  排列setting这个section的行
    self.rowSetting = 0;
    
    self.changeActionSheetTitleArray = @[TITLE_CHANGE_NICKNAME,TITLE_CHANGE_SINATURE,TITLE_CANCEL];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == self.sectionAvatar) ? COMMON_AVATARCELL_HEIGHT : kCellRowHeight ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    if (section == self.sectionAvatar) {
        height = 0;
    }else if (section == self.sectionBasic){
        height = 0;
    }else{
        height = kHeaderHeight;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.sectionAvatar &&indexPath.row == self.rowAvatar) {
        UserAlbumViewController *vc = [[UserAlbumViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == self.sectionBasic) {
        if (indexPath.row == self.rowFriends) {
            UserSettingController *vc = [[UserSettingController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == self.rowInvite) {
            InviteCodeListController *vc = [[InviteCodeListController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section ==  self.sectionSettings) {
        if (indexPath.row == self.rowSetting) {
            SettingsController *vc = [[SettingsController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == self.sectionContract) {
        if (indexPath.row == self.row2DCode) {
            UserAlbumViewController *vc = [[UserAlbumViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexOfsection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    int rows;
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = self.sectionBasicRowCount;
            break;
        case 2:
            rows = 1;
            break;
        case 3:
            rows = 1;
            break;
        default:
            //add by neng, Analyze
            rows = 1;
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == self.sectionAvatar) {
        UserAvatarCell *avatarCell = [[UserAvatarCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                          reuseIdentifier:nil
                                                                     user:self.user];
        avatarCell.userAvatarView.delegate = self;
        avatarCell.clickNickNameLabelBlock = ^{
            [self showChangeActionSheet];
        };
        cell = avatarCell;
    } else {
        UITableViewCell  *normalCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                             reuseIdentifier:kUserSettingsNormalCell];

        normalCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        normalCell.textLabel.font = BARRAGE_LABEL_FONT; //  字体
        normalCell.textLabel.textColor = BARRAGE_TEXTFIELD_COLOR;   //  颜色
        
        //  添加Cell下方的横线
        [UIView addSingleLineWithColor:BARRAGE_CELL_LAYER_COLOR
                           borderWidth:COMMON_LAYER_BORDER_WIDTH
                             superView:normalCell];
        
        if (indexPath.section == self.sectionBasic) {
            if (indexPath.row == self.rowFriends) {
                normalCell.textLabel.text = @"个人资料";
                normalCell.imageView.image = [UIImage imageNamed:@"friends.png"];
            }else if (indexPath.row == self.rowInvite) {
                PBUserInviteCodeList* list = [[InviteCodeManager sharedInstance] getUserInviteCodeList];
                int remainNum = (int)list.availableCodes.count;
                
                normalCell.textLabel.text = @"邀请码";
                normalCell.imageView.image = [UIImage imageNamed:@"invite.png"];
                normalCell.detailTextLabel.font = BARRAGE_LITTLE_LABEL_FONT;    //字体
                normalCell.detailTextLabel.text = [NSString stringWithFormat:@"剩余%d个名额",remainNum];
            }
        }else if (indexPath.section == self.sectionContract) {
            if (indexPath.row == self.row2DCode) {
                normalCell.textLabel.text = @"相册";
                normalCell.imageView.image = [UIImage imageNamed:@"album.png"];
            }
        }else if (indexPath.section == self.sectionSettings) {
            if (indexPath.row == self.rowSetting) {
                normalCell.textLabel.text = @"设置";
                normalCell.imageView.image = [UIImage imageNamed:@"setting.png"];
            }
        }
        cell =  normalCell;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - AvatarViewDelegate
- (void)didClickOnAvatarView:(UserAvatarView *)avatarView
{
    [self updateAvatar];
}

#pragma mark - Utils
//  上传头像
- (void)updateAvatar
{
    self.changeAvatar = [[ChangeAvatar alloc] init];
    self.changeAvatar.autoRoundRect = NO;   //  不要圆角
    self.changeAvatar.imageSize = CGSizeMake(AVATAR_IMAGE_UPLOAD_SIZE, AVATAR_IMAGE_UPLOAD_SIZE);
    [self.changeAvatar showSelectionView:self
                                delegate:nil
                      selectedImageBlock:^(UIImage *image) {
                          
                          if (image){
                              [[UserService sharedInstance] uploadUserAvatar:image
                                                                    callback:^(PBUser *pbUser, NSError *error) {
                                                                        if (error){
                                                                            POST_ERROR(@"上传头像失败，请稍后再试");
                                                                        }
                                                                        else{
                                                                            POST_SUCCESS_MSG(@"头像已更新");
                                                                            self.user = pbUser;
                                                                            [self.tableView reloadData];
                                                                        }
                                                                    }];
                          }
                          
                      } didSetDefaultBlock:^{
                          
                      } title:@"请选择"
                         hasRemoveOption:NO
                            canTakePhoto:YES
                       userOriginalImage:YES];
}
//  上传背景图片
- (void)updateBackgroundImage
{
    self.changeAvatar = [[ChangeAvatar alloc] init];
    self.changeAvatar.autoRoundRect = NO;   //  不要圆角
    self.changeAvatar.imageSize = CGSizeMake(kScreenWidth, kScreenWidth);
    [self.changeAvatar showSelectionView:self
                            delegate:nil
                  selectedImageBlock:^(UIImage *image) {
                      
                      if (image){
                          [[UserService sharedInstance] uploadUserBackground:image
                                                                    callback:^(PBUser *pbUser, NSError *error) {
                                                                        if (error){
                                                                            POST_ERROR(@"上传图片失败，请稍后再试");
                                                                        }
                                                                        else{
                                                                            POST_SUCCESS_MSG(@"背景已更新");
                                                                            self.user = pbUser;
                                                                            [self.tableView reloadData];
                                                                        }
                                                                    }];
                      }
                      
                  } didSetDefaultBlock:^{
                      
                  } title:@"请选择"
                     hasRemoveOption:NO
                        canTakePhoto:YES
                   userOriginalImage:YES];
}
- (void)showChangeActionSheet
{

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:TITLE_CHANGE_ACTION_SHEET
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    for (NSString *title in self.changeActionSheetTitleArray) {
       [actionSheet addButtonWithTitle:title];
    }
    [actionSheet setCancelButtonIndex:[self.changeActionSheetTitleArray indexOfObject:TITLE_CANCEL]];
    [actionSheet showInView:self.view];

}

-(void)clickTestButton{
    [self hideTabBar];
    
    ChatViewController *vc = [[ChatViewController alloc]init];
  [self presentViewController:vc animated:NO completion:nil];
}
- (void)updateNick
{
    EditingController *vc = [[EditingController alloc]initWithText:self.user.nick
                                                   placeHolderText:@"请输入名字！"
                                                              tips:@"好名字能让你的朋友更快记住你！"
                                                           isMulti:NO
                                                   saveActionBlock:^(NSString *text) {
                                                       if ([text length] == 0){
                                                           POST_ERROR(@"不能输入空的名字");
                                                           return;
                                                       }
                                                       
                                                       [[UserService sharedInstance] updateUserNick:text
                                                                                           callback:^(PBUser *pbUser, NSError *error) {
                                                                                               if (error) {
                                                                                                   POST_ERROR(@"修改昵称失败");
                                                                                               }else{
                                                                                                   POST_SUCCESS_MSG(@"修改昵称成功");
                                                                                                   self.user = pbUser;
                                                                                                   [self.tableView reloadData];
                                                                                               }
                                                                                           }];
                                                   }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)updateSinature
{
    EditingController *vc = [[EditingController alloc]initWithText:self.user.signature
                                                   placeHolderText:@"请输入个性签名！"
                                                              tips:nil
                                                           isMulti:YES
                                                   saveActionBlock:^(NSString *text) {
                                                       if ([text length] == 0) {
                                                           POST_ERROR(@"不能输入空的签名");
                                                           return ;
                                                       }
                                                       [[UserService sharedInstance] updateUserSignature:text callback:^(PBUser *pbUser, NSError *error) {
                                                           if (error) {
                                                               POST_ERROR(@"修改签名失败");
                                                           }else{
                                                               POST_SUCCESS_MSG(@"修改签名成功");
                                                               self.user = pbUser;
                                                               [self.tableView reloadData];
                                                           }
                                                       }];
                                                       
                                                   }];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        actionSheet.hidden = YES;
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString: TITLE_CHANGE_NICKNAME]) {
        [self updateNick];
    }else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:TITLE_CHANGE_SINATURE]){
        [self updateSinature];
    }else{
        
    }
}
@end
