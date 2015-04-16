//
//  BarrageActionManager.h
//  BarrageClient
//
//  Created by Teemo on 15/3/23.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define COMMON_ACTION_SIZE  86.0f
@interface BarrageActionManager : NSObject
+(NSArray*)barrageVerticalAction:(NSArray*) barrage
                  maxHeightCount:(CGFloat)maxHeightCount
                        posX:(CGFloat)posX
                        poxY:(CGFloat)posY;

+(NSArray*)barrageHorizontalAction:(NSArray*) barrage
                     maxWidthCount:(CGFloat)maxWidthCount
                              posX:(CGFloat)posX
                              poxY:(CGFloat)posY;

+(NSArray*)barrageSlashDescAction:(NSArray*) barrage
                maxWidthCount:(CGFloat)maxWidthCount
               maxHeightCount:(CGFloat)maxHeightCount
                             posX:(CGFloat)posX
                             poxY:(CGFloat)posY;

+(NSArray*)barrageSlashAscAction:(NSArray*) barrage
                    maxWidthCount:(CGFloat)maxWidthCount
                   maxHeightCount:(CGFloat)maxHeightCount
                            posX:(CGFloat)posX
                            poxY:(CGFloat)posY;




+(NSArray*)barrageShapeVAction:(NSArray*) barrage
                 maxWidthCount:(CGFloat)maxWidthCount
                maxHeightCount:(CGFloat)maxHeightCount
                          posX:(CGFloat)posX
                          poxY:(CGFloat)posY;

+(NSArray*)barrageCommonAction:(NSArray*)barrage
                        matrix:(NSArray*)matrix
                 maxWidthCount:(CGFloat)maxWidthCount
                maxHeightCount:(CGFloat)maxHeightCount
                          posX:(CGFloat)posX
                          poxY:(CGFloat)posY;

@end
