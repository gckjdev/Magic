//
//  AvatarsCollectionViewLayout.m
//  BarrageClient
//
//  Created by HuangCharlie on 2/27/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "AvatarsCollectionViewLayout.h"
#import "PPDebug.h"

@implementation AvatarsCollectionViewLayout


-(UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
    attr.center = CGPointMake(0,0);
    
    return attr;
}

-(UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
    attr.center = CGPointMake(0,0);
    
    return attr;
}

@end
