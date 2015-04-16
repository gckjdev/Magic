//
//  UIView+Rotating
//  BarrageClient
//
//  Created by HuangCharlie on 2/7/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Rotating)

@property (nonatomic) UIRotationGestureRecognizer *rotateGesture;

@property (nonatomic) NSValue* oldTransform;

-(void)setViewRotatable;

-(void)setRotationEnabled:(BOOL)enable;

@end
