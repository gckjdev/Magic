//
//  HYCEmitterLayer.h
//  BarrageClient
//
//  Created by HuangCharlie on 1/9/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface HYCEmitterLayer : CAEmitterLayer

+ (HYCEmitterLayer*)emitterViewInView:(UIView*)superView
                              AtPoint:(CGPoint)position
                            AndBounds:(CGRect)viewBounds;


@end
