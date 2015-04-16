//
//  MessageCenter.m
//  BarrageClient
//
//  Created by pipi on 15/1/26.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "MessageCenter.h"
#import "PPDebug.h"
#import "UIViewUtils.h"
#import "AppDelegate.h"
#import "ColorInfo.h"

@implementation MessageCenter

IMPL_SINGLETON_FOR_CLASS(MessageCenter)

- (id)init
{
    self = [super init];
//    [TWMessageBarManager sharedInstance].styleSheet = nil;
    return self;
}


- (void)postSuccessMessage:(NSString*)message duration:(CGFloat)duration
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedInstance].window animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 7.0f;
    hud.color = BARRAGETEXTVIEW_BG_COLOR;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:duration];
//    [[TWMessageBarManager sharedInstance] hideAll];
//    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"OH YEAH"
//                                                   description:message
//                                                          type:TWMessageBarMessageTypeSuccess
//                                                      duration:2.0];
}

- (void)postErrorMessage:(NSString*)message duration:(CGFloat)duration
{
//    [[TWMessageBarManager sharedInstance] hideAll];
//    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"OMG"
//                                                   description:message
//                                                          type:TWMessageBarMessageTypeError
//                                                      duration:duration];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedInstance].window animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 7.0f;
    hud.color = BARRAGETEXTVIEW_BG_COLOR;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:duration];
}

- (void)postInfoMessage:(NSString*)message duration:(CGFloat)duration
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedInstance].window animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 7.0f;
    hud.color = BARRAGETEXTVIEW_BG_COLOR;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:duration];
    
//    [[TWMessageBarManager sharedInstance] hideAll];
//    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"KAKA"
//                                                   description:message
//                                                          type:TWMessageBarMessageTypeInfo
//                                                      duration:duration];
}

//- (UIColor *)backgroundColorForMessageType:(TWMessageBarMessageType)type
//{
//    UIColor *backgroundColor = nil;
//    switch (type)
//    {
//        case TWMessageBarMessageTypeError:
//            backgroundColor = BARRAGE_RED_COLOR;
//            break;
//        case TWMessageBarMessageTypeSuccess:
//            backgroundColor = BARRAGE_RED_COLOR;
//            break;
//        case TWMessageBarMessageTypeInfo:
//            backgroundColor = BARRAGE_RED_COLOR;
//            break;
//        default:
//            break;
//    }
//    return backgroundColor;
//}
//
//- (UIColor *)strokeColorForMessageType:(TWMessageBarMessageType)type
//{
//    UIColor *strokeColor = nil;
//    switch (type)
//    {
//        case TWMessageBarMessageTypeError:
//            strokeColor = nil;
//            break;
//        case TWMessageBarMessageTypeSuccess:
//            strokeColor = nil;
//            break;
//        case TWMessageBarMessageTypeInfo:
//            strokeColor = nil;
//            break;
//        default:
//            break;
//    }
//    return strokeColor;
//}
//
//- (UIImage *)iconImageForMessageType:(TWMessageBarMessageType)type
//{
//    UIImage *iconImage = nil;
//    switch (type)
//    {
//        case TWMessageBarMessageTypeError:
//            iconImage = [UIImage imageNamed:nil];
//            break;
//        case TWMessageBarMessageTypeSuccess:
//            iconImage = [UIImage imageNamed:nil];
//            break;
//        case TWMessageBarMessageTypeInfo:
//            iconImage = [UIImage imageNamed:nil];
//            break;
//        default:
//            break;
//    }
//    return iconImage;
//}


//- (UIFont *)titleFontForMessageType:(TWMessageBarMessageType)type;
//- (UIFont *)descriptionFontForMessageType:(TWMessageBarMessageType)type;
//- (UIColor *)titleColorForMessageType:(TWMessageBarMessageType)type;
//- (UIColor *)descriptionColorForMessageType:(TWMessageBarMessageType)type;

#define LOADING_VIEW_TAG        2015012601

- (MBProgressHUD*)showProgress:(NSString*)text inView:(UIView*)view
{
    MBProgressHUD* hud = (MBProgressHUD*)[view viewWithTag:LOADING_VIEW_TAG];;
    if ([hud isKindOfClass:[MBProgressHUD class]] == NO){
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.labelText = text;
        hud.tag = LOADING_VIEW_TAG;
    }
    else{
        hud.labelText = text;
        [hud show:YES];
    }
    
    return hud;
}


- (MBProgressHUD*)showLoading:(NSString*)text inView:(UIView*)view
{
    MBProgressHUD* hud = (MBProgressHUD*)[view viewWithTag:LOADING_VIEW_TAG];;
    if ([hud isKindOfClass:[MBProgressHUD class]] == NO){
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.tag = LOADING_VIEW_TAG;
        hud.labelText = text;
    }
    else{
        hud.labelText = text;
        [hud show:YES];
    }
    
    return hud;
}

- (MBProgressHUD*)showLoadingInView:(UIView*)view
{
    MBProgressHUD* hud = (MBProgressHUD*)[view viewWithTag:LOADING_VIEW_TAG];;
    if ([hud isKindOfClass:[MBProgressHUD class]] == NO){
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.tag = LOADING_VIEW_TAG;
    }
    else{
        [hud show:YES];
    }

    return hud;
}

- (void)hideLoadingView:(UIView*)view
{
    MBProgressHUD* hud = (MBProgressHUD*)[view viewWithTag:LOADING_VIEW_TAG];
    if ([hud isKindOfClass:[MBProgressHUD class]]){
        [hud hide:YES];
    }
    else{
        PPDebug(@"<hideLoadingView> but view is NOT loading view");
    }
}


@end
