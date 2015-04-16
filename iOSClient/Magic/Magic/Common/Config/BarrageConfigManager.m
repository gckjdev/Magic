//
//  BarrageConfigManager.m
//  BarrageClient
//
//  Created by pipi on 14/12/8.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "BarrageConfigManager.h"
#import "UIUtils.h"

@implementation BarrageConfigManager

+ (NSString*)snsOfficialId:(ShareType)shareType
{
    switch (shareType) {
        case ShareTypeSinaWeibo:
            // TODO
            return UMENG_STRVALUE(@"SINA_OFFICIAL_ID", @"drawlively");
            
        case ShareTypeQQSpace:
            // TODO
            return UMENG_STRVALUE(@"QQSPACE_OFFICIAL_ID", @"小吉画画");

        default:
            return nil;
    }
}

+ (BOOL)isInReviewVersion
{
    NSString* currentVersion = [UIUtils getAppVersion];
    NSString* inReviewVersion = [MobClickUtils getStringValueByKey:@"IN_REVIEW_VERSION" defaultValue:@""];
    if ([inReviewVersion length] > 0){
        return [currentVersion isEqualToString:inReviewVersion];
    }
    else{
        return YES;
    }    
}


@end
