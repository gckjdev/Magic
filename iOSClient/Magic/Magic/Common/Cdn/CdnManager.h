//
//  CdnManager.h
//  BarrageClient
//
//  Created by pipi on 15/1/27.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

#import "QNUploadOption.h"
#import "QNUploadManager.h"
#import "QNResponseInfo.h"

@interface CdnManager : NSObject

DEF_SINGLETON_FOR_CLASS(CdnManager)

- (NSString*)getUserDataUrl:(NSString*)key;
- (NSString*)getUserDataToken;
- (NSString*)getUserAvatarDataPrefix;
- (NSString*)getUserBackgroundDataPrefix;

- (NSString*)getFeedDataUrl:(NSString*)key;
- (NSString*)getFeedDataToken;
- (NSString*)getFeedDataKeyPrefix;


@end
