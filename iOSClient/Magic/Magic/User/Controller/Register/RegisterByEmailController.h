//
//  RegisterByEmailController.h
//  BarrageClient
//
//  Created by gckj on 15/1/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//
//  Modified by Shaowu Cai on 15/3/13

#import <UIKit/UIKit.h>
typedef void (^VerifyPassBlock)();
@interface RegisterByEmailController : UIViewController
@property (nonatomic,strong) VerifyPassBlock   verifyPassBlock;
@end
