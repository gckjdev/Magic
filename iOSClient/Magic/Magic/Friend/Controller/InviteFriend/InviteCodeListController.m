//
//  InviteCodeListController.m
//  BarrageClient
//
//  Created by pipi on 15/1/10.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//
//  added by Shaowu Cai on 15/1/25

#import "InviteCodeListController.h"
#import "AvailableInviteCodeCell.h"
#import "MKBlockActionSheet.h"
#import "UserService.h"
#import "InviteCodeManager.h"
#import "AddressBookUtils.h"
#import "Masonry.h"
#import "UIViewUtils.h"
#import "UsedCodeCell.h"
#import "UILabel+Touchable.h"
#import "FontInfo.h"
#import "ViewInfo.h"
#import "AppDelegate.h"
#import "BarrageConfigManager.h"

#define kUsedInviteCodeCell         @"kUsedInviteCodeCell"
#define kAvailableInviteCodeCell    @"AvailableInviteCodeCell"

#define kHeightForHeaderView 48
#define kHeightForFooterView 48*2

const int kAvailableInviteCodeCount = 5;

@interface InviteCodeListController ()

@property (nonatomic,strong)NSString *phoneNum;                        // 当前选中的用户号码
@property (nonatomic,strong)NSString *phoneName;                       // 当前选中的用户名称
@property (nonatomic,assign)int indexOfSection;
@property (nonatomic,assign)int sectionAvailableInviteCode;
@property (nonatomic,assign)int sectionUsedInviteCode;
@property (nonatomic,strong)UIAlertView *alert;
@property (nonatomic,strong)PBInviteCode* selectedCode;                // 当前选中的邀请码

@end

@implementation InviteCodeListController

#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self loadView];
}
- (void)loadView
{
    [super loadView];
    [self.tableView registerClass:[AvailableInviteCodeCell class] forCellReuseIdentifier:kAvailableInviteCodeCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:BARRAGE_BG_COLOR];
    self.tableView.allowsSelection = NO;
    self.navigationItem.title = @"邀请好友";
}
#pragma mark - Private methods
- (void)loadData
{
    self.sectionAvailableInviteCode = self.indexOfSection++;
    self.sectionUsedInviteCode = self.indexOfSection++;
}

//  加载有效邀请码
//- (void)loadAvailableCodes
//{
//    [[UserService sharedInstance] getUserInviteCodeList:^(PBUserInviteCodeList *userInviteCodeList, NSError *error) {
//        if (error == nil){
//            // success, update table view
//            [self.tableView reloadData];
//        }
//    }];
//}

- (BOOL)canApplyInviteCode
{
    NSUInteger count = [[InviteCodeManager sharedInstance] getUserInviteCodeList].availableCodes.count;
    if (count == 0) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PBUserInviteCodeList* list = [[InviteCodeManager sharedInstance] getUserInviteCodeList];
    NSInteger availableInviteCodeCount = list.availableCodes.count;
    NSInteger useInviteCodeCount = list.sentCodes.count;
    return section == self.sectionAvailableInviteCode ? availableInviteCodeCount : useInviteCodeCount;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == self.sectionAvailableInviteCode) {
        AvailableInviteCodeCell *availableInviteCodeCell = [tableView dequeueReusableCellWithIdentifier:kAvailableInviteCodeCell
                                                                                           forIndexPath:indexPath];
        PBInviteCode *inviteCode = [self getAvailableInviteCode:indexPath.row];
        NSString *inviteCodeStr;
        if (inviteCode.status == PBInviteCodeStatusCodeStatusUsed) {
            inviteCodeStr = [NSString stringWithFormat:@"%@ (已使用)",inviteCode.code];
            availableInviteCodeCell.textLabel.textColor = BARRAGE_LABEL_GRAY_COLOR;
        }else{
            inviteCodeStr = inviteCode.code;
        }
        availableInviteCodeCell.textLabel.text = inviteCodeStr;
        
        availableInviteCodeCell.clickAddActionBlock = ^(NSIndexPath* indexPath){
            self.selectedCode = [self getAvailableInviteCode:indexPath.row];
            [self execute:nil];
        };
        cell = availableInviteCodeCell;
    }
    else if(indexPath.section == self.sectionUsedInviteCode){
        PBInviteCode* code = [self getUsedInviteCode:indexPath.row];
        NSString *sentCode = code.code;
        NSString *sendToString = code.sendTo;
        /*
         *因为UsedCodeCell本身是对UITableViewCellStyleValue1这种类型的Cell进行修改，如果registerClass的话，
         *产生cell的时候是不会用initWithStyle:reuseIdentifier:text:detailText这个方法的，所以。。。
         */
        cell = [tableView dequeueReusableCellWithIdentifier:kUsedInviteCodeCell];
        
        if (cell == nil) {
            cell = [[UsedCodeCell alloc]initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:kUsedInviteCodeCell
                                                 text:sentCode
                                           detailText:sendToString];
        }
        
        ((UsedCodeCell*)cell).indexPath = indexPath;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AVAILABLE_CODE_LIST_ROW_HEIHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeightForHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _sectionAvailableInviteCode) {
        if ([self canApplyInviteCode]){
            return kHeightForFooterView;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == _sectionAvailableInviteCode) {
        if ([self canApplyInviteCode] == NO){
            return nil;
        }
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kHeightForFooterView)];
        label.text = @"申请邀请码给好友";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = BARRAGE_LABEL_COLOR;
        label.font = BARRAGE_LABEL_FONT;
        [label enableTapTouch:self selector:@selector(applyCode:)];
        return label;
    }
    else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == _sectionAvailableInviteCode) {
        //add by neng, Analyze
        UIView *view;
        view = [self createHeaderViewWithTitle:@"可用邀请码"
                                     tableView:tableView];
        return view;
    }else{
        //add by neng, Analyze
        UIView *view;
        view = [self createHeaderViewWithTitle:@"已发放邀请码"
                                     tableView:tableView];
        return view;
    }
}

#pragma mark - Utils
//  创建headerView
- (UIView*)createHeaderViewWithTitle:(NSString*)title
                           tableView:(UITableView *)tableView
{
    CGRect viewFrame = CGRectMake(0, 0, tableView.frame.size.width, kHeightForHeaderView);  //  若用AutoLayout在ios7.1会crash
    UIView *view = [[UIView alloc]initWithFrame:viewFrame];
    view.backgroundColor = BARRAGE_BG_COLOR;

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pre_image.png"]];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(+18);
        make.centerY.equalTo(view);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = BARRAGE_TEXTFIELD_COLOR;
    label.font = BARRAGE_LITTLE_LABEL_FONT;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView).with.offset(+8);
        make.centerY.equalTo(view);
    }];
    return view;
}

- (PBInviteCode*)getAvailableInviteCode:(NSUInteger)index
{
    PBUserInviteCodeList* inviteCodeList = [[InviteCodeManager sharedInstance] getUserInviteCodeList];
    if (index < inviteCodeList.availableCodes.count){
        return [inviteCodeList.availableCodes objectAtIndex:index];
    }
    else{
        return nil;
    }
}

- (PBInviteCode*)getUsedInviteCode:(NSUInteger)index
{
    PBUserInviteCodeList* inviteCodeList = [[InviteCodeManager sharedInstance] getUserInviteCodeList];
    if (index < inviteCodeList.sentCodes.count){
        return [inviteCodeList.sentCodes objectAtIndex:index];
    }
    else{
        return nil;
    }
}

//  创建actionSheet
- (void)execute:(NSNotification *)notification {
    NSString *qqInvite = @"邀请QQ好友";
    NSString *share = @"分享到朋友圈";
    NSString *weixinInvite = @"邀请微信好友";
    NSString *snsInvite = @"短信邀请";
    MKBlockActionSheet *actionSheet = [[MKBlockActionSheet alloc]
                                       initWithTitle:@"邀请好友"delegate:nil
                                       cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                       otherButtonTitles:qqInvite,weixinInvite,share,snsInvite, nil];
    
    __weak typeof (actionSheet) as = actionSheet;
    [actionSheet setActionBlock:^(NSInteger buttonIndex){
        NSString *title = [as buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:snsInvite]) {
            ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
            picker.peoplePickerDelegate = self;
            
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (NSString*)createSendInfoForPhone
{
    NSString* retStr = @"";
    if ([self.phoneName length] > 0){
        retStr = [retStr stringByAppendingString:self.phoneName];
        
        if ([self.phoneName length] > 0){
            retStr = [retStr stringByAppendingFormat:@" (%@)", self.phoneNum];
        }
    }
    else{
        if ([self.phoneName length] > 0){
            retStr = [retStr stringByAppendingFormat:@"%@", self.phoneNum];
        }
    }
    
    return retStr;
}

//  展示发送短信的页面
-(void)showMessageView
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.messageComposeDelegate = self;
        controller.title = @"邀请好友";
        controller.body = [NSString stringWithFormat:@"BBJ邀请码：%@ \n应用下载连接：%@",self.selectedCode,DEFAULT_DOWNLOAD_URL];
        controller.recipients = @[self.phoneNum];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        self.alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                message:@"该设备不支持短信功能"
                                               delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil, nil];
        [_alert show];
    }
}

- (void)distributionInviteCode:(NSString*)info
{
    PBInviteCode* selectedCode = self.selectedCode;
    [[UserService sharedInstance] distributeInviteCode:selectedCode sendTo:info callback:^(PBUserInviteCodeList *userInviteCodeList, NSError *error) {
        if (error == nil){
            [self.tableView reloadData];
        }
    }];
}

- (void)applyCode:(id)sender
{
    [[UserService sharedInstance] applyInviteCode:kAvailableInviteCodeCount callback:^(PBUserInviteCodeList *userInviteCodeList, NSError *error) {
        if (error == nil){
            [self.tableView reloadData];
            
        }
    }];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
//  选择了通讯录中某一行执行
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person
{
    if (person == NULL){
        return;
    }
    
    self.phoneName = [AddressBookUtils getFullName:person];
    NSArray* phones = [AddressBookUtils getPhones:person];
    if ([phones count] == 0){
        return;
    }else if ([phones count] == 1){
        self.phoneNum = [phones objectAtIndex:0];
        [self showMessageView];
        
    }else{

        MKBlockActionSheet *actionSheet = [[MKBlockActionSheet alloc]
                                           initWithTitle:@"手机号码"delegate:nil
                                           cancelButtonTitle:nil
                                           destructiveButtonTitle:nil
                                           otherButtonTitles:nil];
        for (NSString* phoneNum in phones) {
            [actionSheet addButtonWithTitle:phoneNum];
        }
        [actionSheet addButtonWithTitle:@"取消"];
        [actionSheet setCancelButtonIndex:phones.count];
        __weak typeof (actionSheet) as = actionSheet;

        [actionSheet setActionBlock:^(NSInteger buttonIndex){
            NSString *title = [as buttonTitleAtIndex:buttonIndex];
            self.phoneNum = title;
            
            // just for test
#pragma warning test distribute invite code, should be remove
            NSString* info = [self createSendInfoForPhone];
            [self distributionInviteCode:info];

#pragma warning should be called
            [self showMessageView];
            //  if showMessageView was called above,the following may be hidden.
            UIViewController *currentViewController = [[AppDelegate sharedInstance]currentViewController];
            [currentViewController dismissViewControllerAnimated:YES completion:nil];
        }];
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    
}
#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self peoplePickerNavigationController:peoplePicker didSelectPerson: person];
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    UIViewController *currentViewController = [[AppDelegate sharedInstance]currentViewController];
    [currentViewController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - MFMessageComposeViewControllerDelegate
//  短信发送反馈
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            PPDebug(@"SNS of invite code is Cancelled");
            break;
        case MessageComposeResultFailed:
            self.alert = [[UIAlertView alloc] initWithTitle:@"短信发送情况"
                                                    message:@"短信发送失败"
                                                   delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil, nil];
            [_alert show];
            break;
        case MessageComposeResultSent:
        {
            PPDebug(@"SNS of invite code is Sended");
            // use invite code locally
            NSString* info = [self createSendInfoForPhone];
            [self distributionInviteCode:info];
        }
            break;
        default:
            break;
    }
}
@end
