//
//  HYCEmitterLayer.m
//  BarrageClient
//
//  Created by HuangCharlie on 1/9/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "HYCEmitterLayer.h"

@implementation HYCEmitterLayer

+ (HYCEmitterLayer*)emitterViewInView:(UIView*)superView
                              AtPoint:(CGPoint)position
                            AndBounds:(CGRect)viewBounds
{
    /*
     EmitterLayer是iOS中一个非常炫酷的API。很多具有粒子性的动画特效都可以通过这个API实现，很经典的，烟花，火焰，泉水，蒸汽，等等。
     主要实现方案如下：
     1 创建一个CAEmitterLayer（这里用了继承，为了以后可以扩展至其他功能）
     2 定义一些CAEmitterLayer的属性，position,size,mode,shape，等等
     3 添加CAEmitterCell(详见函数addEmitterCells) && Animation
     4 在super view中 addSublayer
     */
    
    // Create the emitter layer
    HYCEmitterLayer *emitterLayer = [[HYCEmitterLayer alloc]init];
    
    // Cells spawn in a 50pt circle around the position
    emitterLayer.emitterPosition = position;
    emitterLayer.emitterSize	= CGSizeMake(10, 0);
    emitterLayer.emitterMode	= kCAEmitterLayerOutline;
    emitterLayer.emitterShape	= kCAEmitterLayerCircle;
    emitterLayer.renderMode		= kCAEmitterLayerBackToFront;
    
    // add emitter content, including cells and animation
    [emitterLayer addEmitterCells];
    [emitterLayer addEmitterAnimation];

    // Move to touched point
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    emitterLayer.emitterPosition = position;
    [CATransaction commit];
    
    //add emitter view
    [superView.layer addSublayer:emitterLayer];

    return emitterLayer;
}

-(void)addEmitterCells
{
    /*
     EmitterCell是喷射的粒子的类，其中的一些重要属性会影响整个特效，特别是以下的几种，用好了，简简单单地就可以实现一个烟火特效。
     Birthrate(出生率)：每秒发射的粒子数量
     lifetime(生命时间)：一个粒子几秒后消失
     liftetimeRange(生命时间变化范围)：可以用这个东西使粒子的lifetime产生少许变化。粒子系统会随机在这个区间中取一个lifetime出来(lifetime – lifetimeRange, lifetime + lifetimeRange)
     Color(颜色)：粒子内容的颜色
     Contents(内容):用于cell的内容，一般是一个CGImage.
     Name(名称):可以给你的cell取一个名字，用来在之后的时间里查找和修改它的属性。
     */
    // Create the fire emitter cell
    CAEmitterCell* ring = [CAEmitterCell emitterCell];
    [ring setName:@"ring"];
    
    ring.birthRate			= 0;
    ring.velocity			= 250;
    ring.scale				= 0.5;
    ring.scaleSpeed			=-0.2;
    ring.greenSpeed			=-0.2;	// shifting to green
    ring.redSpeed			=-0.5;
    ring.blueSpeed			=-0.5;
    ring.lifetime			= 2;
    
    ring.color = [[UIColor whiteColor] CGColor];
    ring.contents = (id) [[UIImage imageNamed:@"first_selected@2x.png"] CGImage];
    
    
    CAEmitterCell* circle = [CAEmitterCell emitterCell];
    [circle setName:@"circle"];
    
    circle.birthRate		= 10;			// every triangle creates 20
    circle.emissionLongitude = M_PI * 0.5;	// sideways to triangle vector
    circle.velocity			= 50;
    circle.scale			= 0.5;
    circle.scaleSpeed		=-0.2;
    circle.greenSpeed		=-0.1;	// shifting to blue
    circle.redSpeed			=-0.2;
    circle.blueSpeed		= 0.1;
    circle.alphaSpeed		=-0.2;
    circle.lifetime			= 4;
    
    circle.color = [[UIColor whiteColor] CGColor];
    circle.contents = (id) [[UIImage imageNamed:@"first_selected@2x.png"] CGImage];
    
    
    CAEmitterCell* star = [CAEmitterCell emitterCell];
    [star setName:@"star"];
    
    star.birthRate		= 10;	// every triangle creates 20
    star.velocity		= 100;
    star.zAcceleration  = -1;
    star.emissionLongitude = -M_PI;	// back from triangle vector
    star.scale			= 0.5;
    star.scaleSpeed		=-0.2;
    star.greenSpeed		=-0.1;
    star.redSpeed		= 0.4;	// shifting to red
    star.blueSpeed		=-0.1;
    star.alphaSpeed		=-0.2;
    star.lifetime		= 2;
    
    star.color = [[UIColor whiteColor] CGColor];
    star.contents = (id) [[UIImage imageNamed:@"first_selected@2x.png"] CGImage];
    
    // First traigles are emitted, which then spawn circles and star along their path
    self.emitterCells = [NSArray arrayWithObject:ring];
    
    //TODO: to consider whether it is necessary to add star spawn up effect, since that require large consumption, slow down the performance
    //ring.emitterCells = [NSArray arrayWithObjects: circle,star,nil];
    ring.emitterCells = [NSArray arrayWithObjects: nil];
}

-(void)addEmitterAnimation
{
    //basic animation with default model, the animation type was written in certain key path
    CABasicAnimation *burst = [CABasicAnimation animationWithKeyPath:@"emitterCells.ring.birthRate"];

    burst.fromValue = [NSNumber numberWithFloat: 125.0];
    burst.toValue = [NSNumber numberWithFloat: 0.0];

    burst.duration = 0.1;
    burst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    [self addAnimation:burst forKey:@"burst"];
}

@end
