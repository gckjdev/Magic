//
//  UILineGridsView.h
//  BarrageClient
//
//  Created by Teemo on 15/3/3.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  画网格的UIView
 */
@interface UILineGridsView : UIView
@property (nonatomic, assign)   CGFloat             lineWidth;
@property (nonatomic,copy)      UIColor             *lineColor;
@property (nonatomic, assign)   NSInteger           lineCount;
@end
