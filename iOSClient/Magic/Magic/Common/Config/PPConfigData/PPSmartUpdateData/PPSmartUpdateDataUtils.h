//
//  PPSmartUpdateDataUtils.h
//  Draw
//
//  Created by qqn_pipi on 12-11-29.
//
//

#import <Foundation/Foundation.h>
#import "PPSmartUpdateData.h"
#import "PPDataConstants.h"
#import "PPDebug.h"

@interface PPSmartUpdateDataUtils : NSObject

//+ (NSString*)copyFilePathByName:(NSString*)name;
//+ (NSString*)pathByName:(NSString*)name type:(PPSmartUpdateDataType)type;
+ (NSString*)copyFilePathWithSubDir:(NSString*)subDir name:(NSString*)name;
+ (NSString*)versionByName:(NSString*)name;
+ (void)storeVersionByName:(NSString*)name version:(NSString*)version;

+ (BOOL)isDataExists:(NSString*)name type:(PPSmartUpdateDataType)type;
+ (BOOL)isDataExists:(NSString*)name subDir:(NSString*)subDir type:(PPSmartUpdateDataType)type;

+ (NSString*)getVersionUpdateURL:(NSString*)name;
+ (NSString*)getVersionFileName:(NSString*)name;
+ (NSString*)getFileUpdateURL:(NSString*)name;

+ (NSString*)getDataURL:(NSString*)serverURL name:(NSString*)name;
+ (NSString*)getVersionURL:(NSString*)serverURL name:(NSString*)name;

+ (NSString*)getFileUpdateDownloadPath:(NSString*)name;
+ (NSString*)getFileUpdateDownloadTempPath:(NSString*)name;

+ (NSString*)pathBySubDir:(NSString*)subDir name:(NSString*)name type:(PPSmartUpdateDataType)type;

+ (void)initPaths;

@end
