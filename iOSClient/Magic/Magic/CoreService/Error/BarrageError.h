//
//  BarrageError.h
//  BarrageClient
//
//  Created by pipi on 14/11/29.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BARRAGE_ERROR(x) [BarrageError errorWithCode:x]

@interface BarrageError : NSError {
    
}

+ (NSError *)errorWithCode:(NSInteger) code;
+ (void)postError:(NSError *)error;
+ (void)postErrorWithCode:(NSInteger) code;

@end