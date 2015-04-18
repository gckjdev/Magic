//
//  StringUtil.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-10.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "StringUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
#import "pinyin.h"

NSString* pinyinStringFirstLetter(unsigned short hanzi)
{
	char c = pinyinFirstLetter(hanzi);
	return [NSString stringWithFormat:@"%c", c];
}

BOOL NSStringIsValidEmail(NSString *checkString)
{
	BOOL sticterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
	
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = sticterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:checkString];
}
 //  判断手机号码是否正确，只是判断是否是数字
BOOL NSStringIsValidPhone(NSString *checkString)
{
	NSString *regex = @"[\\+0-9]+";
	NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [test evaluateWithObject:checkString];
}
//  使用正则表达式判断手机号码是否正确
BOOL NSStringIsValidMobile(NSString *checkString)
{
    /**
     * 手机号码
     * 移动：134,135,136,137,138,139,150,151,152,157,158,159,182,187,188
     * 联通：130,131,132,155,156,185,186
     * 电信：133,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if (([regextestmobile evaluateWithObject:checkString] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

BOOL NSStringIsValidChinese(NSString *checkString)
{
	NSString* regex = @"[\u4e00-\u9fa5]+";
	NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [test evaluateWithObject:checkString];
}

BOOL NSStringISValidEnglish(NSString* checkString)
{
    NSString* regex = @"[[A-Za-z]]+";
	NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [test evaluateWithObject:checkString];
}

@implementation NSString (NSStringUtil)

- (NSString *)stringByRepeateTime:(int)count{
    if (self == nil || count < 1) {
        return nil;
    }
    
    NSString *temp = self;
    NSString *ret = self;
    for (int i = 0; i < count - 1; i++) {
        ret = [ret stringByAppendingString:temp];
    }
    
    return ret;
}

- (NSString *)pinyinFirstLetter
{
	if ([self length] > 0){
		return pinyinStringFirstLetter([self characterAtIndex:0]);
	}
	else {
		return @"";
	}
}

+ (NSString *)stringWithInt:(int)value
{
	return [NSString stringWithFormat:@"%d", value];
}

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString* retStr = (__bridge_transfer NSString *)string;
    return [[retStr stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}


+(NSString *)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

// filter " ", "+", "(", ")", "-"
- (NSString *)phoneNumberFilter
{
	NSString* str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"+" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];	
	return str;
}

- (NSString *)phoneNumberFilter2
{
	// performance can be improved later
	NSString* str = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];	
	return str;
}

- (NSNumber *)toNumber
{
	return [NSNumber numberWithInt:[self intValue]];
}



- (NSArray *)emailStringToArray
{	
	NSString* str = [NSString stringWithString:self];
	
	// remove space and line break
	str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		   
	// return by ; or , or space
	NSCharacterSet* charSet = [NSCharacterSet characterSetWithCharactersInString:@",; "];
	NSArray* emailArray = [str componentsSeparatedByCharactersInSet:charSet];
	
	NSMutableArray* retArray = [[NSMutableArray alloc] init];
	for (NSString* str in emailArray){
		NSString* email = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if (email && [email length] > 0){
			[retArray addObject:email];
		}
	}
	
	return retArray;
}

- (NSString *)stringByURLEncode
{
	NSMutableString* escaped = [NSMutableString stringWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];       
	[escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
//	[escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
	
	return escaped;
}

- (NSString *)encodedURLParameterString 
{
    NSString*result = (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR(":/=,!$&'()*+;[]@#?"),
                                                                           kCFStringEncodingUTF8);
	return result;
}

- (NSString*) decodeURLString
{
    NSString* result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                         ( CFStringRef) self,
                                                                                         CFSTR(":/=,!$&'()*+;[]@#?"),
                                                                                         kCFStringEncodingUTF8);
    
    NSString *result1 = [result stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return result1;
}


- (NSString *)stringByAddQueryParameter:(NSString*)parameter value:(NSString*)value
{
	NSString* p = parameter;
	NSString* v = [value encodedURLParameterString];
	if (p == nil)
		p = @"";
	if (v == nil)
		v = @"";
	
	return [self stringByAppendingFormat:@"&%@=%@", p, v];
}

- (NSString *)stringByAddQueryParameterWithoutEncode:(NSString*)parameter
                                               value:(NSString*)value
{
	NSString* p = parameter;    
	NSString* v = value;
	if (p == nil)
		p = @"";
	if (v == nil)
		v = @"";
	
	return [self stringByAppendingFormat:@"&%@=%@", p, v];
}



- (NSString *)stringByAddQueryParameter:(NSString*)parameter boolValue:(BOOL)value
{
	NSString* p = parameter;
	if (p == nil)
		p = @"";
	
	return [self stringByAppendingFormat:@"&%@=%d", p, value];
}

- (BOOL)isBlank{
    NSString *trimedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimedString length] == 0) {
        return true;
    } else {
        return false;
    }
}

- (NSString *)stringByTrimmingBlankCharactersAtBothEnds{
    NSString *trimedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimedString;
}



#define CTSLS(X) NSLocalizedStringFromTable(X, @"TraditionalChineseWord", nil)


- (NSString *)toTraditionalChinese;
{
    NSString *ret = nil;
    for (int i = 0; i < self.length; ++ i) {
        NSString *sub = [self substringWithRange:NSMakeRange(i, 1)];
        sub = CTSLS(sub);
        ret = [NSString stringWithFormat:@"%@%@",ret,sub];
    }
    return ret;
}

- (NSString *)stringByAddQueryParameter:(NSString*)parameter intValue:(int)value
{
	NSString* p = parameter;
	if (p == nil)
		p = @"";
	
	return [self stringByAppendingFormat:@"&%@=%d", p, value];
}

- (NSString *)stringByAddQueryParameter:(NSString*)parameter longValue:(int)value
{
	NSString* p = parameter;
	if (p == nil)
		p = @"";
	
	return [self stringByAppendingFormat:@"&%@=%d", p, value];
}


- (NSString *)stringByAddQueryParameter:(NSString*)parameter doubleValue:(double)value
{
	NSString* p = parameter;
	if (p == nil)
		p = @"";
	
	return [self stringByAppendingFormat:@"&%@=%f", p, value];
}

+ (NSString*)formatPhone:(NSString*)phone countryTelPrefix:(NSString*)countryTelPrefix
{
	NSString* retPhone = [NSString stringWithString:phone];
	
	retPhone = [retPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
	retPhone = [retPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
	retPhone = [retPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
	retPhone = [retPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	if ([retPhone hasPrefix:countryTelPrefix])
		return retPhone;
	
	if ([retPhone hasPrefix:@"+"])
		return retPhone;
	
	NSString* retPhonePlus = [NSString stringWithFormat:@"+%@", retPhone];
	if ([retPhonePlus hasPrefix:countryTelPrefix])
		return retPhonePlus;
	
	return [NSString stringWithFormat:@"%@%@", countryTelPrefix, retPhone];
}

- (NSString*)insertHappyFace
{
	return [kHappyFace stringByAppendingFormat:@" %@", self];
}

- (NSString*)insertUnhappyFace
{
	return [kUnhappyFace stringByAppendingFormat:@" %@", self];
}

- (NSString*)encode3DESBase64:(NSString*)key
{
	return [NSString TripleDES:self encryptOrDecrypt:kCCEncrypt key:key];
}

- (NSString*)decodeBase643DES:(NSString*)key
{
	return [NSString TripleDES:self encryptOrDecrypt:kCCDecrypt key:key];	
}

- (NSString*)encodeMD5Base64:(NSString*)key
{
	NSString* input = [NSString stringWithFormat:@"%@%@", self, key];	
	const char *cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
	
	return [GTMBase64 stringByEncodingBytes:result length:CC_MD5_DIGEST_LENGTH];
}

+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key {
	
//	NSString* req = @"234234234234234中国";
//	NSString* rsp = nil;
//	NSString* key = @"888fdafdakfjak;";
//	
//	NSString* ret1 = [NSString TripleDES:req encryptOrDecrypt:kCCEncrypt key:key];		
//	NSLog(@"3DES/Base64 Encode Result=%@", ret1);
//	
//	NSString* ret2 = [NSString TripleDES:ret1 encryptOrDecrypt:kCCDecrypt key:key];
//	NSLog(@"3DES/Base64 Decode Result=%@", ret2);
	
	
	const void *vplainText;
	size_t plainTextBufferSize;
	
	if (encryptOrDecrypt == kCCDecrypt)
	{
		NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
		plainTextBufferSize = [EncryptData length];
		vplainText = [EncryptData bytes];
	}
	else
	{
		NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
		plainTextBufferSize = [data length];
		vplainText = (const void *)[data bytes];
	}
	
	CCCryptorStatus ccStatus;
	uint8_t *bufferPtr = NULL;
	size_t bufferPtrSize = 0;
	size_t movedBytes = 0;
	// uint8_t ivkCCBlockSize3DES;
	
	bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
	bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
	memset((void *)bufferPtr, 0x0, bufferPtrSize);
	// memset((void *) iv, 0x0, (size_t) sizeof(iv));
	
	//	NSString *key = @"123456789012345678901234";
	NSString *initVec = @"init Vec";
	const void *vkey = (const void *) [key UTF8String];
	const void *vinitVec = (const void *) [initVec UTF8String];
	
	ccStatus = CCCrypt(encryptOrDecrypt,
					   kCCAlgorithm3DES,
					   kCCOptionPKCS7Padding,
					   vkey, //"123456789012345678901234", //key
					   kCCKeySize3DES,
					   vinitVec, //"init Vec", //iv,
					   vplainText, //"Your Name", //plainText,
					   plainTextBufferSize,
					   (void *)bufferPtr,
					   bufferPtrSize,
					   &movedBytes);
    
	
    
    if (ccStatus == kCCParamError)
    {
        free(bufferPtr);
        return @"PARAM ERROR";
    }
	else if (ccStatus == kCCBufferTooSmall)
    {
        free(bufferPtr);
        return @"BUFFER TOO SMALL";
    }
	else if (ccStatus == kCCMemoryFailure)
    {
        free(bufferPtr);
        return @"MEMORY FAILURE";
    }
    else if (ccStatus == kCCAlignmentError) {
        free(bufferPtr);
        return @"ALIGNMENT";
    }
    else if (ccStatus == kCCDecodeError) {
        free(bufferPtr);
        return @"DECODE ERROR";
    }
    else if (ccStatus == kCCUnimplemented) {
        free(bufferPtr);
        return @"UNIMPLEMENTED";
    }
	
	NSString *result;
	
	if (encryptOrDecrypt == kCCDecrypt)
	{
		result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
																length:(NSUInteger)movedBytes] 
										encoding:NSUTF8StringEncoding];
	}
	else
	{
		NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
		result = [GTMBase64 stringByEncodingData:myData];
	}
	
    free(bufferPtr);
	return result;
	
} 

- (BOOL)isMobileInChina
{
	if ([self length] != 11)
		return NO;
	else if ([self hasPrefix:@"13"] ||
			 [self hasPrefix:@"15"] ||
			 [self hasPrefix:@"16"] ||
			 [self hasPrefix:@"18"])
		return YES;
	else {
		return NO;
	}
}

- (NSMutableDictionary *)URLQueryStringToDictionary
{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    if (pairs == nil || [pairs count] == 0)
        return nil;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for(NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        if([keyValue count] == 2) {
            NSString *key = [keyValue objectAtIndex:0];
            NSString *value = [keyValue objectAtIndex:1];
            [dict setObject:value forKey:key];
        }
    }    
    
    return dict;
}

+ (NSString*)floatToStringWithoutZeroTail:(float)floatValue
{
    NSString* stringFloat = [NSString stringWithFormat:@"%f",floatValue];
    const char* floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength  = 0;
    NSInteger i = length-1;
    
    for(; i >= 0; i--)
    {
        if(floatChars[i] == '0')
            zeroLength++;
        else
        {
            if(floatChars[i] =='.')
                i--;
            break;
        }  
    }
    
    NSString* returnString;
    
    if(i == -1)
        returnString  = @"0";  
    else 
        returnString = [stringFloat substringToIndex:i+1]; 
    return returnString;
}

- (NSString*)UTF8_To_GB2312
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* gb2312data = [self dataUsingEncoding:encoding];
    return [[NSString alloc] initWithData:gb2312data encoding:encoding];
}

- (BOOL)isEqualToString:(NSString *)aString ignoreCapital:(BOOL)ignoreCapital
{
    if (ignoreCapital) {
        return [[self uppercaseString] isEqualToString:[aString uppercaseString]];
    }
    return [self isEqualToString:aString];
}

- (BOOL)isOnlyNumberAndLetter
{
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm"] invertedSet];
    NSRange foundRange = [self rangeOfCharacterFromSet:disallowedCharacters];
    if (foundRange.location != NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)isValidFloat
{
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSRange foundRange = [self rangeOfCharacterFromSet:disallowedCharacters];
    if (foundRange.location == NSNotFound) {
        return YES;
    }
    else{
        return NO;
    }
}

// malloc a string and return it, you need to call free to dealloc it directly
- (char*)copyToCString
{
    const char* cstring = [self UTF8String];
    if (cstring != NULL){
        NSInteger len = strlen(cstring);
        char* destCString = malloc(len+1);
        memset(destCString, 0, len+1);
        strncpy(destCString, cstring, len);
        return destCString;
    }
    else{
        return NULL;
    }
}

extern NSString *NSStringFromCGFloat(CGFloat value)
{
    return [NSString stringWithFormat:@"%f", value];
}

extern NSString *NSStringFromNSInteger(NSInteger value)
{
    return [NSString stringWithFormat:@"%ld", value];
}

- (NSString*)formatNumber
{
    int minLen = 3;
    if ([self length] < minLen){
        return self;
    }
    
    NSString* first3 = [self substringToIndex:minLen];
    NSString* left = [self substringFromIndex:minLen];
    
    return [NSString stringWithFormat:@"%@ %@", first3, left];
}

#define IS_EN_SYMBOL(chr) ((chr<='z')&&(chr>='a') || (chr<='Z')&&(chr>='A'))
- (BOOL)isEnglishString{

    for (int index = 0; index < [self length]; index ++) {
        unichar ch = [self characterAtIndex:index];        
        if (!IS_EN_SYMBOL(ch)) {
            return NO;
        }
    }
    
    return YES;
}

- (CGSize)sizeWithMyFont:(UIFont*)fontToUse
{
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary* attribs = @{NSFontAttributeName:fontToUse};
        CGSize size = [self sizeWithAttributes:attribs];
        return CGSizeMake(ceilf(size.width), ceilf(size.height));
    }
    else{
        return CGSizeZero;
//        return ([self sizeWithFont:fontToUse]);
    }
}

- (CGSize)sizeWithMyFont:(UIFont*)font
       constrainedToSize:(CGSize)constrainedSize
           lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size = CGSizeZero;
    
    if ([self respondsToSelector: @selector(boundingRectWithSize:options:attributes:context:)] == YES) {
        size = [self boundingRectWithSize: constrainedSize
                                  options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                               attributes: @{ NSFontAttributeName: font }
                                  context: nil].size;
        
        if (size.height > constrainedSize.height){
            size.height = constrainedSize.height;
        }
        
        return CGSizeMake(ceilf(size.width), ceilf(size.height));
    } else {
        
        return CGSizeZero;
        
//        size = [self sizeWithFont:font
//                constrainedToSize:constrainedSize
//                    lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return size;
}

@end
	
