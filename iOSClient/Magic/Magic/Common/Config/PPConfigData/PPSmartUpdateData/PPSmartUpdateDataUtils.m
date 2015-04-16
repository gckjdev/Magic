//
//  PPSmartUpdateDataUtils.m
//  Draw
//
//  Created by qqn_pipi on 12-11-29.
//
//

#import "PPSmartUpdateDataUtils.h"
#import "FileUtil.h"
#import "PPSmartUpdateData.h"

static dispatch_once_t dirOnceToken;

@implementation PPSmartUpdateDataUtils


#define SMART_DATA_TOP_DIR                      @"/config_data/"
#define SMART_DATA_DOWNLOAD_DIR                 @"/config_data/download/"
#define SMART_DATA_DOWNLOAD_TEMP_DIR            @"/config_data/download/temp/"

+ (void)initPaths
{
    [FileUtil createDir:[PPSmartUpdateDataUtils getTopPath]];
    [FileUtil createDir:[PPSmartUpdateDataUtils getDownloadTopPath]];
    [FileUtil createDir:[PPSmartUpdateDataUtils getDownloadTempTopPath]];
}

+ (NSString*)getTopPath
{
    NSString* dir = [[FileUtil getAppHomeDir] stringByAppendingPathComponent:SMART_DATA_TOP_DIR];
    return dir;
}

+ (NSString*)getDownloadTopPath
{
    NSString* dir = [[FileUtil getAppCacheDir] stringByAppendingPathComponent:SMART_DATA_DOWNLOAD_DIR];
    return dir;
}

+ (NSString*)getDownloadTempTopPath
{
    NSString* dir = [[FileUtil getAppCacheDir] stringByAppendingPathComponent:SMART_DATA_DOWNLOAD_TEMP_DIR];
    return dir;
}

+ (NSString*)dataVersionKeyByName:(NSString*)name
{
    return [NSString stringWithFormat:@"SMART_DATA_KEY_%@", name];
}

+ (NSString*)copyFilePathByName:(NSString*)name
{
    return [[PPSmartUpdateDataUtils getTopPath] stringByAppendingPathComponent:name];
}

+ (NSString*)copyFilePathWithSubDir:(NSString*)subDir name:(NSString*)name
{
    NSString* dir = [PPSmartUpdateDataUtils getTopPath];
    if ([subDir length] > 0){
        dir = [dir stringByAppendingPathComponent:subDir];
        
        // create dir once
        [FileUtil createDir:dir];
    }
    
    dir = [dir stringByAppendingPathComponent:name];
    PPDebug(@"copy file path dir=%@", dir);
    return dir;
}


+ (NSString*)getVersionUpdateURL:(NSString*)name
{
    NSString* shortName = [name stringByDeletingPathExtension];
    NSString* versionFile = [NSString stringWithFormat:@"%@_version.txt", shortName];
    NSString* url = [SMART_DATA_SERVER_URL stringByAppendingString:versionFile];
    return url;
}

+ (NSString*)getVersionFileName:(NSString*)name
{
    NSString* shortName = [name stringByDeletingPathExtension];
    NSString* versionFile = [NSString stringWithFormat:@"%@_version.txt", shortName];
    return versionFile;
}

+ (NSString*)getFileUpdateURL:(NSString*)name
{
    NSString* url = [SMART_DATA_SERVER_URL stringByAppendingString:name];
    return url;
}

+ (NSString*)getDataURL:(NSString*)serverURL name:(NSString*)name
{
    NSString* url = [serverURL stringByAppendingString:name];
    return url;
}

+ (NSString*)getVersionURL:(NSString*)serverURL name:(NSString*)name
{
    NSString* shortName = [name stringByDeletingPathExtension];
    NSString* versionFile = [NSString stringWithFormat:@"%@_version.txt", shortName];
    NSString* url = [serverURL stringByAppendingString:versionFile];
    return url;
}


+ (NSString*)pathByName:(NSString*)name type:(PPSmartUpdateDataType)type
{
    NSString* finalName = name;
    if (type == SMART_UPDATE_DATA_TYPE_ZIP){
        finalName = [finalName stringByDeletingPathExtension];
    }
    
    return [[PPSmartUpdateDataUtils getTopPath] stringByAppendingPathComponent:finalName];
}

+ (NSString*)pathBySubDir:(NSString*)subDir name:(NSString*)name type:(PPSmartUpdateDataType)type
{
    NSString* finalName = name;
    if (type == SMART_UPDATE_DATA_TYPE_ZIP){
        finalName = [finalName stringByDeletingPathExtension];
    }
    
    NSString* dir = [PPSmartUpdateDataUtils getTopPath];
    if ([subDir length] > 0){
        dir = [dir stringByAppendingPathComponent:subDir];
        
        // create dir once
        dispatch_once(&dirOnceToken, ^{
            [FileUtil createDir:dir];
        });
    }
    
    dir = [dir stringByAppendingPathComponent:finalName];
    PPDebug(@"smart data local data dir=%@", dir);
    return dir;
}


+ (NSString*)versionByName:(NSString*)name
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[PPSmartUpdateDataUtils dataVersionKeyByName:name]];
}

+ (void)storeVersionByName:(NSString*)name version:(NSString*)version
{
    if ([version length] == 0)
        return;
    
    PPDebug(@"<storeVersionByName> name=%@, version=%@", name, version);
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:[PPSmartUpdateDataUtils dataVersionKeyByName:name]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isDataExists:(NSString*)name subDir:(NSString*)subDir type:(PPSmartUpdateDataType)type
{
    NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:[PPSmartUpdateDataUtils dataVersionKeyByName:name]];
    NSString* path = [PPSmartUpdateDataUtils pathBySubDir:subDir name:name type:type];
    if ([version length] > 0 && [path length] > 0 && [FileUtil isPathExist:path]){
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isDataExists:(NSString*)name type:(PPSmartUpdateDataType)type
{
    NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:[PPSmartUpdateDataUtils dataVersionKeyByName:name]];
    NSString* path = [PPSmartUpdateDataUtils pathByName:name type:type];
    
    if ([version length] > 0 && [path length] > 0 && [FileUtil isPathExist:path]){
        return YES;
    }
    else{
        return NO;
    }
}

+ (NSString*)getFileUpdateDownloadPath:(NSString*)name
{
    return [[PPSmartUpdateDataUtils getDownloadTopPath] stringByAppendingPathComponent:name];
}

+ (NSString*)getFileUpdateDownloadTempPath:(NSString*)name
{
    return [[PPSmartUpdateDataUtils getDownloadTempTopPath] stringByAppendingPathComponent:name];
}


@end
