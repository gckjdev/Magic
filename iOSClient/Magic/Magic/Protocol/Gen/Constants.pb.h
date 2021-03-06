// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import <ProtocolBuffers/ProtocolBuffers.h>

// @@protoc_insertion_point(imports)

#ifndef __has_feature
  #define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif // __has_feature

#ifndef NS_RETURNS_NOT_RETAINED
  #if __has_feature(attribute_ns_returns_not_retained)
    #define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
  #else
    #define NS_RETURNS_NOT_RETAINED
  #endif
#endif

typedef NS_ENUM(SInt32, PBDeviceType) {
  PBDeviceTypeDeviceTypeIphone = 0,
  PBDeviceTypeDeviceTypeAndroid = 1,
  PBDeviceTypeDeviceTypeWindow = 2,
};

BOOL PBDeviceTypeIsValidValue(PBDeviceType value);
NSString *NSStringFromPBDeviceType(PBDeviceType value);

typedef NS_ENUM(SInt32, PBFeedType) {
  PBFeedTypeFeedImageText = 0,
};

BOOL PBFeedTypeIsValidValue(PBFeedType value);
NSString *NSStringFromPBFeedType(PBFeedType value);

typedef NS_ENUM(SInt32, PBFeedActionType) {
  PBFeedActionTypeActionBarrageText = 0,
};

BOOL PBFeedActionTypeIsValidValue(PBFeedActionType value);
NSString *NSStringFromPBFeedActionType(PBFeedActionType value);


@interface ConstantsRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end


// @@protoc_insertion_point(global_scope)
