//
//  ShareViewController.m
//  BarrageClient
//
//  Created by HuangCharlie on 1/15/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "ShareViewController.h"
#import <Masonry.h>
#import "ShareBarrageView.h"
#import "UIViewUtils.h"
#import "SnsService.h"
#import "UIImageUtil.h"
#import "FileUtil.h"
#import "BarrageConfigManager.h"
#import "FeedBarrageView.h"
#import "UIViewController+Utils.h"
#import "ShareToWhichFriendViewController.h"
#import "UILineLabel.h"
#import "BarrageActionManager.h"
#import "Common.pb.h"


#define SHARE_LOGO_IMAGE_SIZE 60
#define SHARE_LOGO_LABEL_SIZE 20

#define SHARE_LAYOUT_COUNT 10
#define SHARE_HINTLABEL_CENTER_OFFSET 45.0f

@interface ShareViewController ()<UIAlertViewDelegate>
{

}

@property (nonatomic,strong) ShareBarrageView* imageShareView;
@property (nonatomic,strong) UIView* buttonView;
@property (nonatomic,strong) UIView* labelView;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self setDefaultBackButton:@selector(onBack:)];
    
    [self initImageShareView];
    
    
    [self initLabelView];
    [self initContainButton];
    
    [self initNavRightButton];
}

-(void)initLabelView{
    CGFloat shareImageWidth = self.view.frame.size.width;
     CGFloat shareImageHeight = BARRAGE_HEIGHT(shareImageWidth);
    
    CGRect frame = CGRectMake(0, shareImageWidth, kScreenWidth,kScreenHeight -  SHARE_LOGO_IMAGE_SIZE-SHARE_LOGO_LABEL_SIZE-shareImageHeight- kNavigationBarHeight - kStatusBarHeight);
    
    _labelView  = [[UIView alloc]initWithFrame:frame];
//    [_labelView setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:_labelView];

    UILineLabel *linelabel = [UILineLabel initWithText:@"变换弹幕队形" Font:BARRAGE_LABEL_FONT Color:BARRAGE_LABEL_RED_COLOR Type:(UILINELABELTYPE_DOWN)];
    [_labelView addSubview:linelabel];
    
    [linelabel addTapGestureWithTarget:self selector:@selector(changeBarrageQueue)];
    
    UILabel* tipsLabel = [[UILabel alloc]init];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = BARRAGE_LABEL_GRAY_COLOR;
    tipsLabel.font = BARRAGE_LABEL_FONT;
    tipsLabel.text = @"或 移动弹幕";
    [_labelView addSubview:tipsLabel];
    
    [linelabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_labelView);
        make.centerX.equalTo(_labelView).with.offset(-SHARE_HINTLABEL_CENTER_OFFSET);
        make.height.equalTo(_labelView);

    }];
    
    
    [tipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_labelView);
        make.centerX.equalTo(_labelView).with.offset(SHARE_HINTLABEL_CENTER_OFFSET);
        make.height.equalTo(_labelView);
    }];
    

}
-(void)changeBarrageQueue
{
    static int indexNum = 1;
    NSString *num = [NSString stringWithFormat:@"layout%d",indexNum];
    NSString *path = [[NSBundle mainBundle] pathForResource:num ofType:@"dat"];
//    PPDebug(@"neng : path %@",path);
    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSArray *matrix = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    PBPointList *pointList = [PBPointList parseFromData:data];
    if (pointList == nil) {
        return;
    }
    [_imageShareView updateQueue:[self convertCGPointArray:pointList]];
    
    
    if (++indexNum>SHARE_LAYOUT_COUNT) {
        indexNum = 1;
    }
}
-(NSArray*)convertCGPointArray:(PBPointList*)pointList
{
    NSMutableArray *ponitArray = [[NSMutableArray alloc]init];
    for (int i= 0 ;i<[pointList.point count];i++) {
        
        PBPoint *pbPoint = pointList.point[i];
//        PBPoint * value = [PBPoint parseFromData:data];
        CGPoint point = [self convertCGPoint:pbPoint];
        [ponitArray addObject:[NSValue valueWithCGPoint:point]];
    }
    
    return [ponitArray copy];
}
-(CGPoint)convertCGPoint:(PBPoint*)point
{
    CGPoint myPoint = CGPointMake(point.posX, point.poxY);
    return myPoint;
}
-(void)initContainButton
{
    
    //to contain buttons
    self.buttonView = [[UIView alloc]init];
    self.buttonView.backgroundColor = [UIColor whiteColor];
    self.buttonView = [self buttonInView:self.buttonView];
    [self.view addSubview:self.buttonView];
  
    
    
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(COMMON_PADDING);
        make.right.equalTo(self.view.mas_right).with.offset(-COMMON_PADDING);
        make.height.equalTo(@(SHARE_LOGO_IMAGE_SIZE+SHARE_LOGO_LABEL_SIZE));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}
-(void)initImageShareView
{
    CGFloat shareImageWidth = self.view.frame.size.width;
    CGFloat shareImageHeight = BARRAGE_HEIGHT(shareImageWidth);
    CGRect rect = CGRectMake(0, 0, shareImageWidth, shareImageHeight);
    self.imageShareView = [ShareBarrageView shareBarrageWithFrame:rect
                                                      andImageURL:self.oringinImageURL
                                                   barrageActions:self.barrageList];
    self.imageShareView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageShareView];
}
-(void)initNavRightButton
{
    [self addRightButton:@"Grids_normal" target:self action:@selector(setLineGrids)];
}
- (void)setLineGrids
{
    [_imageShareView setLineGridsHidden:!_imageShareView.lineGridsView.hidden];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self hideTabBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    PPDebug(@"neng : Memory warning!!!");
}

- (void)onBack:(id)sender
{
    PPDebug(@"navigation go back");

    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"放弃分享？"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    [alert show];

}




-(UIView*)buttonInView:(UIView*)superView
{
    /*分享到朋友圈*/
    UIButton* toFriends = [[UIButton alloc]init];
    toFriends.tag = ShareTypeWeixiTimeline;
    UIImage* friendsLogo =[UIImage imageNamed:@"share_wechat_timeline.png"];
    [toFriends setImage:friendsLogo forState:UIControlStateNormal];
    [toFriends addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:toFriends];
   
    [toFriends mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SHARE_LOGO_IMAGE_SIZE));
        make.height.equalTo(@(SHARE_LOGO_IMAGE_SIZE));
        make.top.equalTo(superView.mas_top);
        make.centerX.equalTo(superView.mas_centerX).dividedBy(4);
    }];
    
    UILabel* toFriendsTitle = [[UILabel alloc]init];
    [toFriendsTitle setText:@"微信朋友圈"];
    [toFriendsTitle setFont:BARRAGE_IMAGEBUTTON_BENEATH_FONT];
    [toFriendsTitle setTextColor:BARRAGE_LABEL_COLOR];
    [superView addSubview:toFriendsTitle];
 
    [toFriendsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toFriends.mas_bottom);
        make.centerX.equalTo(toFriends.mas_centerX);
    }];
    
    /*分享到微信好友*/
    UIButton* toWechat = [[UIButton alloc]init];
    toWechat.tag = ShareTypeWeixiSession;
    UIImage* wechatLogo = [UIImage imageNamed:@"share_wechat_section.png"];
    [toWechat setImage:wechatLogo forState:UIControlStateNormal];
    [toWechat addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:toWechat];
    [toWechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SHARE_LOGO_IMAGE_SIZE));
        make.height.equalTo(@(SHARE_LOGO_IMAGE_SIZE));
        make.top.equalTo(superView.mas_top);
        make.centerX.equalTo(superView.mas_centerX).dividedBy(4.0/3.0);
    }];
    
    UILabel* toWechatTitle = [[UILabel alloc]init];
    [toWechatTitle setText:@"微信好友"];
    [toWechatTitle setFont:BARRAGE_IMAGEBUTTON_BENEATH_FONT];
    [toWechatTitle setTextColor:BARRAGE_LABEL_COLOR];
    [superView addSubview:toWechatTitle];
    [toWechatTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toWechat.mas_bottom);
        make.centerX.equalTo(toWechat.mas_centerX);
    }];
    
    /*分享到新浪微博*/
    UIButton* toMicroblog = [[UIButton alloc]init];
    toMicroblog.tag = ShareTypeSinaWeibo;
    UIImage* weiboLogo = [UIImage imageNamed:@"share_sina.png"];
    [toMicroblog setImage:weiboLogo forState:UIControlStateNormal];
    [toMicroblog addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:toMicroblog];
    [toMicroblog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SHARE_LOGO_IMAGE_SIZE));
        make.height.equalTo(@(SHARE_LOGO_IMAGE_SIZE));
        make.top.equalTo(superView.mas_top);
        make.centerX.equalTo(superView.mas_centerX).dividedBy(4.0/5.0);
    }];
    
    UILabel* toMicroblogTitle = [[UILabel alloc]init];
    [toMicroblogTitle setText:@"新浪微博"];
    [toMicroblogTitle setFont:BARRAGE_IMAGEBUTTON_BENEATH_FONT];
    [toMicroblogTitle setTextColor:BARRAGE_LABEL_COLOR];
    [superView addSubview:toMicroblogTitle];
    [toMicroblogTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toMicroblog.mas_bottom);
        make.centerX.equalTo(toMicroblog.mas_centerX);
    }];
    
    /*分享到QQ空间*/
    UIButton* toQQSpace = [[UIButton alloc]init];
    toQQSpace.tag = ShareTypeQQSpace;
    UIImage* qqspaceLogo = [UIImage imageNamed:@"share_qq_space.png"];
    [toQQSpace setImage:qqspaceLogo forState:UIControlStateNormal];
    [toQQSpace addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:toQQSpace];
    [toQQSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SHARE_LOGO_IMAGE_SIZE));
        make.height.equalTo(@(SHARE_LOGO_IMAGE_SIZE));
        make.top.equalTo(superView.mas_top);
        make.centerX.equalTo(superView.mas_centerX).dividedBy(4.0/7.0);
    }];
    
    UILabel* toQQSpaceTitle = [[UILabel alloc]init];
    [toQQSpaceTitle setText:@"QQ空间"];
    [toQQSpaceTitle setFont:BARRAGE_IMAGEBUTTON_BENEATH_FONT];
    [toQQSpaceTitle setTextColor:BARRAGE_LABEL_COLOR];
    [superView addSubview:toQQSpaceTitle];
    [toQQSpaceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toQQSpace.mas_bottom);
        make.centerX.equalTo(toQQSpace.mas_centerX);
    }];
  
    return superView;
}

-(void)createSharingImage:(CGFloat)scale
{
    //如果有网格必须先关掉
    BOOL tag = false;
    if(!_imageShareView.lineGridsView.hidden)
    {
        tag = true;
        [_imageShareView setLineGridsHidden:YES];
    }



    self.finalImage = [self.imageShareView createSnapShotWithScale:scale];
    
    //还原设定
    if (tag) {
        [_imageShareView setLineGridsHidden:NO];
    }
}

-(void)onShare:(id)sender
{
    //get final image and share it to somewhere else.
    //share controller finish its job
    
    ShareType shareType = (ShareType)[sender tag];
    
    CGFloat scale = 1.0f;
    if (shareType == ShareTypeQQSpace){
        // QQSpace has limitation on preview image size
        scale = 0.6f;
    }
    [self createSharingImage:scale];
    
    NSString* text = DEFAULT_SHARE_TEXT;             // TODO change to right share text
    NSString* title = DEFAULT_SHARE_TITLE;
    NSString* imagePath = [[FileUtil getAppTempDir] stringByAppendingPathComponent:@"image_share_temp.jpg"];
    [self.finalImage saveJPEGToFile:imagePath compressQuality:0.95];
    
    [[SnsService sharedInstance] publishWeibo:shareType
                                         text:text
                                imageFilePath:imagePath
                                     audioURL:nil
                                        title:title
                                       inView:self.view
                                   awardCoins:0
                               successMessage:@"图片已分享"
                               failureMessage:@"分享失败"];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}





@end
