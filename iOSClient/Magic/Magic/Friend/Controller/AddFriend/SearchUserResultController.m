//
//  SearchUserResultController.m
//  BarrageClient
//
//  Created by pipi on 14/12/26.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

//

#import "SearchUserResultController.h"
#import <Masonry.h>
#import "UserService.h"
#import "UIViewUtils.h"
#import "UIImageView+WebCache.h"
#import "FriendService.h"
#import "FriendDetailController.h"
#import "UIViewController+Utils.h"
#import "FriendListTableView.h"


#define SEARCH_LOGO_HEIGHT 20


@interface SearchUserResultController ()<FriendListActionDelegate,UITextFieldDelegate>
{
    
}

//view
@property (nonatomic,strong) UIView* searchHolderView;
@property (nonatomic,strong) UITextField* searchTextField;
@property (nonatomic,strong) FriendListTableView* resultFriendListTableView;
@property (nonatomic,strong) UILabel* resultNoUserLabel;

@end

@implementation SearchUserResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // navigation items and general background
    [self setTitle:@"搜索"];
    [self.view setBackgroundColor:BARRAGE_BG_COLOR];
    [self addRightButtonWithTitle:@"提交" target:self action:@selector(clickSubmit:)];
    
    //search input view
    [self addSearchTextView];
    
    //results
    [self addResultFriendListTableView];
    [self addNoUserResult];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --- text field view in the upper part, for search texting
- (void)addSearchTextView
{
    self.searchHolderView = [self createButtonHolderViewWithImageName:@"addfriend_search.png" andText:@"昵称/弹幕号／手机号／QQ号"];
    [self.searchHolderView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.searchHolderView];
    [self.searchHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(COMMON_PADDING);
        make.height.equalTo(@(COMMON_TEXTFIELD_HEIGHT));
    }];
}

- (UIButton*)createButtonHolderViewWithImageName:(NSString*)imageName
                                         andText:(NSString*)labelText
{
    UIButton *holderView = [[UIButton alloc]init];
    
    UIImageView *image = [[UIImageView alloc]init];
    [image setImage:[UIImage imageNamed:imageName]];
    [image setUserInteractionEnabled:NO];
    [holderView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(holderView.mas_left).with.offset(COMMON_PADDING);
        make.centerY.equalTo(holderView.mas_centerY);
        make.height.equalTo(@SEARCH_LOGO_HEIGHT);
        make.width.equalTo(@SEARCH_LOGO_HEIGHT);
    }];
    
    
    self.searchTextField = [[UITextField alloc]init];
    [self.searchTextField becomeFirstResponder];
    [self.searchTextField setDelegate:self];
    [self.searchTextField setBackgroundColor:[UIColor whiteColor]];
    [self.searchTextField setPlaceholder:@"昵称/弹幕号／手机号／QQ号"];
    [self.searchTextField setTextAlignment:NSTextAlignmentLeft];
    [self.searchTextField setTextColor:BARRAGE_LABEL_GRAY_COLOR];
    [self.searchTextField setFont:BARRAGE_TEXTFIELD_FONT];//字体大小
    [self.searchTextField setReturnKeyType:UIReturnKeySearch];
    [self.searchTextField setKeyboardType:UIKeyboardTypeDefault];
    [holderView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(holderView.mas_top);
        make.bottom.equalTo(holderView.mas_bottom);
        make.left.equalTo(image.mas_right).with.offset(COMMON_PADDING);
    }];
    
    [holderView setUserInteractionEnabled:YES];
    return holderView;
}


#pragma mark --- table view in the lower part, for search results
- (void)addResultFriendListTableView
{
    self.resultFriendListTableView = [[FriendListTableView alloc]init];
    self.resultFriendListTableView.actionDelegate = self;
    [self.view addSubview:self.resultFriendListTableView];
    [self.resultFriendListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.searchHolderView.mas_bottom).with.offset(COMMON_PADDING);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.resultFriendListTableView.hidden = YES;
}

- (void)addNoUserResult
{
    self.resultNoUserLabel = [UIView defaultLabel:nil superView:self.view];
    self.resultNoUserLabel.backgroundColor = [UIColor clearColor];
    [self.resultNoUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    self.resultNoUserLabel.hidden = YES;
    
}

- (void)clickOnItem:(PBUser *)user
{
    FriendDetailController *vc = [[FriendDetailController alloc]initWithUser:user];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --- textfield delegate and procession
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clickSubmit:nil];
    return YES;
}

- (void)clickSubmit:(id)sender
{
    UITextField* textField = self.searchTextField;
    [[UserService sharedInstance] searchUser:textField.text offset:0 limit:20 callback:^(NSArray *pbUserList, NSError *error) {
        
        if (error == nil){
    
            NSSet *userSet = [NSSet setWithArray:pbUserList];
            NSMutableArray* userArray = [[NSMutableArray alloc]init];
            
            for(PBUser* user in userSet){
                [userArray addObject:user];
            }

            [self processSearchWithContent:self.searchTextField.text
                                 andResult:userArray];
            
            [self.searchTextField resignFirstResponder];
        }
    }];
}

- (void)processSearchWithContent:(NSString*)content
                       andResult:(NSArray*)userArray
{
    if([userArray count]==0)
    {
        self.resultFriendListTableView.hidden = YES;
        self.resultNoUserLabel.hidden = NO;
        
        NSString* str = [NSString stringWithFormat:@"没有找到  %@  相关结果",content];
        self.resultNoUserLabel.text = str;
    }
    else
    {
        self.resultFriendListTableView.hidden = NO;
        self.resultNoUserLabel.hidden = YES;
        
        self.resultFriendListTableView.pbFriendList = userArray;
        [self.resultFriendListTableView updateTableView];
    }
}



@end
