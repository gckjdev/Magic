//
//  BackgroundCell.h
//  BarrageClient
//
//  Created by 蔡少武 on 15/1/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundCell : UITableViewCell

@property (nonatomic,strong) UIImageView *bgImageView;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
      backgroundImg:(NSString*)backgoundImg
        bgLabelText:(NSString *)bgLabelText;
@end
