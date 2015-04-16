//
//  Feed.m
//  BarrageClient
//
//  Created by pipi on 14/12/9.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "Feed.h"
#import "PPDebug.h"

#define KEY_PB_DATA     @"KEY_PB_DATA"
#define KEY_ID          @"KEY_ID"

@implementation Feed

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    PBFeed* obj = [self.feedBuilder build];
    
    if (obj){
        self.feedBuilder = [PBFeed builderWithPrototype:obj];
        [aCoder encodeObject:[obj data] forKey:KEY_PB_DATA];
    }
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        NSData* data = [aDecoder decodeObjectForKey:KEY_PB_DATA];
        if (data){
            @try {
                PBFeed* obj = [PBFeed parseFromData:data];
                if (obj){
                    self.feedBuilder = [PBFeed builderWithPrototype:obj];
                }
            }
            @catch (NSException *exception) {
                PPDebug(@"<Feed> initWithCoder error catch exception(%@)", [exception description]);
            }
        }
        
    }
    
    return self;
}

+ (Feed*)feedWithPBFeed:(PBFeed*)pbFeed
{
    if (pbFeed == nil){
        return nil;
    }
    
    Feed* feed = [[Feed alloc] init];
    feed.feedBuilder = [PBFeed builderWithPrototype:pbFeed];
    
    return feed;
}

- (NSString*)feedId
{
    return self.feedBuilder.feedId;
}

@end
