//
//  LevelDBManager.h
//  Draw
//
//  Created by qqn_pipi on 13-6-16.
//
//

#import <Foundation/Foundation.h>
#import "APLevelDB.h"

@interface LevelDBManager : NSObject

@property (retain, atomic) NSMutableDictionary* allDbs;

+ (LevelDBManager*)defaultManager;
- (APLevelDB*)db:(NSString*)dbName;

@end
