//
//  RegEmailVerifyController.h
//  BarrageClient
//
//  Created by Teemo on 15/3/31.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "BCUIViewController.h"

typedef void (^VerifyPassBlock)();


@interface RegEmailVerifyController : BCUIViewController
@property (nonatomic,copy) VerifyPassBlock   verifyPassBlock;
+(instancetype)controllerWithEmail:(NSString*)destEmail;
@end
