//
//  CommentFeedController.m
//  BarrageClient
//
//  Created by pipi on 14/12/5.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "CommentFeedController.h"
#import "ToolTabView.h"
#import "TextToolView.h"
#import "CommentEditView.h"
#import "BarrageTextView.h"
#import "Masonry.h"
#import "FeedManager.h"
#import "UIViewUtils.h"
#import "FeedBarrageView.h"
#import "PopupTextView.h"
#import "FeedService.h"
#import "UserManager.h"
#import "FeedBarrageView.h"
#
#import "UIViewController+Utils.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "UILineGridsView.h"
#import "UserTimelineFeedController.h"
#import "UIImageUtil.h"
#import "CommentToolView.h"
#import "ViewInfo.h"
#import "DeviceDetection.h"

#define DEFAULT_BARRAGE_POS_X   0.0f
#define DEFAULT_BARRAGE_POS_Y   0.0f
#define DEFAULT_TEXT            @""

#define COMMENTFEEDCONTROLLER_COMMENTEDITVIEW_TOP       31.0f

#define COMMENTFEEDCONTROLLER_COMMENTTOOLVIEW_HIEGHT    44.0f

@interface CommentFeedController ()

@property (nonatomic, strong) CommentEditView* editView;
@property (nonatomic, strong) UIViewController* fromController;
@property (nonatomic, strong) Feed* feed;
@property (nonatomic, strong) PBFeedActionBuilder* pbActionBuilder;
@property (nonatomic, strong) ToolTabView* toolTabView;
@property (nonatomic, strong) TextToolView* textToolView;
@property (nonatomic, strong) CommentToolView* commentToolView;
@property (nonatomic,strong) UIView   *holderView;
@property (nonatomic,assign) CGPoint posPoint;
@property (nonatomic, assign) CGFloat   offsetHeight;
@end

@implementation CommentFeedController

+ (CommentFeedController*)showFromController:(UIViewController*)fromController
                                    withFeed:(Feed*)feed
                                    startPos:(CGPoint)point
{
    
    if (fromController == nil || feed == nil){
        PPDebug(@"try to show comment edit view but feed is nil!!!");
        return nil;
    }
    
    
    CommentFeedController* vc = [[CommentFeedController alloc] init];
    vc.feed = feed;
    vc.fromController = fromController;
    vc.posPoint = point;
    [vc initActionBuilder];
    
    
    [fromController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"弹幕评论";

    
    [self initView];
    
    [self initNotification];
}
-(void)initNotification
{
    //注册通知,监听键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    PPDebug(@"neng : dealloc");
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    [self hideTabBar];
    
    [self setBlackNavigationBar];
    

}
//监听事件
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification
{
    //获取键盘高度
    
    NSDictionary* info = [paramNotification userInfo];

    CGSize keyboard = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    [self setHolderViewUp:keyboard];


}
- (void)handleKeyboardDidHidden
{
    [self setHolderViewDown];
}

-(void)setHolderViewUp:(CGSize)keyboard
{
    CGPoint cursorPos = [self getCursorPos];
    CGFloat screenHeight = kScreenHeight;
    
    CGFloat upY =  (screenHeight - keyboard.height) - (cursorPos.y+ 120);
    //    PPDebug(@"neng height %f cursorY %f  all %f  k %f",kbSize.height,tmp.y,upY,screenHeight);
    
    if(upY < 0)
    {
        [self moveEditViewPosY:upY ];
        _offsetHeight = upY;
    }
    else
    {
        _offsetHeight = 0;
    }
    //    PPDebug(@"neng offset %f",upY);
}
-(void)setHolderViewDown{
   
    [self moveEditViewPosY:-_offsetHeight];
    
}


-(void)viewDidDisappear:(BOOL)animated
{
   
    [super viewDidDisappear:animated];
    
    [self setRedNavigationBar];
    
    
}


#define EDIT_VIEW_OFFSET        0

- (void)initActionBuilder
{
    PBUser* user = [[UserManager sharedInstance] miniPbUser];
    self.pbActionBuilder = [PBFeedAction builder];
    [self.pbActionBuilder setText:DEFAULT_TEXT];
    [self.pbActionBuilder setFeedId:self.feed.feedId];
    [self.pbActionBuilder setActionId:@""];
    [self.pbActionBuilder setUser:user];
    [self.pbActionBuilder setAvatar:user.avatar];
    [self.pbActionBuilder setPosX:self.posPoint.x];
    [self.pbActionBuilder setPosY:self.posPoint.y];
    
}

- (void)initView
{
    

    [self.view setBackgroundColor:NAVIGATIONBAR_BLACK];
    
    [self.pbActionBuilder setText:DEFAULT_TEXT];
 
    
    [self initNavBar];
    
    [self initEidtView];
    [self.editView updateView:self.feed feedAction:self.pbActionBuilder];
    
    if (!ISIPHONE4) {
        [self initCommentToolTabView];
    }
    else{
        [self initCommentToolTabView_IPHONE4];
    }
    
    if (!ISIPHONE4){
        [self initTextToolView];
    }else{
        [self initTextToolView_IPHONE4];
    }
    
    
    if (!ISIPHONE4) {
        [self initToolTabView];
    }
    
    
}
-(void)initEidtView
{
    __weak typeof(self) weakSelf = self;
    
    CGFloat y = 0; //kNavigationBarHeight + kStatusBarHeight + EDIT_VIEW_OFFSET;
    CGFloat x = EDIT_VIEW_OFFSET;
    CGFloat width = kScreenWidth - EDIT_VIEW_OFFSET*2;
    UIView* holderView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, BARRAGE_HEIGHT(width))];
    
    _holderView = holderView;
    // add edit view into holder view
    self.editView = [CommentEditView editViewWithFeed:_feed barragePos:_posPoint];
    
    [holderView addSubview:self.editView];
    
    
    // init edit view scale
    CGFloat scale = [self.editView scaleInView:holderView];
    [self.editView setScale:scale];
    [self.editView setMinScale:scale];
    self.editView.textInputView.keyboardFinishBlock = ^(){
        [weakSelf clickSubmitButton];
    };
    
    
    [self.view addSubview:holderView];
}
-(void)initNavBar{
    // init navigation bar button
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"发表"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(clickSubmitButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
}
-(void)initCommentToolTabView
{
     __weak typeof(self) weakSelf = self;
 
//    CGFloat width = kScreenWidth - EDIT_VIEW_OFFSET*2;
    CGFloat commtentToolViewOffsetY = kScreenHeight- kNavigationBarHeight - kStatusBarHeight - TOOLTABVIEW_HEIGHT - COMMENTFEEDCONTROLLER_COMMENTTOOLVIEW_HIEGHT - TEXTTOOLVIEW_HEIGHT;
    
    self.commentToolView = [[CommentToolView alloc]initWithFrame:CGRectMake(0, commtentToolViewOffsetY, kScreenWidth, COMMENTFEEDCONTROLLER_COMMENTTOOLVIEW_HIEGHT)];
    [self.commentToolView setBackgroundColor:NAVIGATIONBAR_BLACK];
    
    self.commentToolView.gridsButtonChangeBlock = ^(){
        weakSelf.editView.hasGridsView =    !weakSelf.editView.hasGridsView;
    };
    self.commentToolView.preViewButtonChangeBlock = ^(){
        weakSelf.editView.hasBarrageViews =  !weakSelf.editView.hasBarrageViews;
    };
    
    [self.view addSubview:self.commentToolView];

}

-(void)initCommentToolTabView_IPHONE4
{
    __weak typeof(self) weakSelf = self;

    //    CGFloat width = kScreenWidth - EDIT_VIEW_OFFSET*2;
    CGFloat commtentToolViewOffsetY = kScreenHeight- kNavigationBarHeight - kStatusBarHeight - COMMENTFEEDCONTROLLER_COMMENTTOOLVIEW_HIEGHT - TEXTTOOLVIEW_HEIGHT;
    
    self.commentToolView = [[CommentToolView alloc]initWithFrame:CGRectMake(0, commtentToolViewOffsetY, kScreenWidth, COMMENTFEEDCONTROLLER_COMMENTTOOLVIEW_HIEGHT)];
    [self.commentToolView setBackgroundColor:NAVIGATIONBAR_BLACK];
    
    self.commentToolView.gridsButtonChangeBlock = ^(){
        weakSelf.editView.hasGridsView =    !weakSelf.editView.hasGridsView;
    };
    self.commentToolView.preViewButtonChangeBlock = ^(){
        weakSelf.editView.hasBarrageViews =  !weakSelf.editView.hasBarrageViews;
    };
    
    [self.view addSubview:self.commentToolView];
  
}
-(void)initToolTabView
{
  
    CGFloat toolTabViewOffsetY = kScreenHeight- kNavigationBarHeight - kStatusBarHeight - TOOLTABVIEW_HEIGHT;
    self.toolTabView = [[ToolTabView alloc]initWithFrame:CGRectMake(0,toolTabViewOffsetY , kScreenWidth, TOOLTABVIEW_HEIGHT)];
    [self.view addSubview:self.toolTabView];
    
   
}
-(void)initTextToolView_IPHONE4{
    CGFloat toolTabViewOffsetY = kScreenHeight-TOOLTABVIEW_HEIGHT- kNavigationBarHeight - kStatusBarHeight;
    
    self.toolTabView = [[ToolTabView alloc]initWithFrame:CGRectMake(0,toolTabViewOffsetY , kScreenWidth, TOOLTABVIEW_HEIGHT)];
    [self.view addSubview:self.toolTabView];
}
-(void)initTextToolView
{

    __weak typeof(self) weakSelf = self;
    
    CGFloat toolTabViewOffsetY = kScreenHeight- kNavigationBarHeight - kStatusBarHeight - TOOLTABVIEW_HEIGHT;
    
    CGFloat textToolViewOffsetY = toolTabViewOffsetY - TEXTTOOLVIEW_HEIGHT;
    self.textToolView = [[TextToolView alloc]initWithFrame:CGRectMake(0, textToolViewOffsetY, kScreenWidth, TEXTTOOLVIEW_HEIGHT)];
    
    self.textToolView.colorChangeBlock = ^(UIColor* color){
        [weakSelf.editView.textInputView setTextColor:color];
    };
    self.textToolView.switchChangeBlock = ^(){

        PBFeedAction *action = [weakSelf.editView.textInputView getBarrageData];
        BOOL HasBg = !action.hasBg;
        [weakSelf.editView.textInputView setBackgroundColorTrans:HasBg animation:YES];
        if(!HasBg){
            POSTMSG2(@"弹幕评论背景已打开",1.0f);
        }
        else{
            POSTMSG2(@"弹幕评论背景已隐藏",1.0f);
        }
        
    };
    [self.view addSubview:self.textToolView];
    
}
- (CGPoint)getCursorPos{
    CGPoint tmpPoint = self.editView.textInputView.frame.origin;
    tmpPoint.x *= self.editView.scale;
    tmpPoint.y *= self.editView.scale;
    tmpPoint.y += COMMENTFEEDCONTROLLER_COMMENTEDITVIEW_TOP;
//    PPDebug(@"neng : scale %f",self.editView.scale);
    return tmpPoint;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickSubmitButton
{
    [self.editView resignKeyboard];

    PBFeedAction* feedAction = [_editView.textInputView getBarrageData];

    SHOW_LOADING(@"弹幕评论提交中...", self.view);
    [[FeedService sharedInstance] replyFeed:self.feed
                                 feedAction:feedAction
                                   callback:
     ^(NSString *feedActionId, NSError *error) {

         HIDE_LOADING(self.view);
        if (error == nil){

            POST_SUCCESS_MSG(@"弹幕评论已发表");
            
            // post notification to UserTimelineController
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIMELINE_RELOAD_VISIABLE_ROWS
                                                                object:nil];

            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            PPDebug(@"<replyFeed> error=%@", error);
            POST_ERROR(@"弹幕评论失败，请稍后再试");
        }
            
    }];
    
   
}


-(void)moveEditViewPosY:(CGFloat)posY
{
    [UIView setAnimationDuration:BARRAGETEXTVIEW_ANIMATION_DURATION];
    CGRect frame = self.holderView.frame;
    frame.origin.y += posY;
    self.holderView.frame = frame;
    [UIView commitAnimations];
}
@end
