//
//  ImageBadgeButton.h
//  BarrageClient
//
//  Created by Teemo on 15/3/26.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeButton.h"
@interface ImageBadgeButton : UIButton

+(instancetype)initWithFrame:(CGRect)frame
                       image:(NSString*)image
                      target:(id)target
                      action:(SEL)action;
@property (nonatomic,strong) NSString*   badgeValue;

@end
