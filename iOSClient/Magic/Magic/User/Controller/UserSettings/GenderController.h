//
//  SexController.h
//  BarrageClient
//
//  Created by 蔡少武 on 15/1/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUserGenderCell @"kUserGenderCell"

typedef void (^GenderSaveBlock) (BOOL Gender);

@interface GenderController : UITableViewController

@property (nonatomic,copy) GenderSaveBlock saveActionBlock;

@property (nonatomic,strong) UIBarButtonItem *saveButton;

@property (nonatomic,assign) BOOL Gender;
- (id)initWithGender:(BOOL)Gender
  saveActionBlock:(GenderSaveBlock)saveActionBlock;
@end
