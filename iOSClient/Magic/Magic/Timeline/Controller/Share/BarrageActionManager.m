//
//  BarrageActionManager.m
//  BarrageClient
//
//  Created by Teemo on 15/3/23.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "BarrageActionManager.h"
#import "Barrage.pb.h"

@implementation BarrageActionManager
+(NSArray*)barrageVerticalAction:(NSArray*) barrage
                  maxHeightCount:(CGFloat)maxHeightCount
                            posX:(CGFloat)posX
                            poxY:(CGFloat)posY;
{

    NSInteger barrageCount = [barrage count];
    NSInteger fixCount = 0;
    NSInteger maxNeedFeed = maxHeightCount;
    CGFloat spaceHeight = 0;

    if (barrageCount>=maxNeedFeed) {
        fixCount = maxNeedFeed;
    }else if(barrageCount>=1){
        fixCount = barrageCount;
    }else{
        return barrage;
    }
    spaceHeight = (maxHeightCount - fixCount)/(fixCount-1)*COMMON_ACTION_SIZE;

    NSMutableArray *barrageList = [barrage mutableCopy];
    for(int i = 0; i < fixCount; i++)
    {
        PBFeedAction* feedAction = [barrageList objectAtIndex:i];
        CGPoint pos = CGPointMake(posX, (COMMON_ACTION_SIZE + spaceHeight)* i +posY);
        barrageList[i] = [self updateFeedAction:feedAction position:pos];
        
        
    }
    return [barrageList copy];
}
+(NSArray*)barrageHorizontalAction:(NSArray*) barrage
                   maxWidthCount:(CGFloat)maxWidthCount
                              posX:(CGFloat)posX
                              poxY:(CGFloat)posY;
{
    
    NSInteger barrageCount = [barrage count];
    NSInteger fixCount = 0;
    NSInteger maxNeedFeed = maxWidthCount;
    CGFloat spaceWidth = 0;
    
    if (barrageCount>=maxNeedFeed) {
        fixCount = maxNeedFeed;
    }else if(barrageCount>=1){
        fixCount = barrageCount;
    }else{
        return barrage;
    }
    spaceWidth = (maxWidthCount - fixCount)/(fixCount-1)*COMMON_ACTION_SIZE;
    
    NSMutableArray *barrageList = [barrage mutableCopy];
    for(int i = 0; i < fixCount; i++)
    {
        PBFeedAction* feedAction = [barrageList objectAtIndex:i];
        CGPoint pos = CGPointMake(posX+(COMMON_ACTION_SIZE + spaceWidth)* i, posY);
        barrageList[i] = [self updateFeedAction:feedAction position:pos];
    }
    return [barrageList copy];
}



+(NSArray*)barrageSlashDescAction:(NSArray*) barrage
                maxWidthCount:(CGFloat)maxWidthCount
               maxHeightCount:(CGFloat)maxHeightCount
                             posX:(CGFloat)posX
                             poxY:(CGFloat)posY;
{
    NSInteger barrageCount = [barrage count];
    NSInteger fixCount = 0;
    NSInteger maxNeedFeed = maxHeightCount;
    CGFloat spaceHeight = 0;
    CGFloat spaceWidth = 0;
    
    if (barrageCount>=maxNeedFeed) {
        fixCount = maxNeedFeed;
    }else if(barrageCount>=1){
        fixCount = barrageCount;
    }else{
        return barrage;
    }
    spaceHeight = (maxHeightCount - fixCount)/(fixCount-1)*COMMON_ACTION_SIZE;
    spaceWidth = (maxWidthCount - fixCount)/(fixCount-1)*COMMON_ACTION_SIZE;
    
    NSMutableArray *barrageList = [barrage mutableCopy];
    for(int i = 0; i < fixCount; i++)
    {
        PBFeedAction* feedAction = [barrageList objectAtIndex:i];
        CGPoint pos = CGPointMake(posX + (COMMON_ACTION_SIZE + spaceWidth)*i, (COMMON_ACTION_SIZE + spaceHeight)* i +posY);
        barrageList[i] = [self updateFeedAction:feedAction position:pos];
        
        
    }
    return [barrageList copy];
}
+(NSArray*)barrageSlashAscAction:(NSArray*) barrage
                   maxWidthCount:(CGFloat)maxWidthCount
                  maxHeightCount:(CGFloat)maxHeightCount
                            posX:(CGFloat)posX
                            poxY:(CGFloat)posY;
{
    NSInteger barrageCount = [barrage count];
    NSInteger fixCount = 0;
    NSInteger maxNeedFeed = maxHeightCount;
    CGFloat spaceHeight = 0;
    CGFloat spaceWidth = 0;
    CGFloat maxHeight = maxHeightCount * COMMON_ACTION_SIZE;
    if (barrageCount>=maxNeedFeed) {
        fixCount = maxNeedFeed;
    }else if(barrageCount>=1){
        fixCount = barrageCount;
    }else{
        return barrage;
    }
    spaceHeight = (maxHeightCount - fixCount)/(fixCount-1)*COMMON_ACTION_SIZE;
    spaceWidth = (maxWidthCount - fixCount)/(fixCount-1)*COMMON_ACTION_SIZE;
    
    NSMutableArray *barrageList = [barrage mutableCopy];
    for(int i = 0; i < fixCount; i++)
    {
        PBFeedAction* feedAction = [barrageList objectAtIndex:i];
        CGPoint pos = CGPointMake(posX + (COMMON_ACTION_SIZE + spaceWidth)*i, (maxHeight-COMMON_ACTION_SIZE)-(COMMON_ACTION_SIZE + spaceHeight)* i +posY);
        barrageList[i] = [self updateFeedAction:feedAction position:pos];
    
    }
    return [barrageList copy];
}
+(NSArray*)barrageShapeVAction:(NSArray*) barrage
                 maxWidthCount:(CGFloat)maxWidthCount
                maxHeightCount:(CGFloat)maxHeightCount
                          posX:(CGFloat)posX
                          poxY:(CGFloat)posY;
{
    NSInteger barrageCount = [barrage count];
    NSInteger fixCount = 0;
    NSInteger maxNeedFeed = maxHeightCount*2 - 1;
    CGFloat spaceHeight = 0;
    CGFloat spaceWidth = 0;
    CGFloat maxHeight = maxHeightCount * COMMON_ACTION_SIZE;
    if (barrageCount>=maxNeedFeed) {
        fixCount = maxNeedFeed;
    }else if(barrageCount>=3){
        if (barrageCount&1) {
            fixCount = barrageCount;
        }else{
            fixCount = barrageCount - 1;
        }
    }else{
        return barrage;
    }
    NSInteger halfCount = fixCount / 2;
    spaceHeight = (maxHeightCount - (halfCount + 1))/halfCount*COMMON_ACTION_SIZE;
    spaceWidth =  (maxHeightCount - (halfCount + 1))/halfCount*COMMON_ACTION_SIZE;
    
    
    NSMutableArray *barrageList = [barrage mutableCopy];
 
    //left FeedAction and middle FeedAction
    for(NSInteger i = 0; i <= halfCount; i++)
    {
        PBFeedAction* feedAction = [barrageList objectAtIndex:i];
        CGPoint pos = CGPointMake(posX + (COMMON_ACTION_SIZE + spaceWidth)* i , (COMMON_ACTION_SIZE + spaceHeight)* i +posY );
        barrageList[i] = [self updateFeedAction:feedAction position:pos];
        
    }
    
    
    
    //right FeedAction
    for(NSInteger i = halfCount + 1; i < fixCount; i++)
    {
        PBFeedAction* feedAction = [barrageList objectAtIndex:i];
        CGPoint pos = CGPointMake(posX + (COMMON_ACTION_SIZE+ spaceWidth)* i ,(maxHeight-COMMON_ACTION_SIZE) - (COMMON_ACTION_SIZE+spaceHeight) *(i-halfCount)+posY );
        barrageList[i] = [self updateFeedAction:feedAction position:pos];
    }
    return [barrageList copy];
}


+(NSArray*)barrageCommonAction:(NSArray*)barrage
                        matrix:(NSArray*)matrix
                 maxWidthCount:(CGFloat)maxWidthCount
                maxHeightCount:(CGFloat)maxHeightCount
                          posX:(CGFloat)posX
                          poxY:(CGFloat)posY
{
    NSInteger barrageCount = [barrage count];
    NSInteger fixCount = 0;
    NSInteger matrixCount  = [matrix count]-1;
    NSInteger paddingCount = 0;
    
    if (barrageCount>=matrixCount) {
        fixCount = matrixCount;
        paddingCount  = 0;
    }
    else{
        fixCount = barrageCount;
        paddingCount = matrixCount - barrageCount;
    }
    //默认数据第一个为shape大小
    CGPoint shapeSize = [(NSValue*)matrix[0] CGPointValue];
    CGPoint topLeftCorner = CGPointMake((maxWidthCount - shapeSize.x)/2, (maxHeightCount - shapeSize.y)/2);
    
    
    NSMutableArray *barrageList = [NSMutableArray array];
    
    for (NSInteger i = 0; i < fixCount; i++) {
        CGPoint matrixPoint = [[matrix objectAtIndex:i+paddingCount+1]CGPointValue];
        CGPoint pos = CGPointMake(posX + COMMON_ACTION_SIZE * (matrixPoint.x +topLeftCorner.x), COMMON_ACTION_SIZE * (matrixPoint.y + topLeftCorner.y) + posY );
        [barrageList addObject:[NSValue valueWithCGPoint:pos]];
    }
    
    //多出的放在左下角
    for (NSInteger i = fixCount; i < barrageCount; i++) {
        CGPoint pos = CGPointMake(0 , COMMON_ACTION_SIZE * maxHeightCount );
        [barrageList addObject:[NSValue valueWithCGPoint:pos]];
    }
    return [barrageList copy];
}

+(PBFeedAction*)updateFeedAction:(PBFeedAction*)feedAction position:(CGPoint)position
{
    PBFeedActionBuilder *feedBuilder = [PBFeedAction builder];
    [feedBuilder mergeFrom:feedAction];
    [feedBuilder setPosX:position.x];
    [feedBuilder setPosY:position.y];
    
    PBFeedAction *newFeed = [feedBuilder build];
    return newFeed;
}


@end
