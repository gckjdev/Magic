//
//  AboutController.m
//  BarrageClient
//
//  Created by gckj on 15/2/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "AboutController.h"
#import "Masonry.h"
#import "UIViewUtils.h"
#import "UIUtils.h"
#import "BarrageConfigManager.h"
#import "ViewInfo.h"

@interface AboutController ()
//  分成2个页面
@property (nonatomic,strong)UIView *viewOne;
@property (nonatomic,strong)UIView *viewTwo;

@end

@implementation AboutController

#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadView{
    [super loadView];
    [self loadViewOne];
    [self loadViewTwo];
}
#pragma mark - Private methods
//  加载ViewOne
-(void)loadViewOne{
    self.viewOne = [[UIView alloc]init];
    [self.view addSubview:self.viewOne];
    [self.viewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).with.dividedBy(2);
    }];
    [self loadSubviewOneInViewOne];
}
//  加载subviewOne
-(void)loadSubviewOneInViewOne
{
    UIView *subviewOneInViewOne = [[UIView alloc]init];
    [self.viewOne addSubview:subviewOneInViewOne];
    [subviewOneInViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.viewOne);
    }];
    
    UIImage *image = [UIImage imageNamed:@"Logo_Launch_Screen"];
    UIImageView *logoImageView = [[UIImageView alloc]initWithImage:image];
    [subviewOneInViewOne addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subviewOneInViewOne);
        make.centerX.equalTo(subviewOneInViewOne);
        make.width.equalTo(@(ABOUT_LOGO_WIDTH_HEIGHT));
        make.height.equalTo(@(ABOUT_LOGO_WIDTH_HEIGHT));
    }];
    
    NSString *currentVersion = [NSString stringWithFormat:@"当前版本为 %@",[UIUtils getAppVersion]];
    UILabel *currentVersionLabel = [[UILabel alloc]init];
    [subviewOneInViewOne addSubview:currentVersionLabel];
    [currentVersionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(subviewOneInViewOne);
        make.top.equalTo(logoImageView.mas_bottom).with.offset(+COMMON_PADDING);
    }];

    currentVersionLabel.text = currentVersion;
    currentVersionLabel.textAlignment = NSTextAlignmentCenter;
    currentVersionLabel.font = BARRAGE_LITTLE_LABEL_FONT;
}

//  加载ViewTwo
-(void)loadViewTwo{
    self.viewTwo = [[UIView alloc]init];
    [self.view addSubview:self.viewTwo];
    [self.viewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).with.dividedBy(2);
    }];
    [self loadCheckForUpdateBtn];
    [self loadHelpEmailBtn];
}
//  加载检查更新按钮
- (void)loadCheckForUpdateBtn
{
    NSString *titlestr = @"检查更新";

    UIButton *button = [UIButton createButton:titlestr superView:self.viewTwo];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.viewTwo).with.multipliedBy(0.25); //  在1/4的地方
        make.width.equalTo(self.viewTwo).with.offset(-(COMMON_BUTTON_MARGING*6));  //  乘以6只是为了让宽度变小
    }];
}
//  加载帮助邮箱按钮
- (void)loadHelpEmailBtn
{
    NSString *titlestr = CONTACT_EMAIL;
    UIButton *button = [UIButton createButton:titlestr superView:_viewTwo];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_viewTwo).with.multipliedBy(0.75); //  在3/4的地方
        make.width.equalTo(_viewTwo).with.offset(-(COMMON_BUTTON_MARGING*6));  //  乘以6只是为了让宽度变小
    }];
}
@end
