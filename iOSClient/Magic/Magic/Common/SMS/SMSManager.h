//
//  SMSManager.h
//  BarrageClient
//
//  Created by Teemo on 15/3/17.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSManager : NSObject
+(void)sendMessage:(NSString*)phone zone:(NSString*)zone;
+(void)commitVerifty:(NSString*)code;
@end
