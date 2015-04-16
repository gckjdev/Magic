//
//  SelectionController.h
//  BarrageClient
//
//  Created by gckj on 15/1/7.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCTableViewController.h"

typedef void (^SelectionSaveBlock) (NSInteger selected);

//  在设置风格和速度时使用
@interface SelectionController : BCTableViewController

@property (nonatomic,copy) SelectionSaveBlock saveActionBlock;
@property (nonatomic,strong) UIBarButtonItem *saveButton;
@property (nonatomic,assign) NSInteger currentSelected;
@property (nonatomic,strong)NSArray *itemArray;

- (id)initWithItemArray:(NSArray*)itemArray
       currentSelected:(int)currentSelected
   saveActionBlock:(SelectionSaveBlock)saveActionBlock;
@end
