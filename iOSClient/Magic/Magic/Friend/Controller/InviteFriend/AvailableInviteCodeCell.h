//
//  AvailableInviteCodeCell.h
//  BarrageClient
//
//  Created by 蔡少武 on 15/1/11.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickButtonAction) (NSIndexPath* indexPath);

@interface AvailableInviteCodeCell : UITableViewCell

@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UIView *backgroundView;
@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,copy)ClickButtonAction clickAddActionBlock;

@end
