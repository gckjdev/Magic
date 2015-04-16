//
//  SnsService.h
//  BarrageClient
//
//  Created by pipi on 15/1/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"
#import <ShareSDK/ShareSDK.h>

typedef void(^ShareSNSResultBlock) (int resultCode);

@interface SnsService : NSObject

DEF_SINGLETON_FOR_CLASS(SnsService)

- (BOOL)isAuthenticated:(ShareType)shareType;
- (BOOL)isExpired:(ShareType)shareType;
- (void)autheticate:(ShareType)shareType;
- (void)cancelAuthentication:(ShareType)shareType;
- (void)followUser:(ShareType)shareType weiboId:(NSString*)weiboId weiboName:(NSString*)weiboName;

- (void)publishWeibo:(ShareType)shareType
                text:(NSString*)text
       imageFilePath:(NSString*)imagePath
              inView:(UIView*)view
          awardCoins:(int)awardCoins
      successMessage:(NSString*)successMessage
      failureMessage:(NSString*)failureMessage
              taskId:(int)taskId;

- (void)publishWeibo:(ShareType)shareType
                text:(NSString*)text
       imageFilePath:(NSString*)imageFilePath
              inView:(UIView*)view
          awardCoins:(int)awardCoins
      successMessage:(NSString*)successMessage
      failureMessage:(NSString*)failureMessage;

- (void)publishWeiboAtBackground:(ShareType)shareType
                            text:(NSString*)text
                   imageFilePath:(NSString*)imagePath
                      awardCoins:(int)awardCoins
                  successMessage:(NSString*)successMessage
                  failureMessage:(NSString*)failureMessage;

- (void)publishWeibo:(ShareType)shareType
                text:(NSString*)text
       imageFilePath:(NSString*)imagePath
            audioURL:(NSString*)audioURL
               title:(NSString*)title
              inView:(UIView*)view
          awardCoins:(int)awardCoins
      successMessage:(NSString*)successMessage
      failureMessage:(NSString*)failureMessage;

- (void)publishWeibo:(ShareType)shareType
                text:(NSString*)text
              inView:(UIView*)view
          awardCoins:(int)awardCoins
      successMessage:(NSString*)successMessage
      failureMessage:(NSString*)failureMessage;
//- (void)publishWeiboToAll:(NSString*)text;
//- (void)saveSNSInfo:(PPshareType)shareType credentialString:(NSString*)credentialString;

- (void)publishWeibo:(ShareType)shareType
                text:(NSString*)text
       imageFilePath:(NSString*)imagePath
            audioURL:(NSString*)audioURL
               title:(NSString*)title
              inView:(UIView*)view
          awardCoins:(int)awardCoins
      successMessage:(NSString*)successMessage
      failureMessage:(NSString*)failureMessage
              taskId:(int)taskId;

- (void)saveSNSInfoIntoShareSDK:(NSArray*)snsUserList;

@end
