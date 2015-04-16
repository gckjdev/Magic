//
//  SearchUserController.m
//  BarrageClient
//
//  Created by pipi on 14/12/26.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

//added by charlie 2015 1 27
//added by 蔡少武 on 15/03/01

#import "SearchUserController.h"
#import "SearchUserResultController.h"
#import "UIViewController+Utils.h"
#import <Masonry.h>
#import "UIViewUtils.h"

#import "UILineLabel.h"
#import "InviteCodeListController.h"

#define SEARCH_LOGO_HEIGHT 20
#define LARGE_PADDING 82

@interface SearchUserController ()
{
    
}

@property (nonatomic,strong) UIButton* searchHolderView;
@property (nonatomic,strong) UILabel* tipLabel;
@property (nonatomic,strong) UIButton* code2dHolderView;
@property (nonatomic,strong) UIButton* interactionHolderView;
@property (nonatomic,strong) UIButton* qqHolderView;

@property (nonatomic,strong) UILineLabel *inviteFriendLabel;
@end

@implementation SearchUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"添加好友"];
    [self.view setBackgroundColor:BARRAGE_BG_COLOR];
    [self addSearchButton];
    
    [self addInviteFriendLabel];
    
//    [self addTipLabel];
//    [self addVia2dCode];
//    [self addViaInteraction];
//    [self addViaQQ];
}
//  加载页面基本设置
-(void)loadView
{
    [super loadView];
//    [self setupNavBackButton];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    UILabel *text = [[UILabel alloc]init];
    [text setText:labelText];
    [text setTextColor:BARRAGE_LABEL_GRAY_COLOR];
    [text setFont:BARRAGE_TEXTFIELD_FONT];
    [text setUserInteractionEnabled:NO];
    [holderView addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image.mas_right).with.offset(COMMON_PADDING);
        make.right.equalTo(holderView.mas_right);
        make.centerY.equalTo(holderView.mas_centerY);
    }];
    
    [holderView setUserInteractionEnabled:YES];
    return holderView;
}

- (void)addSearchButton
{
    self.searchHolderView = [self createButtonHolderViewWithImageName:@"addfriend_search.png" andText:@"昵称/邮箱/手机号/微博"];
    [self.searchHolderView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.searchHolderView];
    [self.searchHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(COMMON_MARGIN_OFFSET_Y);
        make.height.equalTo(@(COMMON_TEXTFIELD_HEIGHT));
    }];
    
    [self.searchHolderView addTarget:self action:@selector(onSearch:) forControlEvents:UIControlEventTouchUpInside];
}

//  added by 蔡少武,modified by charlie again
-(void)addInviteFriendLabel
{
    NSString* str = @"邀请好友一起玩";
    self.inviteFriendLabel = [UILineLabel initWithText:str Font:BARRAGE_LITTLE_LABEL_FONT
                              Color:BARRAGE_LABEL_COLOR
                            Type:UILINELABELTYPE_DOWN
                              ];
   
    [self.view addSubview:self.inviteFriendLabel];
    [self.inviteFriendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.searchHolderView.mas_bottom).with.offset(+COMMON_PADDING);
        make.height.equalTo(@COMMON_LINE_LABEL_HEIGHT);
        
    }];
    //  设置inviteFriendLabel接受事件
    self.inviteFriendLabel.userInteractionEnabled = YES;
    //  初始化一个手势
    [self.inviteFriendLabel addTapGestureWithTarget:self selector:@selector(clickInviteFriendLabel:)];
}

- (void)clickInviteFriendLabel:(id)sender
{
    InviteCodeListController *vc = [[InviteCodeListController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addTipLabel
{
    self.tipLabel = [[UILabel alloc]init];
    NSString *userName = @"something";
    NSString *text = [NSString stringWithFormat:@"我的弹幕号:%@",userName];
    [self.tipLabel setText:text];
    [self.tipLabel setFont:BARRAGE_LITTLE_LABEL_FONT];
    [self.tipLabel setTextColor:BARRAGE_TEXTFIELD_COLOR];
    [self.tipLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.searchHolderView.mas_bottom).with.offset(COMMON_PADDING);
    }];
}

- (void)addVia2dCode
{
    self.code2dHolderView = [self createButtonHolderViewWithImageName:@"addfriend_2dcode.png" andText:@"扫一扫（扫描二维码名片）"];
    
    [self.view addSubview:self.code2dHolderView];
    [self.code2dHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(COMMON_PADDING+COMMON_TEXTFIELD_HEIGHT+LARGE_PADDING);
        make.height.equalTo(@(COMMON_TEXTFIELD_HEIGHT));
    }];
    
    [self.code2dHolderView addTarget:self action:@selector(on2DCode:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addViaInteraction
{
    self.interactionHolderView = [self createButtonHolderViewWithImageName:@"addfriend_maybe.png" andText:@"一起互动过可能认识的朋友"];
    
    [self.view addSubview:self.interactionHolderView];
    [self.interactionHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(COMMON_PADDING+2*COMMON_TEXTFIELD_HEIGHT+LARGE_PADDING);
        make.height.equalTo(@(COMMON_TEXTFIELD_HEIGHT));
    }];
    
    [self.interactionHolderView addTarget:self action:@selector(onInteration:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addViaQQ
{
    self.qqHolderView = [self createButtonHolderViewWithImageName:@"addfriend_qqlogo.png" andText:@"添加QQ好友"];
    
    [self.view addSubview:self.qqHolderView];
    [self.qqHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(COMMON_PADDING+3*COMMON_TEXTFIELD_HEIGHT+LARGE_PADDING);
        make.height.equalTo(@(COMMON_TEXTFIELD_HEIGHT));
    }];
    
    [self.qqHolderView addTarget:self action:@selector(onQQ:) forControlEvents:UIControlEventTouchUpInside];
}

//controller turn
- (void)onSearch:(id)sender
{
    SearchUserResultController* resultCont = [[SearchUserResultController alloc]init];
    [self.navigationController pushViewController:resultCont animated:YES];
}

- (void)on2DCode:(id)sender
{
    
}

- (void)onInteration:(id)sender
{
    
}

- (void)onQQ:(id)sender
{
    
}

@end
