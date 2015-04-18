//
//  RegisterByPhoneVerifyCotroller.h
//  BarrageClient
//
//  Created by Teemo on 15/3/18.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "BCUIViewController.h"
typedef void (^VerifyPassBlock)();

@interface RegisterByPhoneVerifyCotroller : BCUIViewController
@property (nonatomic,copy) VerifyPassBlock   verifyPassBlock;
+(RegisterByPhoneVerifyCotroller*)initWithPhoneNum:(NSString*)phoneNum;
@end
