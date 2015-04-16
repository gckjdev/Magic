//
//  LevelDBManager.m
//  Draw
//
//  Created by qqn_pipi on 13-6-16.
//
//

#import "LevelDBManager.h"
#import "FileUtil.h"
#import "PPDebug.h"

#define LEVEL_DB_DIR   @"level_db"

static LevelDBManager* globalLevelDBManager;

@implementation LevelDBManager

+ (LevelDBManager*)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalLevelDBManager = [[LevelDBManager alloc] init];
    });
    
    return globalLevelDBManager;
}

- (id)init
{
    NSString* dir = [FileUtil filePathInAppDocument:LEVEL_DB_DIR];
    [FileUtil createDir:dir];    
    
    self = [super init];
    _allDbs = [[NSMutableDictionary alloc] init];

    
    return self;
}

- (APLevelDB*)db:(NSString*)dbName
{
    if ([dbName length] == 0)
        return nil;
    
    APLevelDB* ldb = [_allDbs objectForKey:dbName];
    if (ldb != nil)
        return ldb;
    
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", LEVEL_DB_DIR, dbName];
    NSString* filePath = [FileUtil filePathInAppDocument:path];
    
    NSError* error = nil;
    ldb = [APLevelDB levelDBWithPath:filePath error:&error];
    if (ldb != nil){
        PPDebug(@"Open Level DB At Path:%@", filePath);
        [_allDbs setObject:ldb forKey:dbName];
    }
    else{
        PPDebug(@"ERROR(%@) Open Level DB At Path:%@", [error description], filePath);
    }

    return ldb;
}


@end
