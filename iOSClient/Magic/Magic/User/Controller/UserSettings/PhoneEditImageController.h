//
//  PhoneEditImageController.h
//  BarrageClient
//
//  Created by Teemo on 15/3/19.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "BCUIViewController.h"

typedef void (^EditSaveBlock) (NSString* text);
@interface PhoneEditImageController : BCUIViewController
- (id)initWithText:(NSString*)text
       placeHolder:(NSString*)placeHolder
              tips:(NSString*)tips
   saveActionBlock:(EditSaveBlock)saveActionBlock;

@property (nonatomic, strong) NSString* editText;
@property (nonatomic, strong) NSString* placeHolder;
@property (nonatomic, strong) NSString* tips;

@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UILabel *tipsLabel;

@property (nonatomic, copy) EditSaveBlock saveActionBlock;
@end
