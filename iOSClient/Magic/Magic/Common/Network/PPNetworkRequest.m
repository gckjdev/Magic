//
//  PPNetworkRequest.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PPNetworkRequest.h"
#import "StringUtil.h"
#import "JSON.h"
#import "PPNetworkConstants.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "LogUtil.h"
#import "UIUtils.h"

//static int networkMessageLogTag;
//static dispatch_once_t networkMessageLogTagOnceToken;


@implementation CommonNetworkOutput

@synthesize resultMessage, resultCode, jsonDataArray, jsonDataDict, textData, arrayData;
@synthesize responseData;

- (void)resultFromJSON:(NSString*)jsonString
{
	// get code and message
	NSDictionary* dict = [jsonString JSONValue];		
	self.resultCode = [[dict objectForKey:@"ret"] intValue];				
    //	self.resultMessage = [dict objectForKey:@"msg"];		
}

- (NSArray*)arrayFromJSON:(NSString*)jsonString
{
	// get array data from data object (if it's an array)
	NSDictionary* dict = [jsonString JSONValue];
	NSArray* retArray = [dict objectForKey:@"dat"];
	
	return retArray;
}

- (NSDictionary*)dictionaryDataFromJSON:(NSString*)jsonString
{
	// get array data from data object (if it's an array)
	NSDictionary* dict = [jsonString JSONValue];
	NSDictionary* retDict = [dict objectForKey:@"dat"];
	
	return retDict;
}


@end

@implementation PPNetworkRequest

#define UPLOAD_TIMEOUT  (120)       // 120 seconds

+ (CommonNetworkOutput*)uploadRequest:(NSString *)baseURL 
                           uploadData:(NSData*)uploadData
                constructURLHandler:(ConstructURLBlock)constructURLHandler 
                    responseHandler:(PPNetworkResponseBlock)responseHandler 
                             output:(CommonNetworkOutput *)output
{
    NSString* logTag = [NSString stringWithFormat:@"%010ld-%02d", time(0), rand() % 100];
    
    if (baseURL == nil || constructURLHandler == NULL || responseHandler == NULL){
        PPDebug(@"<sendRequest> failure because baseURL = nil || constructURLHandler = NULL || responseHandler = NULL");
        return nil;
    }
    
    NSString* urlString = [PPNetworkRequest appendTimeStampAndMacToURL:constructURLHandler(baseURL) shareKey:SHARE_KEY];
    
//    NSURL* url = [NSURL URLWithString:[urlString stringByURLEncode]];    
    NSURL* url = [NSURL URLWithString:urlString];
    if (url == nil){
        PPDebug(@"<sendRequest> fail to construct URL");
        output.resultCode = ERROR_CLIENT_URL_NULL;
        return output;
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setAllowCompressedResponse:YES];
    [request setTimeOutSeconds:UPLOAD_TIMEOUT];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request setShouldAttemptPersistentConnection:NO];
    
    [request setData:uploadData withFileName:@"pp" andContentType:@"image/jpeg" forKey:@"photo"];
      
    time_t startTime = time(0);
    PPDebug(@"[SEND][%@] UPLOAD DATA URL=%@", logTag, [url description]);
    
    [request startSynchronous];
    
    NSError *error = [request error];
    int statusCode = [request responseStatusCode];
    
    PPDebug(@"[RECV][%@] HTTP status=%d, error=%@", logTag, [request responseStatusCode], [error description]);
    
    if (error != nil){
        output.resultCode = ERROR_NETWORK;
    }
    else if (statusCode != 200){
        output.resultCode = statusCode;
    }
    else{
        NSString *text = [request responseString];
        
        time_t endTime = time(0);
        PPDebug(@"[RECV][%@] data statistic (len=%d bytes, latency=%d seconds, raw=%d bytes, real=%d bytes)",
                logTag,
              [text length], (endTime - startTime),
              [[request rawResponseData] length], [[request responseData] length]);
        
        PPDebug(@"[RECV][%@] data = %@", logTag, [request responseString]);
        
        NSDictionary* dataDict = [text JSONValue];
        if (dataDict == nil){
            output.resultCode = ERROR_CLIENT_PARSE_JSON;
            return output;
        }
        
        output.resultCode = [[dataDict objectForKey:RET_CODE] intValue];
        responseHandler(dataDict, output);
        
        return output;
    }
    
    return output;
    
}

+ (CommonNetworkOutput*)uploadRequest:(NSString *)baseURL
                        imageDataDict:(NSDictionary *)imageDataDict
                         postDataDict:(NSDictionary *)postDataDict
                  constructURLHandler:(ConstructURLBlock)constructURLHandler
                      responseHandler:(PPNetworkResponseBlock)responseHandler
                               output:(CommonNetworkOutput *)output
{
    return [PPNetworkRequest uploadRequest:baseURL
                             imageDataDict:imageDataDict
                              postDataDict:postDataDict
                       constructURLHandler:constructURLHandler
                           responseHandler:responseHandler
                                    output:output
                          progressDelegate:nil];
}

+ (CommonNetworkOutput*)uploadRequest:(NSString *)baseURL
                        imageDataDict:(NSDictionary *)imageDataDict
                         postDataDict:(NSDictionary *)postDataDict
                  constructURLHandler:(ConstructURLBlock)constructURLHandler
                      responseHandler:(PPNetworkResponseBlock)responseHandler
                         outputFormat:(int)outputFormat
                               output:(CommonNetworkOutput *)output
{
    return [PPNetworkRequest uploadRequest:baseURL
                             imageDataDict:imageDataDict
                              postDataDict:postDataDict
                       constructURLHandler:constructURLHandler
                           responseHandler:responseHandler
                              outputFormat:outputFormat
                                    output:output
                          progressDelegate:nil];
}

+ (CommonNetworkOutput*)uploadRequest:(NSString *)baseURL
                        imageDataDict:(NSDictionary *)imageDataDict
                         postDataDict:(NSDictionary *)postDataDict
                  constructURLHandler:(ConstructURLBlock)constructURLHandler
                      responseHandler:(PPNetworkResponseBlock)responseHandler
                               output:(CommonNetworkOutput *)output
                     progressDelegate:(id)progressDelegate

{
    NSString* logTag = [NSString stringWithFormat:@"%010ld-%02d", time(0), rand() % 100];
    
    if (baseURL == nil || constructURLHandler == NULL || responseHandler == NULL){
        PPDebug(@"<sendRequest> failure because baseURL = nil || constructURLHandler = NULL || responseHandler = NULL");
        return nil;
    }
    
    NSString* urlString = [PPNetworkRequest appendTimeStampAndMacToURL:constructURLHandler(baseURL) shareKey:SHARE_KEY];
    
//    NSURL* url = [NSURL URLWithString:[urlString stringByURLEncode]];
    NSURL* url = [NSURL URLWithString:urlString];
    if (url == nil){
        PPDebug(@"<sendRequest> fail to construct URL");
        output.resultCode = ERROR_CLIENT_URL_NULL;
        return output;
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setAllowCompressedResponse:YES];
    [request setTimeOutSeconds:UPLOAD_TIMEOUT];
    [request setUploadProgressDelegate:progressDelegate];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request setShouldAttemptPersistentConnection:NO];    
    
    if ([imageDataDict count] != 0) {
        for (NSString *key in [imageDataDict allKeys]) {
            NSData *data = [imageDataDict objectForKey:key];
            [request setData:data withFileName:@"pp" andContentType:@"image/jpeg" forKey:key];
        }
    }

    if ([postDataDict count] != 0) {
        for (NSString *key in [postDataDict allKeys]) {
            NSData *data = [postDataDict objectForKey:key];
            [request addData:data forKey:key];
        }
    }
    
    time_t startTime = time(0);
    PPDebug(@"[SEND][%@] UPLOAD DATA URL=%@", logTag, [url description]);
    
    [request startSynchronous];
    
    NSError *error = [request error];
    int statusCode = [request responseStatusCode];
    
    PPDebug(@"[RECV][%@] HTTP status=%d, error=%@", logTag, [request responseStatusCode], [error description]);
    
    if (error != nil){
        output.resultCode = ERROR_NETWORK;
    }
    else if (statusCode != 200){
        output.resultCode = statusCode;
    }
    else{
        NSString *text = [request responseString];
        
        time_t endTime = time(0);
        PPDebug(@"[RECV][%@] data statistic (len=%d bytes, latency=%d seconds, raw=%d bytes, real=%d bytes)",
                logTag,
                [text length], (endTime - startTime),
                [[request rawResponseData] length], [[request responseData] length]);
        
        PPDebug(@"[RECV][%@] data = %@", logTag, [request responseString]);
        
        NSDictionary* dataDict = [text JSONValue];
        if (dataDict == nil){
            output.resultCode = ERROR_CLIENT_PARSE_JSON;
            return output;
        }
        
        output.resultCode = [[dataDict objectForKey:RET_CODE] intValue];
        responseHandler(dataDict, output);
        
        return output;
    }
    
    return output;
    
}

+ (CommonNetworkOutput*)uploadRequest:(NSString *)baseURL
                        imageDataDict:(NSDictionary *)imageDataDict
                         postDataDict:(NSDictionary *)postDataDict
                  constructURLHandler:(ConstructURLBlock)constructURLHandler
                      responseHandler:(PPNetworkResponseBlock)responseHandler
                         outputFormat:(int)outputFormat
                               output:(CommonNetworkOutput *)output
                     progressDelegate:(id)progressDelegate

{
    NSString* logTag = [NSString stringWithFormat:@"%010ld-%02d", time(0), rand() % 100];
    
    if (baseURL == nil || constructURLHandler == NULL || responseHandler == NULL){
        PPDebug(@"<sendRequest> failure because baseURL = nil || constructURLHandler = NULL || responseHandler = NULL");
        return nil;
    }
    
    NSString* urlString = [PPNetworkRequest appendTimeStampAndMacToURL:constructURLHandler(baseURL) shareKey:SHARE_KEY];
    
//    NSURL* url = [NSURL URLWithString:[urlString stringByURLEncode]];
    NSURL* url = [NSURL URLWithString:urlString];
    if (url == nil){
        PPDebug(@"<sendRequest> fail to construct URL");
        output.resultCode = ERROR_CLIENT_URL_NULL;
        return output;
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setAllowCompressedResponse:YES];
    [request setTimeOutSeconds:UPLOAD_TIMEOUT];
    [request setUploadProgressDelegate:progressDelegate];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request setShouldAttemptPersistentConnection:NO];    
    
    if ([imageDataDict count] != 0) {
        for (NSString *key in [imageDataDict allKeys]) {
            NSData *data = [imageDataDict objectForKey:key];
            [request setData:data withFileName:@"pp" andContentType:@"image/jpeg" forKey:key];
        }
    }
    
    if ([postDataDict count] != 0) {
        for (NSString *key in [postDataDict allKeys]) {
            NSData *data = [postDataDict objectForKey:key];
            [request addData:data forKey:key];
        }
    }
    
    time_t startTime = time(0);
    PPDebug(@"[SEND][%@] UPLOAD DATA URL=%@", logTag, [url description]);
    
    [request startSynchronous];
    
    NSError *error = [request error];
    int statusCode = [request responseStatusCode];
    
    PPDebug(@"[RECV][%@] HTTP status=%d, error=%@", logTag, [request responseStatusCode], [error description]);
    
    if (error != nil){
        output.resultCode = ERROR_NETWORK;
    }
    else if (statusCode != 200){
        output.resultCode = statusCode;
    }
    else{
        NSString *text = [request responseString];
        
        time_t endTime = time(0);
        PPDebug(@"[RECV][%@] data statistic (len=%d bytes, latency=%d seconds, raw=%d bytes, real=%d bytes)",
                logTag,
                [text length], (endTime - startTime),
                [[request rawResponseData] length], [[request responseData] length]);
        
        PPDebug(@"[RECV][%@] data = %@", logTag, [request responseString]);
        
        if (outputFormat == FORMAT_PB){
            output.responseData = [request responseData];
            responseHandler(nil, output);
        }else{
            NSDictionary* dataDict = [text JSONValue];
            if (dataDict == nil){
                output.resultCode = ERROR_CLIENT_PARSE_JSON;
                return output;
            }
            
            output.resultCode = [[dataDict objectForKey:RET_CODE] intValue];
            responseHandler(dataDict, output);
        }
        
        return output;
    }
    
    return output;
    
}


+ (NSString*)appendTimeStampAndMacToURL:(NSString*)url shareKey:(NSString*)shareKey
{
	NSString* retUrl = url;
	
	NSString* dateString = [NSString stringWithInt:[[NSDate date] timeIntervalSince1970]];
	NSString* macString = [dateString encodeMD5Base64:shareKey];
	
	retUrl = [retUrl stringByAddQueryParameter:PARA_TIMESTAMP value:dateString];
	retUrl = [retUrl stringByAddQueryParameter:PARA_MAC value:macString];
    retUrl = [retUrl stringByAddQueryParameter:PARA_VERSION value:[UIUtils getAppVersion]];     // add by Benson 2013-08-08
    
	return retUrl;
}


+ (CommonNetworkOutput*)sendRequest:(NSString*)baseURL
                constructURLHandler:(ConstructURLBlock)constructURLHandler
                    responseHandler:(PPNetworkResponseBlock)responseHandler
                       outputFormat:(int)outputFormat
                             output:(CommonNetworkOutput*)output
{
    NSString* logTag = [NSString stringWithFormat:@"%010ld-%02d", time(0), rand() % 100];
    
    if (baseURL == nil || constructURLHandler == NULL || responseHandler == NULL){
        PPDebug(@"<sendRequest> failure because baseURL = nil || constructURLHandler = NULL || responseHandler = NULL");
        return nil;
    }
    
    NSString* urlString = [PPNetworkRequest appendTimeStampAndMacToURL:constructURLHandler(baseURL) shareKey:SHARE_KEY];
    
    NSURL* url = [NSURL URLWithString:urlString];
    if (url == nil){
        PPDebug(@"<sendRequest> fail to construct URL");
        output.resultCode = ERROR_CLIENT_URL_NULL;
        return output;
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setAllowCompressedResponse:YES];
    [request setTimeOutSeconds:NETWORK_TIMEOUT];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request setShouldAttemptPersistentConnection:NO];
    
    time_t startTime = time(0);
    PPDebug(@"[SEND][%@] URL=%@", logTag, [url description]);
    
    [request startSynchronous];
    
    NSError *error = [request error];
    int statusCode = [request responseStatusCode];
    
    PPDebug(@"[RECV][%@] HTTP status=%d, error=%@", logTag, [request responseStatusCode], [error description]);
    
    if (error != nil){
        output.resultCode = ERROR_NETWORK;
    }
    else if (statusCode != 200){
        if (statusCode == 0){
            statusCode = ERROR_NETWORK;
        }        
        output.resultCode = statusCode;
    }
    else{
        
        time_t endTime = time(0);

        if (outputFormat == FORMAT_PB){
            PPDebug(@"[RECV][%@] data statistic (len=%d bytes, latency=%d seconds, raw=%d bytes, real=%d bytes)",
                    logTag,
                    [[request responseData] length], (endTime - startTime),
                    [[request rawResponseData] length], [[request responseData] length]);
            output.responseData = [request responseData];
            responseHandler(nil, output);
        }
        else{
            
            NSStringEncoding encoding = NSUTF8StringEncoding;        
            NSString *text = [[NSString alloc] initWithData:[request responseData] encoding:encoding];
            PPDebug(@"[RECV][%@] data statistic (len=%d bytes, latency=%d seconds, raw=%d bytes, real=%d bytes)", logTag,
                    [text length], (endTime - startTime),
                    [[request rawResponseData] length], [[request responseData] length]);
            PPDebug(@"[RECV][%@] data = %@", logTag, [request responseString]);
            NSDictionary* dataDict = [text JSONValue];
            if (dataDict == nil){
                output.resultCode = ERROR_CLIENT_PARSE_JSON;
                return output;
            }
            
            output.resultCode = [[dataDict objectForKey:RET_CODE] intValue];
            responseHandler(dataDict, output);
        }
        
        return output;
    }
    
    return output;
}


+ (CommonNetworkOutput*)sendPostRequest:(NSString*)baseURL
                                   data:(NSData*)data
                    constructURLHandler:(ConstructURLBlock)constructURLHandler
                        responseHandler:(PPNetworkResponseBlock)responseHandler
                           outputFormat:(int)outputFormat
                                 output:(CommonNetworkOutput*)output
{
    NSString* logTag = [NSString stringWithFormat:@"%010ld-%02d", time(0), rand() % 100];    
    
    if (baseURL == nil || constructURLHandler == NULL || responseHandler == NULL){
        PPDebug(@"<sendPostRequest> failure because baseURL = nil || constructURLHandler = NULL || responseHandler = NULL");
        return nil;
    }
    
    NSString* urlString = [PPNetworkRequest appendTimeStampAndMacToURL:constructURLHandler(baseURL) shareKey:SHARE_KEY];
    
//    NSURL* url = [NSURL URLWithString:[urlString stringByURLEncode]];
    NSURL* url = [NSURL URLWithString:urlString];
    if (url == nil){
        PPDebug(@"<sendPostRequest> fail to construct URL");
        output.resultCode = ERROR_CLIENT_URL_NULL;
        return output;
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setAllowCompressedResponse:YES];
    [request setTimeOutSeconds:NETWORK_TIMEOUT];
    [request setRequestMethod:@"POST"];
    [request appendPostData:data];                  // to be tested
    [request setPostLength:[data length]];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request setShouldAttemptPersistentConnection:NO];
    
    PPDebug(@"[SEND][%@] Post Data=%@ Length=%d", logTag, [data description], [data length]);
    
    NSInteger startTime = time(0);
    PPDebug(@"[SEND][%@] URL=%@", logTag, [url description]);
    
    //
    [request startSynchronous];
    
    NSError *error = [request error];
    int statusCode = [request responseStatusCode];
    
    PPDebug(@"[RECV][%@] HTTP status=%d, error=%@", logTag, [request responseStatusCode], [error description]);
    
    if (error != nil){
        output.resultCode = ERROR_NETWORK;
    }
    else if (statusCode != 200){
        if (statusCode == 0){
            statusCode = ERROR_NETWORK;
        }        
        output.resultCode = statusCode;
    }
    else{
        NSString *text = [request responseString];
        
        NSInteger endTime = time(0);
        PPDebug(@"[RECV][%@] data statistic (len=%d bytes, latency=%d seconds, raw=%d bytes, real=%d bytes)",
                logTag,
                [text length], (endTime - startTime),
                [[request rawResponseData] length], [[request responseData] length]);
        
        PPDebug(@"[RECV][%@] data = %@", logTag, [request responseString]);
        
        if (outputFormat == FORMAT_PB){
            output.responseData = [request responseData];
            responseHandler(nil, output);
        }
        else{
            NSDictionary* dataDict = [text JSONValue];
            if (dataDict == nil){
                output.resultCode = ERROR_CLIENT_PARSE_JSON;
                return output;
            }
            
            output.resultCode = [[dataDict objectForKey:RET_CODE] intValue];
            responseHandler(dataDict, output);
        }
        
        return output;
    }
    
    return output;
}


+ (CommonNetworkOutput*)sendRequest:(NSString*)baseURL
                constructURLHandler:(ConstructURLBlock)constructURLHandler
                    responseHandler:(PPNetworkResponseBlock)responseHandler
                             output:(CommonNetworkOutput*)output
{    
    return [PPNetworkRequest sendRequest:baseURL 
                     constructURLHandler:constructURLHandler 
                         responseHandler:responseHandler
                            outputFormat:FORMAT_JSON 
                                  output:output];
}

@end
