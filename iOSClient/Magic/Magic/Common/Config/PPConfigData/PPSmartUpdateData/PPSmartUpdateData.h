//
//  PPSmartUpdateData.h
//  Draw
//
//  Created by qqn_pipi on 12-11-29.
//
//


/*
 
 Usage Guide
 
 
 Step 1: Init Paths
 
 [PPSmartUpdateDataUtils initPaths];
 
 Step 2: Create a Smart Data Object
 
 _smartData = [[PPSmartUpdateData alloc] initWithName:WORD_BASE_ZIP_NAME
 type:SMART_UPDATE_DATA_TYPE_ZIP
 originDataPath:bundlePath
 initDataVersion:[version stringValue]
 isAutoDownload:YES];
 
 Step 3: Call CheckHasUpdate Method when you need 
 
 [_smartData checkHasUpdate:^(BOOL hasNewVersion, NSString *latestVersion) {
 if (hasNewVersion){
 [_smartData downloadData:^(BOOL isAlreadyExisted, NSString *dataFilePath) {
 } failureBlock:^(NSError *error) {
 } downloadDataVersion:latestVersion];
 }
 } failureBlock:^(NSError *error) {
 
 }];
 
*/

#import <Foundation/Foundation.h>

typedef void(^PPSmartDataFetchSuccessBlock)(BOOL isAlreadyExisted, NSString* dataFilePath);
typedef void(^PPSmartDataCheckUpdateSuccessBlock)(BOOL hasNewVersion, NSString* latestVersion);
typedef void(^PPSmartDataFetchFailureBlock)(NSError *error);

typedef enum {
    SMART_UPDATE_DATA_TYPE_ZIP,
    SMART_UPDATE_DATA_TYPE_PB,
    SMART_UPDATE_DATA_TYPE_TXT
} PPSmartUpdateDataType;

#define SMART_DATA_DOWNLOAD_NOTIFICATION    @"SMART_DATA_DOWNLOAD_NOTIFICATION"
#define SMART_DATA_NAME                     @"SMART_DATA_NAME"
#define SMART_DATA_PROGRESS                 @"SMART_DATA_PROGRESS"

#define ZERO_VERSION                        @"0.0"

@class ASIHTTPRequest;

@interface PPSmartUpdateData : NSObject

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) PPSmartUpdateDataType type;
@property (nonatomic, retain) NSString* currentVersion;     // record current version
@property (nonatomic, retain) NSString* currentDataPath;    // current file data path
@property (nonatomic, retain) NSString* serverURL;          // remote file server URL
@property (nonatomic, retain) NSString* localSubDir;          // remote file server URL


@property (nonatomic, retain) NSString* originDataPath;       // init data path

@property (nonatomic, retain) NSString* latestVersion;      // record the latest version in server, need to read from server

@property (nonatomic, assign) BOOL isAutoDownload;          // decide whether to auto download file after detecting new version

@property (nonatomic, retain) ASIHTTPRequest* checkVersionHttpRequest;      // record the latest version in server, need to read from server
@property (nonatomic, retain) ASIHTTPRequest* downloadHttpRequest;      // record the latest version in server, need to read from server

@property (nonatomic, copy) PPSmartDataFetchSuccessBlock  downloadDataSuccessBlock;
@property (nonatomic, copy) PPSmartDataFetchFailureBlock  downloadDataFailureBlock;
@property (nonatomic, retain) NSString*                     downloadDataVersion;      

- (id)initWithName:(NSString*)name
              type:(PPSmartUpdateDataType)type
      originDataPath:(NSString*)originDataPath
   initDataVersion:(NSString*)initDataVersion;

- (id)initWithName:(NSString*)name
              type:(PPSmartUpdateDataType)type
        bundlePath:(NSString*)bundlePath
   initDataVersion:(NSString*)initDataVersion;

- (id)initWithName:(NSString*)name
              type:(PPSmartUpdateDataType)type
    originDataPath:(NSString*)originDataPath
   initDataVersion:(NSString*)initDataVersion
         serverURL:(NSString*)serverURL
       localSubDir:(NSString*)localSubDir;


// call this method to get data file path
- (NSString*)dataFilePath;

// call this method to download data
- (void)downloadData:(PPSmartDataFetchSuccessBlock)successBlock
        failureBlock:(PPSmartDataFetchFailureBlock)failureBlock
 downloadDataVersion:(NSString*)downloadDataVersion;

// call this method to check whether the data has updated version
- (void)checkHasUpdate:(PPSmartDataCheckUpdateSuccessBlock)successBlock failureBlock:(PPSmartDataFetchFailureBlock)failureBlock;

// call this method to check and update and auto download
- (void)checkUpdateAndDownload:(PPSmartDataFetchSuccessBlock)successBlock failureBlock:(PPSmartDataFetchFailureBlock)failureBlock;

// used for register progress notification
- (NSString*)progressNotificationName;

// 是否数据存在
- (BOOL)isDataExist;

@end
