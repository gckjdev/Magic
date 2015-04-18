//
//  StringUtil.h
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-10.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <UIKit/UIKit.h>

#define kHappyFace		@"\ue415"
#define kUnhappyFace	@"\ue058"

@interface NSString (NSStringUtil)

+ (NSString *)stringWithInt:(int)value;
+ (NSString *)GetUUID;
- (NSNumber *)toNumber;

// format : "yyyy-MM-dd HH:mm:ss"
+(NSString *)getCurrentTime;

- (NSString *)phoneNumberFilter;
- (NSString *)phoneNumberFilter2;

// example : "peng@163.com; hello@126.com, tom@tom.com"
- (NSArray *)emailStringToArray;
- (NSString *)stringByURLEncode;
- (NSString *)pinyinFirstLetter;

- (NSString *)stringByAddQueryParameter:(NSString*)parameter value:(NSString*)value;
- (NSString *)stringByAddQueryParameter:(NSString*)parameter boolValue:(BOOL)value;
- (NSString *)stringByAddQueryParameter:(NSString*)parameter intValue:(int)value;
- (NSString *)stringByAddQueryParameter:(NSString*)parameter longValue:(int)value;
- (NSString *)stringByAddQueryParameter:(NSString*)parameter doubleValue:(double)value;

- (NSString *)stringByAddQueryParameterWithoutEncode:(NSString*)parameter
                                               value:(NSString*)value;

+ (NSString*)formatPhone:(NSString*)phone countryTelPrefix:(NSString*)countryTelPrefix;

- (NSString*)insertHappyFace;
- (NSString*)insertUnhappyFace;

- (NSString*)encodeMD5Base64:(NSString*)key;

- (NSString*)encode3DESBase64:(NSString*)key;
- (NSString*)decodeBase643DES:(NSString*)key;

+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key;

- (NSString *)encodedURLParameterString;

- (NSString*) decodeURLString;

- (NSMutableDictionary *)URLQueryStringToDictionary;

+ (NSString*)floatToStringWithoutZeroTail:(float)floatValue;

- (BOOL)isMobileInChina;

- (NSString*)UTF8_To_GB2312;

- (BOOL)isEqualToString:(NSString *)aString ignoreCapital:(BOOL)ignoreCapital;

- (BOOL)isOnlyNumberAndLetter;

// malloc a string and return it, you need to call free to dealloc it directly
- (char*)copyToCString;

- (NSString *)stringByRepeateTime:(int)count;

- (BOOL)isBlank;
- (NSString *)stringByTrimmingBlankCharactersAtBothEnds;

- (NSString *)toTraditionalChinese;

- (NSString *)formatNumber;

- (BOOL)isValidFloat;
- (BOOL)isEnglishString;

- (CGSize)sizeWithMyFont:(UIFont*)fontToUse;

- (CGSize)sizeWithMyFont:(UIFont*)font
       constrainedToSize:(CGSize)constrainedSize
           lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end

extern BOOL NSStringIsValidEmail(NSString *checkString);
extern BOOL NSStringIsValidPhone(NSString *checkString);    //  判断手机号码是否正确，只是判断是否是数字
extern BOOL NSStringIsValidMobile(NSString *checkString);  //  使用正则表达式判断手机号码是否正确
extern BOOL NSStringIsValidChinese(NSString *checkString);
extern BOOL NSStringISValidEnglish(NSString *checkString);

extern NSString *NSStringFromCGFloat(CGFloat value);
extern NSString *NSStringFromNSInteger(NSInteger value);

extern NSString* pinyinStringFirstLetter(unsigned short hanzi);
