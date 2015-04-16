//
//  PPSmartUpdateData.m
//  Draw
//
//  Created by qqn_pipi on 12-11-29.
//
//

#import "PPSmartUpdateData.h"
#import "PPSmartUpdateDataUtils.h"
#import "FileUtil.h"
#import "SSZipArchive.h"
#import "ASIHTTPRequest.h"
#import "PPDebug.h"
#import "PPDataConstants.h"
#import "StringUtil.h"

#define SMART_DATA_RETRY_TIMES  10

@interface PPSmartUpdateData()
{
    
}

@end

@implementation PPSmartUpdateData

- (void)releaseBlocks
{
    self.downloadDataSuccessBlock = nil;
    self.downloadDataFailureBlock = nil;
}

- (void)dealloc
{
    self.queue = nil;
    [self releaseBlocks];
}

- (id)initWithName:(NSString*)name
              type:(PPSmartUpdateDataType)type
    originDataPath:(NSString*)originDataPath
   initDataVersion:(NSString*)initDataVersion
{
    return [self initWithName:name
                         type:type
               originDataPath:originDataPath
              initDataVersion:initDataVersion
                    serverURL:nil
                  localSubDir:nil];
}

- (id)initWithName:(NSString*)name
              type:(PPSmartUpdateDataType)type
      originDataPath:(NSString*)originDataPath
   initDataVersion:(NSString*)initDataVersion
         serverURL:(NSString*)serverURL
       localSubDir:(NSString*)localSubDir
{
    self = [super init];
    
    self.queue = dispatch_queue_create([name UTF8String], NULL);
    
    self.name = name;
    self.type = type;    
    
    self.originDataPath = originDataPath;
    self.serverURL = serverURL;
    self.localSubDir = localSubDir;
    
    // read whether there is data path or data version exist, if yes load it
    // otherwize load from init data path        
    if ([self isDataExist]){
        PPDebug(@"[%@] Init smart data %@ exists ", self.name, self.name);
        self.currentDataPath = [PPSmartUpdateDataUtils pathBySubDir:_localSubDir name:name type:type];
        self.currentVersion = [PPSmartUpdateDataUtils versionByName:name];

        // add by Benson 2013-06-28
        // check bundle version data, if it's higher, then also upgrade the data

//#ifdef DEBUG
//        [self processData:originDataPath dataVersion:initDataVersion];
//#endif
        
        if ([self hasUpdateVersion:initDataVersion]){
            [self processData:originDataPath dataVersion:initDataVersion];
        }
    }
    else{
        [self processData:originDataPath dataVersion:initDataVersion];
    }    
    
    return self;
}

- (id)initWithName:(NSString*)name
              type:(PPSmartUpdateDataType)type
        bundlePath:(NSString*)bundlePath
   initDataVersion:(NSString*)initDataVersion
{
    NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundlePath];
    return [self initWithName:name
                         type:type
               originDataPath:path
              initDataVersion:initDataVersion
                    serverURL:nil
                  localSubDir:nil];
}

// call this method to get data file path
- (NSString*)dataFilePath
{
    return _currentDataPath;
}

- (BOOL)isDataExist
{
    if ([self.localSubDir length] > 0){
        return [PPSmartUpdateDataUtils isDataExists:self.name subDir:self.localSubDir type:self.type];
    }
    else{
        return [PPSmartUpdateDataUtils isDataExists:self.name type:self.type];
    }
}

// call this method to download data
- (void)downloadData:(PPSmartDataFetchSuccessBlock)successBlock
        failureBlock:(PPSmartDataFetchFailureBlock)failureBlock
 downloadDataVersion:(NSString*)downloadDataVersion
{
    NSURL* url = [NSURL URLWithString:[self getFileDataUpdateURL]];
    if (_downloadHttpRequest == nil || [_downloadHttpRequest isFinished]){
        self.downloadHttpRequest = [ASIHTTPRequest requestWithURL:url];
    }
    
    if ([_downloadHttpRequest isExecuting]){
        return;
    }
    
    [self releaseBlocks];
    
    self.downloadDataVersion = downloadDataVersion;
    
    self.downloadDataFailureBlock = failureBlock;
    self.downloadDataSuccessBlock = successBlock;
    
    _downloadHttpRequest.delegate = self;
    [_downloadHttpRequest setAllowCompressedResponse:YES];
    [_downloadHttpRequest setUsername:DEFAULT_SMART_DATA_HTTP_USER_NAME];
    [_downloadHttpRequest setPassword:DEFAULT_SMART_DATA_HTTP_PASSWORD];
    
    NSString* destPath = [PPSmartUpdateDataUtils getFileUpdateDownloadPath:self.name];
    [_downloadHttpRequest setDownloadDestinationPath:destPath];
    
    NSString* tempPath = [PPSmartUpdateDataUtils getFileUpdateDownloadTempPath:self.name];
    [_downloadHttpRequest setTemporaryFileDownloadPath:tempPath];
    
    [_downloadHttpRequest setDownloadProgressDelegate:self];
    [_downloadHttpRequest setAllowResumeForFileDownloads:YES];
    [_downloadHttpRequest setNumberOfTimesToRetryOnTimeout:SMART_DATA_RETRY_TIMES];
    [_downloadHttpRequest setShouldAttemptPersistentConnection:NO];
    
    PPDebug(@"[%@] <downloadData> URL=%@, Local Temp=%@, Store At=%@",
            self.name, url.absoluteString, tempPath, destPath);
    
    [_downloadHttpRequest startAsynchronous];
}

- (NSString*)getVersionUpdateURL
{
    if (_serverURL == nil){
        NSString* defaultURL = [PPSmartUpdateDataUtils getVersionUpdateURL:self.name];
        PPDebug(@"<getVersionUpdateURL> defaultURL=%@", defaultURL);
        return defaultURL;
    }
    
    NSString* url = [PPSmartUpdateDataUtils getVersionURL:_serverURL name:self.name];
    PPDebug(@"<getVersionUpdateURL> url=%@", url);
    return url;
}

- (NSString*)getFileDataUpdateURL
{
    if (_serverURL == nil){
        NSString* defaultURL = [PPSmartUpdateDataUtils getFileUpdateURL:self.name];
        PPDebug(@"<getVersionUpdateURL> defaultURL=%@", defaultURL);
        return defaultURL;
    }
    
    NSString* url = [PPSmartUpdateDataUtils getDataURL:_serverURL name:self.name];
    PPDebug(@"<getVersionUpdateURL> url=%@", url);
    return url;
}


// call this method to check whether the data has updated version
- (void)checkHasUpdate:(PPSmartDataCheckUpdateSuccessBlock)successBlock failureBlock:(PPSmartDataFetchFailureBlock)failureBlock
{
    NSURL* url = [NSURL URLWithString:[self getVersionUpdateURL]];
    if (_checkVersionHttpRequest == nil || [_checkVersionHttpRequest isFinished]){
        self.checkVersionHttpRequest = [ASIHTTPRequest requestWithURL:url];
    }
    
    if ([_checkVersionHttpRequest isExecuting]){
        PPDebug(@"[%@] <checkHasUpdate> but it's executing", self.name);
        return;
    }
    
    [_checkVersionHttpRequest setAllowCompressedResponse:YES];
    [_checkVersionHttpRequest setUsername:DEFAULT_SMART_DATA_HTTP_USER_NAME];
    [_checkVersionHttpRequest setPassword:DEFAULT_SMART_DATA_HTTP_PASSWORD];
    
    [_checkVersionHttpRequest setTimeOutSeconds:8]; // 8 seconds for timeout
        
    PPDebug(@"[%@] <checkHasUpdate> URL=%@", self.name, url.absoluteString);
    
    dispatch_async(_queue, ^{
        [_checkVersionHttpRequest startSynchronous];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_checkVersionHttpRequest.responseStatusCode == 200){
                // success, check if has update
                NSString* newVersionString = _checkVersionHttpRequest.responseString;
                if ([self hasUpdateVersion:newVersionString]){
                    PPDebug(@"[%@] <checkHasUpdate> has new version = %@, current version=%@", self.name, newVersionString, self.currentVersion);
                    // has update
                    if (successBlock != NULL){
                        successBlock(YES, newVersionString);
                    }
                }
                else{
                    // no update
                    PPDebug(@"[%@] <checkHasUpdate> no new version = %@, current version = %@", self.name, newVersionString, self.currentVersion);
                    EXECUTE_BLOCK(successBlock, NO, nil);
                }
            }
            else{
                // failure, call failure block
                PPDebug(@"[%@] <checkHasUpdate> HTTP error, message=%@, url=%@, status=%d, error=%@",
                        self.name,
                        _checkVersionHttpRequest.responseStatusMessage, _checkVersionHttpRequest.url.absoluteString, _checkVersionHttpRequest.responseStatusCode, [_checkVersionHttpRequest.error description]);
                if (failureBlock != NULL){
                    failureBlock([NSError errorWithDomain:@"HTTP Error" code:_checkVersionHttpRequest.responseStatusCode userInfo:nil]);
                }
            }

            self.checkVersionHttpRequest = nil;
        });
    });

}


// call this method to check and update and auto download
- (void)checkUpdateAndDownload:(PPSmartDataFetchSuccessBlock)successBlock failureBlock:(PPSmartDataFetchFailureBlock)failureBlock
{
//    __block typeof(self) bself = self;    // when use "self" in block, must done like this
    [self checkHasUpdate:^(BOOL hasNewVersion, NSString *latestVersion) {
        if (hasNewVersion){
            [self downloadData:successBlock
                  failureBlock:failureBlock
           downloadDataVersion:latestVersion];
        }
        else{
            EXECUTE_BLOCK(successBlock, YES, self.currentDataPath);
        }
    } failureBlock:^(NSError *error) {
        EXECUTE_BLOCK(failureBlock, error);
    }];
}

- (BOOL)processData:(NSString*)sourceDataPath dataVersion:(NSString*)dataVersion
{
    PPDebug(@"[%@] <processData> path=%@, version=%@", self.name, sourceDataPath, dataVersion);
    if ([sourceDataPath length] == 0 || [dataVersion length] == 0 || [dataVersion isEqualToString:ZERO_VERSION]){
        PPDebug(@"[%@] <processData> start with empty file",self.name);
        self.currentVersion = @"0.0";
        self.currentDataPath = [PPSmartUpdateDataUtils pathBySubDir:_localSubDir name:self.name type:self.type];
        [PPSmartUpdateDataUtils storeVersionByName:self.name version:self.currentVersion];
        return NO;
    }
    
    NSString* destPath = [PPSmartUpdateDataUtils copyFilePathWithSubDir:_localSubDir name:self.name]; //[PPSmartUpdateDataUtils copyFilePathByName:self.name];
    NSError* error = nil;

//    BOOL hasUpdate = [self hasUpdateVersion:dataVersion];
//    if (hasUpdate == NO){
//        return YES;
//    }
//
//    // remove old file
//    [[NSFileManager defaultManager] removeItemAtPath:destPath
//                                               error:nil];
    
    [[NSFileManager defaultManager] removeItemAtPath:destPath error:nil];

    BOOL result = [[NSFileManager defaultManager] copyItemAtPath:sourceDataPath toPath:destPath error:&error];
    
    if ([error code] == 516){ // copy but file exist{
        // to avoid special case, reset result & error code here
        result = YES;
        error = nil;
    }
    
    if (result && error == nil){
         
        // copy success, check file type if it's zip file, then unzip the file
        if (self.type == SMART_UPDATE_DATA_TYPE_ZIP){
            NSString* unzipDir = [PPSmartUpdateDataUtils pathBySubDir:_localSubDir name:self.name type:self.type];
            result = [self unzipFileFromPath:destPath destDir:unzipDir deleteSource:YES];
        }
        
        // store data version and set data
        if (result){
            self.currentVersion = dataVersion;
            self.currentDataPath = [PPSmartUpdateDataUtils pathBySubDir:_localSubDir name:self.name type:self.type];
            [PPSmartUpdateDataUtils storeVersionByName:self.name version:self.currentVersion];
        }
    }
    else{
        
        if ([dataVersion length] == 0 || [dataVersion isEqualToString:ZERO_VERSION]){
            PPDebug(@"[%@] <processData> start with empty file",self.name);
            self.currentVersion = ZERO_VERSION;
            self.currentDataPath = [PPSmartUpdateDataUtils pathBySubDir:_localSubDir name:self.name type:self.type];
            [PPSmartUpdateDataUtils storeVersionByName:self.name version:self.currentVersion];
        }
        else{
            PPDebug(@"[%@] <processData> but copy file from %@ to %@ failure, error=%@, errorCode=%d",
                    self.name,
                    sourceDataPath, destPath, [error description], [error code]);
        }
    }
    
    return result;
}


- (BOOL)unzipFileFromPath:(NSString*)zipFilePath destDir:(NSString*)destDir deleteSource:(BOOL)deleteSource
{
//    NSString* zipFilePath = [PPResourceUtils getResourcePackageFilePath:self.name];
//    NSString* destDir = [PPResourceUtils getResourcePackageFileDataDir:self.name];
    
    BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:zipFilePath];
    if (!isFileExist){
        PPDebug(@"[%@] <unzipFileFromPath> zip file(%@) not exists", self.name, zipFilePath);
        return NO;
    }
    
    PPDebug(@"[%@] <unzipFileFromPath> start unzip %@", self.name, zipFilePath);
    BOOL result;
    if ([SSZipArchive unzipFileAtPath:zipFilePath
                        toDestination:destDir
                            overwrite:YES
                             password:nil
                                error:nil]) {
        PPDebug(@"[%@] <unzipFileFromPath> unzip %@ successfully", self.name, zipFilePath);
        result = YES;
        
        // remove MACOSX dir
        NSString* macZipTemp = [destDir stringByAppendingPathComponent:@"__MACOSX"];
        [FileUtil removeFile:macZipTemp];
        
    } else {
        PPDebug(@"[%@] <unzipFileFromPath> unzip %@ fail", self.name, zipFilePath);
        result = NO;
    }
    
    if (deleteSource){
        dispatch_async(_queue, ^{
            // delete files after it's unzip, if unzip failure, maybe the file is corrupted so we don't wait!
            [FileUtil removeFile:zipFilePath];
        });
    }
    
    return result;
}

- (BOOL)hasUpdateVersion:(NSString*)newVersion
{
    self.currentVersion = [self.currentVersion stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([self.currentVersion length] > 0 && [self.currentVersion isValidFloat] == NO){
        PPDebug(@"<hasUpdateVersion> but current version invalid %@", self.currentVersion);
        return YES;
    }

    newVersion = [newVersion stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([newVersion isValidFloat] == NO){
        PPDebug(@"<hasUpdateVersion> but new version invalid %@", newVersion);
        return NO;
    }
    
    if ([self.currentVersion isEqualToString:newVersion]){
        // same string
        return NO;
    }
    
    return ([newVersion doubleValue] - [self.currentVersion doubleValue]) > 0.0f;
}

#pragma mark - ASIHttpRequest Delegate

- (void)requestStarted:(ASIHTTPRequest *)request
{
    PPDebug(@"[%@] Download %@ requestStarted", self.name, self.name);
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    PPDebug(@"[%@] Download %@ didReceiveResponseHeaders", self.name, self.name);
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    PPDebug(@"[%@] Download %@ willRedirectToURL", self.name, self.name);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    PPDebug(@"[%@] Download %@ requestFinished, response status=%d", self.name, self.name, request.responseStatusCode);

    if (request.responseStatusCode != 200){
        if (_downloadDataFailureBlock != NULL){
            _downloadDataFailureBlock([NSError errorWithDomain:@"Download Data Status Code Error" code:request.responseStatusCode userInfo:nil]);
        }
        
        [self releaseBlocks];
        return;
    }
    
    NSString* destPath = [PPSmartUpdateDataUtils getFileUpdateDownloadPath:self.name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:destPath] == NO){
        PPDebug(@"[%@] <downloadData> finish but file(%@) not exist!", self.name, destPath);
        if (_downloadDataFailureBlock != NULL){
            _downloadDataFailureBlock([NSError errorWithDomain:@"Download Data Failure" code:SMART_DATA_PROCESS_ERROR userInfo:nil]);
        }
        
        [self releaseBlocks];
        return;
    }
    
    BOOL result = [self processData:destPath dataVersion:self.downloadDataVersion];
    
    // handle success
    if (result){
        if (_downloadDataSuccessBlock != NULL){
            _downloadDataSuccessBlock(NO, self.currentDataPath);
        }
    }
    else{
        if (_downloadDataFailureBlock != NULL){
            _downloadDataFailureBlock([NSError errorWithDomain:@"Process Data Failure" code:SMART_DATA_PROCESS_ERROR userInfo:nil]);
        }
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    PPDebug(@"[%@] Download %@ requestFailed, error=%@", self.name, self.name, [[request error] description]);
    
    // handle failure
    if (_downloadDataFailureBlock != NULL){
        _downloadDataFailureBlock([request error]);
    }
    
    [self releaseBlocks];
}

- (NSString*)progressNotificationName
{
    return [SMART_DATA_DOWNLOAD_NOTIFICATION stringByAppendingFormat:@"-%@", self.name];
}

#pragma mark - Download Delegate

- (void)setProgress:(float)newProgress
{
    PPDebug(@"[%@] Download %@ progress=%f", self.name, self.name, newProgress);
        
    NSDictionary* userInfo = @{ SMART_DATA_NAME : self.name,
                                SMART_DATA_PROGRESS : @(newProgress)
                                };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[self progressNotificationName]
                                                        object:nil
                                                      userInfo:userInfo];
}



@end
