//
//  UserSettingController.m
//  BarrageClient
//
//  Created by pipi on 14/12/11.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//
//  add by Shaowu Cai

#import "UserSettingController.h"
#import "UIViewUtils.h"
#import "UserManager.h"
#import "UserInfoAvatarCell.h"
#import "EditingController.h"
#import "BackgroundCell.h"
#import "UserService.h"
#import "SelectionController.h"
#import "ChangeAvatar.h"
#import "SnsService.h"
#import "PhoneEditImageController.h"
#import "MKBlockAlertView.h"
#import "EmailEditingController.h"
#import <MapKit/MKReverseGeocoder.h>
#import <MapKit/MKPlacemark.h>
#import "AppDelegate.h"
#import "NormalCell.h"
#import "ChangePwdController.h"
#import "BarrageConfigManager.h"

#define kUserInfoCellHeight 52  //  除了第一个Section外，每行的高度
#define kUserAvatarCellHeightForFirst 0    //  第一个Section（显示头像）的header高度
#define kUserCellHeightForHeader 10 //  除了第一个Section外，每个header的高度

#define kUserInfoCell       @"kUserInfoCell"
#define kAvatarTitle        @"头像"
#define kBackgroundTitle    @"背景"
#define kNickTitle          @"昵称"
#define kSinatureTitle      @"签名"

#define kGenderTitle        @"性别"
#define kLocationTitle      @"位置"
#define kChangePwdTitle     @"密码"

#define kQQTitle            @"QQ"
#define kWeixinTitle        @"微信"
#define kSinaTitle          @"微博"
#define kEmailTitle         @"邮箱"
#define kMobileTitle        @"手机"

@interface UserSettingController ()
{
    NSArray *currentLanguageArray;
}
@property (nonatomic,assign) int indexOfSection;  //  Section索引，计数功能
@property (nonatomic,assign) int sectionBasic;
@property (nonatomic,assign) int sectionMisc;
@property (nonatomic,assign) int sectionContact;
@property (nonatomic, strong) NSArray *sectionBasicItems;
@property (nonatomic, strong) NSArray *sectionMiscItems;
@property (nonatomic, strong) NSArray *sectionContactItems;
@property (nonatomic,strong) PBUser* user;
@property (nonatomic,strong) ChangeAvatar* changeAvatar;
@property (nonatomic,strong) CLLocationManager *locationManager;
@end

@implementation UserSettingController

#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.user = [[UserManager sharedInstance] pbUser];
    [self.tableView reloadData];
}

-(void)loadView
{
    [super loadView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BARRAGE_BG_COLOR;
    [self setTitle:@"个人资料"];
}

#pragma mark - UITableviewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    switch (section) {
        case 0:
            rows = (int)[self.sectionBasicItems count];
            break;
        case 1:
            rows = (int)[self.sectionMiscItems count];
            break;
        case 2:
            rows = (int)[self.sectionContactItems count];
            break;
        default:
            //add by neng, Analyze
            rows = 0;
            break;
    }
    return rows;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.section == self.sectionBasic) {
        if ([kAvatarTitle isEqualToString:self.sectionBasicItems[indexPath.row]] || [kBackgroundTitle isEqualToString:self.sectionBasicItems[indexPath.row]]) {
            height = kUserInfoAvatarCellHeight;
        }else{
            height = kUserInfoCellHeight;
        }
    }else{
        height = kUserInfoCellHeight;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == self.sectionBasic) ? kUserAvatarCellHeightForFirst : kUserCellHeightForHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NormalCell *normalCell = [[NormalCell alloc]initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:kUserInfoCell];
    
    if (indexPath.section == self.sectionBasic) {
        if ([kAvatarTitle isEqualToString:self.sectionBasicItems[indexPath.row]]) {
            UserInfoAvatarCell *avatarCell = [[UserInfoAvatarCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                      reuseIdentifier:nil
                                                                                 user:self.user
                                                                      superController:self];
            avatarCell.textLabel.text = self.sectionBasicItems[indexPath.row];
            cell = avatarCell;
        }else if ([kBackgroundTitle isEqualToString:self.sectionBasicItems[indexPath.row]]){
            BackgroundCell *backgroundCell = [[BackgroundCell alloc]
                                              initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:nil
                                              backgroundImg:self.user.avatarBg
                                              bgLabelText:kBackgroundTitle];
            
            cell = backgroundCell;
        }else if ([kNickTitle isEqualToString:self.sectionBasicItems[indexPath.row]]){
            normalCell.textLabel.text = self.sectionBasicItems[indexPath.row];
            normalCell.detailTextLabel.text = self.user.nick;
            cell = normalCell;
        }else if ([kSinatureTitle isEqualToString:self.sectionBasicItems[indexPath.row]]){
            normalCell.textLabel.text = self.sectionBasicItems[indexPath.row];
            normalCell.detailTextLabel.text = self.user.signature;
            cell = normalCell;
        }else{
            //  TODO
        }
    }else if (indexPath.section == self.sectionMisc){
        normalCell.textLabel.text = self.sectionMiscItems[indexPath.row];
        
        if ([kGenderTitle isEqualToString:self.sectionMiscItems[indexPath.row]]){
            NSString *genderStr = self.user.gender ? @"男" : @"女";
            normalCell.detailTextLabel.text = genderStr;
        }else if ([kLocationTitle isEqualToString:self.sectionMiscItems[indexPath.row]]){
            normalCell.detailTextLabel.text = self.user.location;
        }else if ([kChangePwdTitle isEqualToString:self.sectionMiscItems[indexPath.row]]){
            normalCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            //  TODO
        }
        cell = normalCell;
    }else if (indexPath.section == self.sectionContact) {
        normalCell.textLabel.text = self.sectionContactItems[indexPath.row];
        normalCell.detailTextLabel.numberOfLines = 0;   //  邮箱那一行可能会比较长
        NSString *defaultDetailText = @"未授权";
        
        if ([kEmailTitle isEqualToString:self.sectionContactItems[indexPath.row]]) {
            NSString *defaultEmail = @"未设置";
            normalCell.detailTextLabel.text = self.user.email.length == 0 ? defaultEmail : self.user.email;
        }else if ([kMobileTitle isEqualToString:self.sectionContactItems[indexPath.row]]) {
            normalCell.detailTextLabel.text = self.user.mobile.length == 0 ? defaultDetailText : self.user.mobile;
        }else if ([kQQTitle isEqualToString:self.sectionContactItems[indexPath.row]]) {
            NSString *qqNickName = [[UserManager sharedInstance]getQQNick];
            normalCell.detailTextLabel.text = qqNickName.length == 0 ? defaultDetailText : qqNickName;
        }else if ([kWeixinTitle isEqualToString:self.sectionContactItems[indexPath.row]]) {
            NSString *weixinNickName = [[UserManager sharedInstance] getWeChatNick];
            normalCell.detailTextLabel.text = weixinNickName.length == 0 ? defaultDetailText : weixinNickName;
        }else if ([kSinaTitle isEqualToString:self.sectionContactItems[indexPath.row]]) {
            NSString *sinaNick = [[UserManager sharedInstance]getSinaWeiboNick];
            normalCell.detailTextLabel.text = sinaNick.length == 0 ? defaultDetailText : sinaNick;
        }else{
            //  TODO
        }
        cell = normalCell;
    }else {
        //  TODO
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.sectionBasic) {
        if ([kAvatarTitle isEqualToString:self.sectionBasicItems[indexPath.row]]){
            [self updateAvatar];
        }else if ([kNickTitle isEqualToString:self.sectionBasicItems[indexPath.row]]) {
            [self updateNick];
        }else if ([kSinatureTitle isEqualToString:self.sectionBasicItems[indexPath.row]]) {
            [self updateSinature];
        }else if ([kBackgroundTitle isEqualToString:self.sectionBasicItems[indexPath.row]]) {
            [self updateBackgroundImage];
        }else{
            //  TODO
        }
    }else if(indexPath.section == self.sectionMisc){
        if ([kGenderTitle isEqualToString:self.sectionMiscItems[indexPath.row]]) {
            [self updateGender];
        }else if ([kLocationTitle isEqualToString:self.sectionMiscItems[indexPath.row]]) {
            [self triggerLocationServices];
        }else if ([kChangePwdTitle isEqualToString:self.sectionMiscItems[indexPath.row]]){
            ChangePwdController *vc = [[ChangePwdController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //  TODO
        }
    }else if (indexPath.section == self.sectionContact) {
        if ([kQQTitle isEqualToString:self.sectionContactItems[indexPath.row]]) {
            [self connectToSNS:ShareTypeQQSpace];
        }else if ([kWeixinTitle isEqualToString:self.sectionContactItems[indexPath.row]]) {
            [self connectToSNS:ShareTypeWeixiSession];
        }else if ([kSinaTitle isEqualToString:self.sectionContactItems[indexPath.row]]) {
            [self connectToSNS:ShareTypeSinaWeibo];
        }else if ([kEmailTitle isEqualToString:self.sectionContactItems[indexPath.row]]) {
            [self updateEmail];
        }else if ([kMobileTitle isEqualToString:self.sectionContactItems[indexPath.row]]) {
            [self updateMobile];
        }else{
            //  TODO
        }
    }else{
        //  TODO
    }
    
}

#pragma mark - Private methods

- (void)loadData
{
    self.sectionBasic = self.indexOfSection++;
    self.sectionMisc = self.indexOfSection++;
    self.sectionContact = self.indexOfSection++;
    self.sectionBasicItems = @[kAvatarTitle,kBackgroundTitle,kNickTitle,kSinatureTitle];
    self.sectionMiscItems = @[kGenderTitle,kLocationTitle,kChangePwdTitle];
    self.sectionContactItems = @[kQQTitle,kWeixinTitle,kSinaTitle,kMobileTitle,kEmailTitle];
}

#pragma mark - Utils
- (void)connectToSNS:(ShareType)shareType
{
    if ([[SnsService sharedInstance] isAuthenticated:shareType] &&
        [[SnsService sharedInstance] isExpired:shareType] == NO){
        // show alert view to confirm connect SNS network again
    }else{
        [[SnsService sharedInstance] autheticate:shareType];
    }
}
-(void)triggerLocationServices
{
    // 如果定位服务可用
    if([CLLocationManager locationServicesEnabled]){
        self.locationManager = [[CLLocationManager alloc]init];
        [self updatingLocation];
    }else{
        POST_ERROR(@"无法使用定位服务！");
    }
}

//  when invoked,update location
- (void)updatingLocation
{
    //  save default language
    currentLanguageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//    NSLog(@"%@",[currentLanguageArray objectAtIndex:0]);
    //  set language what you want to display,now is Chinese
    
    [[NSUserDefaults standardUserDefaults] setObject: [NSArray arrayWithObjects:@"cn", nil] forKey:@"AppleLanguages"];
    
//    NSLog(@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0]);
//    NSLog( @"开始执行定位服务" );
    // 设置定位精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    // 设置距离过滤器
    self.locationManager.distanceFilter = 10000;
    // 将视图控制器自身设置为CLLocationManager的delegate
    self.locationManager.delegate = self;
    // 开始监听定位信息
    [self.locationManager startUpdatingLocation];
}

-(void)showAlertView
{
    NSString *titleCancel = @"取消";
    NSString *titleOpenSetting = @"设置";
    NSString *messageStr = [NSString stringWithFormat:@"打开“定位服务”以允许“%@”确定您的位置",APP_DISPLAY_NAME];

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil
                                                       message:messageStr
                                                      delegate:self
                                             cancelButtonTitle:titleCancel
                                             otherButtonTitles:nil];
    if (&UIApplicationOpenSettingsURLString) {
        [alertView  addButtonWithTitle:titleOpenSetting];
    }
    alertView.delegate = self;
    [alertView show];
}

//  reverse geocode with location
- (void)reverseGeocode:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks,NSError* error){
        if (nil != error) {
            PPDebug(@"error %@",[error description]);
            POST_ERROR(@"定位失败，请稍后重试");
        }else if ([placemarks count] > 0){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSRange displayRange = NSMakeRange(0, 2);
            //  分别取2位
            NSString *countryDisplayStr = [placemark.country substringWithRange:displayRange];
            NSString *administrativeAreaDisplayStr = [placemark.administrativeArea substringWithRange:displayRange];
            NSString *localityDisplayStr = [placemark.locality substringWithRange:displayRange];
            
            NSString *placeDisplayStr;
            
            if ([[[NSLocale preferredLanguages] objectAtIndex:0]  isEqual: @"zh-Hans"]) {
                placeDisplayStr = [NSString stringWithFormat:@"%@ %@ %@",countryDisplayStr,administrativeAreaDisplayStr,localityDisplayStr];
            }else{
                placeDisplayStr = [NSString stringWithFormat:@"%@ %@ %@",placemark.locality,placemark.administrativeArea,placemark.country];
            }
            
            [[UserService sharedInstance]updateUserLocation:placeDisplayStr callback:^(PBUser *pbUser, NSError *error) {
                POST_SUCCESS_MSG(@"定位成功");
                [self.locationManager stopUpdatingLocation];
                self.user = pbUser;
                [self.tableView reloadData];
            }];
        }
    }];
}

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
- (void)updateGender
{
    NSArray *itemArray = @[@"男",@"女"];
    int currentSelected = (self.user.gender) ? 0 : 1;
    SelectionController *vc = [[SelectionController alloc]initWithItemArray:itemArray
                                                            currentSelected:currentSelected
                                                            saveActionBlock:^(NSInteger selected) {
                                                                if (selected != currentSelected) {
                                                                    BOOL gender = selected == 0 ? YES : NO;
                                                                    [[UserService sharedInstance]updateUserGender:gender callback:^(PBUser *pbUser, NSError *error) {
                                                                        if (error == nil) {
                                                                            POST_ERROR(@"修改性别失败");
                                                                        }else{
                                                                            POST_SUCCESS_MSG(@"修改性别成功");
                                                                            self.user = pbUser;
                                                                            [self.tableView reloadData];
                                                                        }
                                                                    }];
                                                                    
                                                                }
                                                                
                                                            }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)updateEmail
{
    EmailEditingController *vc = [[EmailEditingController alloc]initWithText:self.user.email
                                                             placeHolderText:@"邮箱:bbj@example.com"
                                                                        tips:@"请输入邮箱"
                                                                     isMulti:NO
                                                             saveActionBlock:^(NSString *text) {
                                                                 if ([text length] == 0) {
                                                                     return ;
                                                                 }
                                                                 [[UserService sharedInstance] updateUserEmail:text callback:^(PBUser *pbUser, NSError *error) {
                                                                     if (error == nil) {
                                                                         POST_ERROR(@"修改邮箱失败");
                                                                     }else{
                                                                         POST_SUCCESS_MSG(@"修改邮箱成功");
                                                                         self.user = pbUser;
                                                                         [self.tableView reloadData];
                                                                     }
                                                                 }];
                                                             }];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)updateMobile
{
    //add by neng
    PhoneEditImageController *vc = [[PhoneEditImageController alloc] initWithText:_user.mobile
                                                                      placeHolder:@"11位手机号码"
                                                                             tips:@"请输入手机号码"
                                                                  saveActionBlock:^(NSString *text) {
                                                                      if ([text length] == 0) {
                                                                          return ;
                                                                      }
                                                                      
                                                                      [[UserService sharedInstance] updateUserMobile:text callback:^(PBUser *pbUser, NSError *error) {
                                                                          if (error == nil) {
                                                                              POST_ERROR(@"修改手机号码失败");
                                                                          }else{
                                                                              POST_SUCCESS_MSG(@"修改手机号码成功");
                                                                              self.user = pbUser;
                                                                              [self.tableView reloadData];
                                                                          }
                                                                      }];
                                                                  }];
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied) {
        [self showAlertView];
    }else{
        return;
    }
}

//  TODO invoked twice Why?
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 获取最后一个定位数据
    CLLocation* location = [locations lastObject];

    [self reverseGeocode:location];
    //  set user's default language
  
    [[NSUserDefaults standardUserDefaults] setObject: currentLanguageArray forKey:@"AppleLanguages"];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    PPDebug(@"location error %@",[error description]);
    POST_ERROR(@"定位服务出现错误");
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            //  open setting
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            [alertView hideActivityViewAtCenter];
            break;
        default:
            //  TODO
            break;
    }
}
@end
