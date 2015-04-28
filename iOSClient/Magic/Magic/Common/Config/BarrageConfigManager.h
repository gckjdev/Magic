//
//  BarrageConfigManager.h
//  BarrageClient
//
//  Created by pipi on 14/12/8.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobClickUtils.h"
#import <ShareSDK/ShareSDK.h>

//#define DEFAULT_SERVER_URL      @"http://localhost:8100/?"
//#define DEFAULT_SERVER_URL      @"http://192.168.36.201:8100/?"
#define DEFAULT_SERVER_URL       UMENG_STRVALUE(@"TRAFFIC_SERVER_URL", @"http://112.74.107.152:8100/?")


#define QIUNIU_FEED_TOKEN        UMENG_STRVALUE(@"QINIU_TOKEN", @"PGXicdkeGqQHXTBCV-qKbMaQj6aFWwM3yS1qcKKF:AeIaOS9MyyZv7Rq1i2lQ32UGMZc=:eyJzY29wZSI6Imdja2pkZXYiLCJkZWFkbGluZSI6Mjg2NzcyMzQ2Nn0=")

#define QIUNIU_FEED_IMAGE(x)     ([NSString stringWithFormat:@"http://gckjdev.qiniudn.com/%@", x])

#define QIUNIU_USER_TOKEN        UMENG_STRVALUE(@"QINIU_TOKEN", @"PGXicdkeGqQHXTBCV-qKbMaQj6aFWwM3yS1qcKKF:AeIaOS9MyyZv7Rq1i2lQ32UGMZc=:eyJzY29wZSI6Imdja2pkZXYiLCJkZWFkbGluZSI6Mjg2NzcyMzQ2Nn0=")

#define QIUNIU_USER_IMAGE(x)     ([NSString stringWithFormat:@"http://gckjdev.qiniudn.com/%@", x])


#define MAX_LOCAL_INVITE_CODE           UMENG_INTVALUE(@"MAX_INVITE_CODE", 5)

#define DEFAULT_SHARE_TEXT              UMENG_STRVALUE(@"DEFAULT_SHARE_TEXT", @"弹幕图片分享来也")
#define DEFAULT_SHARE_TITLE             UMENG_STRVALUE(@"DEFAULT_SHARE_TITLE", @"弹幕分享")
#define DEFAULT_SHARE_URL               UMENG_STRVALUE(@"DEFAULT_SHARE_URL", @"http://www.bibiji.me")
#define DEFAULT_DOWNLOAD_URL            UMENG_STRVALUE(@"DEFAULT_DOWNLOAD_URL", @"http://www.downloadbibiji.me")//待修改

#define APP_DISPLAY_NAME                UMENG_STRVALUE(@"APP_DISPLAY_NAME", @"BBJ")

#define CONTACT_EMAIL                   UMENG_STRVALUE(@"CONTACT_EMAIL", @"help@xx.com")
//app公告
#define APP_DISPLAY_NOTICE              UMENG_STRVALUE(@"APP_DISPLAY_NOTICE", @"")

#define APP_EDITVIEW_GRID                UMENG_BOOLVALUE(@"APP_EDITVIEW_GRID",YES)

#define APP_EDITVIEW_PREVIEW_BARRAGE     UMENG_BOOLVALUE(@"APP_EDITVIEW_PREVIEW_BARRAGE",YES)

#define APP_DEFAULT_NICK                 UMENG_STRVALUE(@"APP_DEFAULT_NICK", @"还没准备好")
#define APP_EDITVIEW_BARRAGE_HAS_BG             UMENG_BOOLVALUE(@"APP_EDITVIEW_BARRAGE_HAS_BG",NO)

@interface BarrageConfigManager : NSObject

+ (NSString*)snsOfficialId:(ShareType)shareType;
+ (BOOL)isInReviewVersion;

@end
