//
//  BarrageNetworkRequest.h
//  Draw
//
//  Created by qqn_pipi on 13-6-9.
//
//

#import <Foundation/Foundation.h>
//#import "GameConstants.pb.h"
//#import "GameBasic.pb.h"
//#import "GameMessage.pb.h"
//#import "AlixPayOrder.h"
#import "Message.pb.h"
#import "PPNetworkRequest.h"
#import "BarrageNetworkRequest.h"
#import "GameNetworkConstants.h"

#import "BarrageConfigManager.h"

#define METHOD_BARRAGE          @"req"

typedef void (^ PBResponseResultBlock) (PBDataResponse *response, NSError* error);

@interface GameNetworkOutput : CommonNetworkOutput

@property (nonatomic, retain) PBDataResponse* pbResponse;

@end

@interface BarrageNetworkRequest : NSObject

//+ (GameNetworkOutput*)apiServerGetAndResponseJSON:(NSString *)method
//                                       parameters:(NSDictionary *)parameters
//                                    isReturnArray:(BOOL)isReturnArray;
//
//+ (GameNetworkOutput*)apiServerGetAndResponsePB:(NSString *)method
//                                     parameters:(NSDictionary *)parameters;
//
//+ (GameNetworkOutput*)apiServerPostAndResponseJSON:(NSString *)method
//                                        parameters:(NSDictionary *)parameters
//                                          postData:(NSData*)postData
//                                     isReturnArray:(BOOL)isReturnArray;
//
//+ (GameNetworkOutput*)apiServerPostAndResponsePB:(NSString *)method
//                                      parameters:(NSDictionary *)parameters
//                                        postData:(NSData*)postData;
//
//// TRAFFIC API SERVER, GET REQUEST
//+ (GameNetworkOutput*)trafficApiServerGetAndResponseJSON:(NSString *)method
//                                              parameters:(NSDictionary *)parameters
//                                           isReturnArray:(BOOL)isReturnArray;
//
//
//+ (GameNetworkOutput*)trafficApiServerGetAndResponsePB:(NSString *)method
//                                            parameters:(NSDictionary *)parameters;
//
//
//// TRAFFIC API SERVER, POST REQUEST
//+ (GameNetworkOutput*)trafficApiServerPostAndResponseJSON:(NSString *)method
//                                               parameters:(NSDictionary *)parameters
//                                                 postData:(NSData*)postData
//                                            isReturnArray:(BOOL)isReturnArray;

+ (void)post:(NSString *)method
         url:(NSString*)url
       queue:(dispatch_queue_t)queue
     request:(PBDataRequest*)request
    callback:(PBResponseResultBlock)callback
 isPostError:(BOOL)isPostError;

+ (void)testPost;

// TRAFFIC API SERVER, POST+UPLOAD REQUEST
//+ (GameNetworkOutput*)trafficApiServerUploadAndResponsePB:(NSString *)method
//                                               parameters:(NSDictionary *)parameters
//                                            imageDataDict:(NSDictionary *)imageDict
//                                             postDataDict:(NSDictionary *)dataDict
//                                         progressDelegate:(id)progressDelegate;

//+ (GameNetworkOutput*)sendGetRequestWithBaseURL:(NSString*)baseURL
//                                         method:(NSString *)method
//                                     parameters:(NSDictionary *)parameters
//                                       returnPB:(BOOL)returnPB
//                                returnJSONArray:(BOOL)returnJSONArray;

//+ (void)loadPBData:(dispatch_queue_t)queue
//           hostURL:(NSString*)hostURL
//            method:(NSString *)method
//        parameters:(NSDictionary *)parameters
//          callback:(PBResponseResultBlock)callback
//       isPostError:(BOOL)isPostError;
//
//+ (void)loadPBData:(dispatch_queue_t)queue
//           hostURL:(NSString*)hostURL
//            method:(NSString *)method
//          postData:(NSData *)postData
//        parameters:(NSDictionary *)parameters
//          callback:(PBResponseResultBlock)callback
//       isPostError:(BOOL)isPostError;


@end
