//
//  EditingController.h
//  BarrageClient
//
//  Created by gckj on 15/1/3.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCUIViewController.h"

typedef void (^EditSaveBlock) (NSString* text);

@interface EditingController : BCUIViewController

- (id)initWithText:(NSString*)editText
       placeHolderText:(NSString*)placeHolderText
              tips:(NSString*)tips
           isMulti:(BOOL)isMulti
   saveActionBlock:(EditSaveBlock)saveActionBlock;

@property (nonatomic, strong) NSString* editText;
@property (nonatomic, strong) NSString* placeHolderText;
@property (nonatomic, strong) NSString* tips;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong) UILabel *tipsLabel;

@property (nonatomic, copy) EditSaveBlock saveActionBlock;
- (void)loadSaveButton;

@end
