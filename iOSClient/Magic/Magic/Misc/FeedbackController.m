//
//  FeedbackController.m
//  BarrageClient
//
//  Created by gckj on 15/2/4.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//
//  add by Shaowu Cai

#import "FeedbackController.h"
#import "UIViewController+Utils.h"
#import "UIViewUtils.h"
#import "ViewInfo.h"
#import "Masonry.h"
#import "PlaceholderTextView.h"
#import "BarrageConfigManager.h"
#import "UserService.h"

@interface FeedbackController ()
@property (nonatomic,strong)PlaceholderTextView *textView;
@property (nonatomic,strong)UITextField *contactInfoTextField;//联系方式
@property (nonatomic,strong)UILabel *tipsLabel;
@property (nonatomic,strong)UIView *contactInfoView;
@property (nonatomic,strong)UIView *superViewOne;   //  辅助view
@end

@implementation FeedbackController

#pragma mark - Default methods
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)loadView
{
    [super loadView];
    [self loadSuperViewOne];
}

#pragma mark - Private methods
- (void)loadSuperViewOne
{
    //  COMMON_PADDING是15，textview中的placeholderLabel距离textview顶端为8，为了美观，这个设为15-8=7
    int topPadding = 7;
    
    self.superViewOne = [[UIView alloc]init];
    [self.view addSubview:self.superViewOne];
    
    CGFloat superViewOneHeight = isIPad ? 500 : 270;
    [self.superViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(+(topPadding));
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(superViewOneHeight));
        make.width.equalTo(self.view).with.offset(-(COMMON_PADDING * 2));   //  宽度为self.view.width减去2倍边距
    }];
    [self addReleaseOnNavigationBar];
    [self loadTipsLabel];
    [self loadConnectionView];
    [self loadTextView];
}
//  添加NavigationBar右边的发布按钮
- (void)addReleaseOnNavigationBar
{
    [self addRightButtonWithTitle:@"发布" target:self action:@selector(clickReleaseBtn:)];
}
//  加载小贴士label
- (void)loadTipsLabel
{
    NSString *tipStr = [NSString stringWithFormat:@"小贴士：\n如果不能正常使用%@，请重启%@或者手机试试！",APP_DISPLAY_NAME,APP_DISPLAY_NAME];
    self.tipsLabel = [[UILabel alloc]init];
    [self.superViewOne addSubview:self.tipsLabel];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.superViewOne);
        make.bottom.equalTo(self.superViewOne);
        make.width.equalTo(self.superViewOne);
    }];
    
    self.tipsLabel.text = tipStr;
    self.tipsLabel.textColor = BARRAGE_LABEL_GRAY_COLOR;
    self.tipsLabel.font = BARRAGE_FEEDBACK_TIPS_LABEL_FONT;
    self.tipsLabel.numberOfLines = 0;
}

const CGFloat kContactLabelWidth = 100;
const CGFloat kBorderWidth = 0.5f;
//  加载联系方式那个view
-(void)loadConnectionView
{
    self.contactInfoView = [[UIView alloc]init];
    [self.view addSubview:self.contactInfoView];
    [self.contactInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.superViewOne);
        make.width.equalTo(self.superViewOne);
        make.bottom.equalTo(self.tipsLabel.mas_top).with.offset(-COMMON_PADDING);
        make.height.equalTo(@(COMMON_TEXTFIELD_HEIGHT));
    }];
    
    [UIView addTopLineWithColor:BARRAGE_LAYER_COLOR borderWidth:kBorderWidth superView:self.contactInfoView];
    [UIView addBottomLineWithColor:BARRAGE_LAYER_COLOR borderWidth:kBorderWidth superView:self.contactInfoView];
    
    NSString *labelText = @"联系方式：";
    UILabel *contactLabel = [[UILabel alloc]init];
    [self.contactInfoView addSubview:contactLabel];
    
    contactLabel.text = labelText;
    contactLabel.textColor = BARRAGE_LABEL_GRAY_COLOR;
    contactLabel.font = BARRAGE_LABEL_FONT;

    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contactInfoView);
        make.centerY.equalTo(self.contactInfoView);
        make.width.equalTo(@(kContactLabelWidth));
    }];
    
    UITextField *connectedTextField = [[UITextField alloc]init];
    self.contactInfoTextField = connectedTextField;
    [self.contactInfoView addSubview:connectedTextField];
    [connectedTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactLabel.mas_right);
        make.centerY.equalTo(self.contactInfoView);
        make.width.equalTo(self.superViewOne).with.offset(-kContactLabelWidth);
    }];
    
    connectedTextField.placeholder = @"手机或QQ（选填）";
    connectedTextField.font  = BARRAGE_TEXTFIELD_FONT;
}
//  加载TextView
- (void)loadTextView
{
    NSString *placeholderStr = @"请简要描述问题和意见，谢谢。";
    self.textView = [[PlaceholderTextView alloc]initWithPlaceholder:placeholderStr
                                                   placeholderColor:nil
                                                    placeholderFont:BARRAGE_TEXTVIEW_PLACEHOLDER_FONT];
    [self.superViewOne addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.superViewOne);
        make.width.equalTo(self.superViewOne);
        make.top.equalTo(self.superViewOne);
        make.bottom.equalTo(self.contactInfoView.mas_top);
    }];
    self.textView.font = BARRAGE_TEXTVIEW_PLACEHOLDER_FONT;
    [self.textView becomeFirstResponder];
}
#pragma mark - Utils
-(void)clickReleaseBtn:(id)sender
{
    //  TODO
//    PPDebug(@"neng : message %@ contactInfo %@",self.textView.text,self.contactInfoTextField.text);
    [[UserService sharedInstance]sendUserFeedBack:self.textView.text
                                      contactInfo:self.contactInfoTextField.text
                                         callback:^(NSError *error) {
        if (error == nil) {
            POSTMSG(@"反馈成功，谢谢的你支持!");
        }
        else{
            POSTMSG(@"反馈失败");
        }
    }];
}
@end
