//
//  NormalCell.h
//  BarrageClient
//
//  Created by gckj on 15/1/30.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalCell : UITableViewCell

//  暂时用不到
-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                        text:(NSString*)text
                  detailText:(NSString*)detailText;
@end
