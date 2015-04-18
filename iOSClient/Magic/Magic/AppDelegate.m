//
//  AppDelegate.m
//  BarrageClient
//
//  Created by pipi on 14/11/27.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "AppDelegate.h"
#import "BarrageNetworkRequest.h"
#import "UserService.h"
#import "UserManager.h"
#import "FeedService.h"
#import "PPDebug.h"
#import "MessageCenter.h"
#import "BarrageConfigManager.h"

#import "UserSettingController.h"
#import "UserHomeController.h"
#import "UserTimelineFeedController.h"
#import "NewFeedController.h"

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

#import "FriendListController.h"

#import "UMFeedback.h"
#import <ShareSDK/ShareSDK.h>

#import "IQKeyboardManager.h"
#import "PublishSelectView.h"
#import "Masonry.h"

#import "UIViewController+Utils.h"
#import "LoginHomeWithInviteCodeController.h"
#import "DemoViewController.h"

#import "SMSManager.h"

#import "CHAudioPlayer.h"

#define UMENG_APP_KEY   @"5493c5ccfd98c57620000cf4"


@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController* loginNavigationController;

@end

@implementation AppDelegate

#pragma mark - Application Start/Stop Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UMFeedback setAppkey:UMENG_APP_KEY];
    [MiPushSDK registerMiPush:self];
    
    [self setupMobClick];
    [self setupKeyboard];
    [self setupShareSDK];
    [self setupViewControllers];
    [self setupSound];
    
    
    [self setupWindow];
    [self setupWindowStyle];
    [self showHintMessage];
    [self showLoginIfNeeded];

    
#ifdef DEBUG
    [UserManager encryptPassword:@"111111"];
#endif
    

    [self test:application];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // update umeng config when enter background
    [MobClick updateOnlineConfig];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - setup

-(void)setupMobClick{
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    
    // init mob click
    [MobClick startWithAppkey:UMENG_APP_KEY
                 reportPolicy:BATCH
                    channelId:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFChannelId"]];
    [MobClick updateOnlineConfig];
}

-(void)setupKeyboard{
    // setup keyboard
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    //     [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}
-(void)setupShareSDK{
    // init Share SDK
    [[UserService sharedInstance] prepareShareSDK];
    [[UserService sharedInstance] prepareSmsSDK];
}
-(void)setupSound{
    //TODO delete this kind of sound ,find a good one
    [[CHAudioPlayer sharedInstance]updateWithResource:@"fart"
                                               ofType:@"wav"];
    //    [[CHAudioPlayer sharedInstance]updateWithSoundID:1013];
}

-(void)setupWindowStyle{
    // set status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // set navigation bar
    [[AppDelegate sharedInstance] customizeNavigationBar];
}
-(void)setupWindow{
    // setup init tab bar controller
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}
-(void)showHomePage
{
     [self.window setRootViewController:self.viewController];
}
#pragma mark - ShowMessage

-(void)showHintMessage{
    //show notice
    if(APP_DISPLAY_NOTICE.length>0)
        POSTMSG2(APP_DISPLAY_NOTICE, 5);
}





#pragma mark - Tab Bar Controller Methods

- (void)setupViewControllers {
    UIViewController *firstViewController = [[UserTimelineFeedController alloc] init];
    firstViewController.title = @"首页";
    
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[NewFeedController alloc] init];
    secondViewController.title = @"";
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[FriendListController alloc] init];
    thirdViewController.title = @"好友";
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    //    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           thirdNavigationController]];
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
}

#define CENTER_TAB_BAR_BUTTON_INDEX 1       // the second tab item is CENTER button
#define TABBAR_IMAGE_TOP_INSETS 5
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"firstpage", @"", @"friend"];
  
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        UIColor* normalColor = [UIColor  colorWithRed:0xeb/255.0 green:0x50/255.0 blue:0x52/255.0 alpha:1.0];
        UIColor* selectedColor = [UIColor  colorWithRed:0xa4/255.0 green:0xa6/255.0 blue:0xb4/255.0 alpha:1.0];
        item.selectedTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:normalColor, NSForegroundColorAttributeName, [UIFont systemFontOfSize:10], NSFontAttributeName, nil];
        item.unselectedTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:selectedColor, NSForegroundColorAttributeName, [UIFont systemFontOfSize:10], NSFontAttributeName, nil];
        item.itemHeight = kTabBarHeight;
    
        UIOffset imagePosition = item.imagePositionAdjustment;
        imagePosition.vertical = TABBAR_IMAGE_TOP_INSETS;
        item.imagePositionAdjustment = imagePosition;
        
        UIImage *bgImage = [UIImage imageNamed:@"tabbar_bg"];
        [item setBackgroundSelectedImage:bgImage withUnselectedImage:bgImage];
      
        if (index == CENTER_TAB_BAR_BUTTON_INDEX) {
            // center button, disable this tab
            [item setEnabled:FALSE];
        }

        index++;
    }
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"published_normal"]
                    highlightImage:[UIImage imageNamed:@"published_select"]
                            target:tabBarController];
    
}

#define CENTERBUTTON_IMAGE_TOP_INSETS 10

- (void)addCenterButtonWithImage:(UIImage *)buttonImage
                  highlightImage:(UIImage *)highlightImage
                          target:(RDVTabBarController *)tabBarController
{
    NSUInteger totalTabCount = [[[tabBarController tabBar] items] count];
    
    UIButton* button = [[UIButton alloc ]init];

    
    CGFloat padding = CENTERBUTTON_IMAGE_TOP_INSETS;
    CGFloat height =  tabBarController.view.frame.size.height -kTabBarHeight + padding;
    CGFloat width = tabBarController.view.frame.size.width/totalTabCount;
    
    CGFloat widthBtn = tabBarController.view.frame.size.width/totalTabCount;
    CGFloat heightBtn = kTabBarHeight;
    button.frame = CGRectMake(width, height, widthBtn, heightBtn);
    button.tag = CENTER_TAB_BAR_BUTTON_TAG;

    
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, CENTERBUTTON_IMAGE_TOP_INSETS, 0)];

    [button addTarget:self action:@selector(ceterButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    [self.viewController.view addSubview:button];
}

- (void)ceterButtonPressed
{
    CGRect frame = [UIApplication sharedApplication].keyWindow.bounds;
    PublishSelectView *publishSelectView = [[PublishSelectView alloc] initWithFrame:frame];
    
   
    [[UIApplication sharedApplication].keyWindow addSubview:publishSelectView];
//    [publishSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo([UIApplication sharedApplication].keyWindow);
//        make.center.equalTo([UIApplication sharedApplication].keyWindow);
//    }];
    
}

- (void)customizeNavigationBar {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
  
    UIImage* backgroundImage = [UIImage imageNamed:@"barbg64.png"];

    NSDictionary *textAttributes = nil;
    textAttributes = @{
                       NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                       NSForegroundColorAttributeName: [UIColor whiteColor],
                       };
//    [navigationBarAppearance setBackgroundColor:[UIColor redColor]];

    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    
    // hide left text
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];

}

// [[AppDelegate sharedInstance] customizeBlackNavigationBar]
- (void)customizeBlackNavigationBar {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    

    UIImage* backgroundImage = [UIImage imageNamed:@"barbg64.png"];
    
    NSDictionary *textAttributes = nil;
    textAttributes = @{
                       NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                       NSForegroundColorAttributeName: [UIColor blackColor],
                       };
    //    [navigationBarAppearance setBackgroundColor:[UIColor redColor]];
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
}

#pragma mark - for Handle Open URL

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - Misc Utils

- (UINavigationController*)currentNavigationController
{
    if ([self.viewController respondsToSelector:@selector(selectedViewController)]){
        UINavigationController* selectedController = [self.viewController performSelector:@selector(selectedViewController)];
        return selectedController;
    }
    else{
        return nil;
    }
}

- (UIViewController*)currentViewController
{
    return self.currentNavigationController.topViewController;
}

+ (AppDelegate*)sharedInstance
{
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return app;
}

#pragma mark - Login

- (void)showLoginIfNeeded
{
    if ([[UserManager sharedInstance] hasUser] == YES)
    {
        [self showHomePage];
        return;
    }
    LoginHomeWithInviteCodeController* vc = [[LoginHomeWithInviteCodeController alloc] init];
    self.loginNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window setRootViewController:self.loginNavigationController];
//    [current presentViewController:self.loginNavigationController animated:NO completion:nil];
}

- (void)showNormalHome
{
    if (self.loginNavigationController){
        [self.loginNavigationController dismissViewControllerAnimated:YES completion:^{
            self.loginNavigationController = nil;
        }];
    }
    [self showHomePage];
}
-(void)showDemoController{

    UIViewController* current = [self currentViewController];
    DemoViewController* vc = [[DemoViewController alloc] init];
    [current presentViewController:vc animated:NO completion:nil];
}

#pragma mark - Notification
-(void)test:(UIApplication*)application
{

    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"Accept";//按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        //    action.authenticationRequired = YES;
        //    action.destructive = YES;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        //3.创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
        [application registerUserNotificationSettings:notiSettings];
    }
    else
    {
         [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }


}

#pragma mark UIApplicationDelegate
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PPDebug(@"<didRegisterForRemoteNotificationsWithDeviceToken> deviceToken=%@", deviceToken);
    
    // 注册APNS成功, 注册deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    // 注册APNS失败
    // 自行处理
    PPDebug(@"<didFailToRegisterForRemoteNotificationsWithError> error=%@", err);
}

// iOS8
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self setupMiPushStatistic:userInfo];
}

// iOS7
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self setupMiPushStatistic:userInfo];
}

#pragma mark MiPushSDKDelegate

- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    // 请求成功
    PPDebug(@"<MiPush> success, data=%@", data);
    
    if ([selector isEqualToString:@"bindDeviceToken:"]) {
        
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action1"; //按钮的标示
        action.title=@"启动"; //按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2";
        action2.title=@"忽略";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category"; //这组动作的唯一标示
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound)
                                                                            categories:[NSSet setWithObjects:categorys, nil]];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    }
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    // 请求失败
    PPDebug(@"<MiPush> ERROR!!!!! error=%d, data=%@", error, data);
}

#pragma mark MiPush

- (void)setupMiPushAlias
{
    // 设置别名
//    [MiPushSDK setAlias:@“alias”]
    
    // 订阅内容
//    [MiPushSDK subscribe:@“topic”]
}

- (void)setupMiPushStatistic:(NSDictionary*)userInfo
{
    NSString *messageId = [userInfo objectForKey:@"_id_"];
    [MiPushSDK openAppNotify:messageId];
}





@end
