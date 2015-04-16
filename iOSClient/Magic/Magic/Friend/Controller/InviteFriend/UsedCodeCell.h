//
//  UsedCodeCell.h
//  BarrageClient
//
//  Created by gckj on 15/1/27.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsedCodeCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                        text:(NSString*)text
                  detailText:(NSString*)detailText;

@property (nonatomic,strong)NSIndexPath *indexPath;

@end
