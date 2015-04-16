//
//  AutoTagManager.h
//  BarrageClient
//
//  Created by HuangCharlie on 3/3/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonManager.h"

@interface AutoTagManager : CommonManager
{
}

DEF_SINGLETON_FOR_CLASS(AutoTagManager)

//crucial function, check ererytime new feed send..
- (void)checkNeedAutoMakeTagWithUsers:(NSArray*)users;

@end
