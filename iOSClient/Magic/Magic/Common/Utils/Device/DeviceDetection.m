//
//  DeviceDetection.m
//  three20test
//
//  Created by qqn_pipi on 10-4-14.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "DeviceDetection.h"
#import <MessageUI/MessageUI.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>


static NSInteger deviceModel = MODEL_UNKNOWN;

@implementation DeviceDetection

+ (BOOL) isIPodTouch
{
	int model = [DeviceDetection detectDevice];
	if (model == MODEL_IPOD_TOUCH || model == MODEL_IPAD){
		//|| model == MODEL_IPHONE_SIMULATOR){
		return YES;
	}	
	else {
		return NO;
	}

}



+ (BOOL) isOS4
{
	// TBD
	
	return YES;
	
}

static BOOL _isIPAD;
static dispatch_once_t _isIPADOnceToken;

+ (BOOL) isIPAD
{
    dispatch_once(&_isIPADOnceToken, ^{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            deviceModel = MODEL_IPAD;
            _isIPAD = YES;
        }
        else{
            _isIPAD = NO;
        }
    });

    return _isIPAD;
}

+ (BOOL) isIPhone5
{
    //return ([[UIScreen mainScreen] bounds].size.height == 568);
    
//    return [self detectDevice] == MODEL_IPHONE_5G;
    return ([self detectDevice] == MODEL_IPHONE_5G)||([[UIScreen mainScreen] bounds].size.height == 568);
}
+ (BOOL) isIPhone4{
    return ([self detectDevice] == MODEL_IPHONE_4GS)||([[UIScreen mainScreen] bounds].size.height == 480);
}
+ (BOOL)isIOSX:(NSInteger)x
{
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    int ver_int = [ver intValue];
    if (ver_int >= x)
        return YES;
    else
        return NO;
}

static BOOL _isIOS5;

+ (BOOL)isOS5
{
    static dispatch_once_t isIOS5OnceToken;
    dispatch_once(&isIOS5OnceToken, ^{
        _isIOS5 = [self isIOSX:5];
    });
    return _isIOS5;
}

static BOOL _isIOS6;

+ (BOOL)isOS6
{
    static dispatch_once_t isIOS6OnceToken;
    dispatch_once(&isIOS6OnceToken, ^{
        _isIOS6 = [self isIOSX:6];
    });
    return _isIOS6;
}

static BOOL _isIOS7;

+ (BOOL) isOS7
{
    static dispatch_once_t isIOS7OnceToken;
    dispatch_once(&isIOS7OnceToken, ^{
        _isIOS7 = [self isIOSX:7];
    });
    return _isIOS7;
}

static BOOL _isIOS8;

+ (BOOL)isOS8
{
    static dispatch_once_t isIOS8OnceToken;
    dispatch_once(&isIOS8OnceToken, ^{
        _isIOS8 = [self isIOSX:8];
    });
    return _isIOS8;
}

+ (BOOL)canSendSms
{
	return [MFMessageComposeViewController canSendText];
}

+ (NSString *)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (BOOL)isRetinaDisplay
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00) {
        // RETINA DISPLAY
        return YES;
    }
    
    return NO;
}

+ (CGSize)screenSize
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return screenBounds.size;
}

+ (NSString*)deviceNameByModel:(NSString*)model {
    if ([model hasPrefix:@"iPhone"] || [model hasPrefix:@"iPod"] || [model hasPrefix:@"iPad"]){
        NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789, "];
        return [model stringByTrimmingCharactersInSet:set];
    }
    else{
        return model;
    }
}

+ (int) detectModel{
    NSString *platform = [DeviceDetection platform];
    return [self detectModelByString:platform];
}

+ (int) detectModelByString:(NSString*)platform{
    
	if ([platform isEqualToString:@"iPhone1,1"])    
		return MODEL_IPHONE;
    
	if ([platform isEqualToString:@"iPhone1,2"])    
		return MODEL_IPHONE_3G;
	
    if ([platform isEqualToString:@"iPhone2,1"])
		return MODEL_IPHONE_3GS;
	
    if ([platform isEqualToString:@"iPhone3,1"])    
		return MODEL_IPHONE_4G;
    
    if ([platform isEqualToString:@"iPhone4,1"]) {
        return MODEL_IPHONE_4GS;
    }
    
    if ([platform isEqualToString:@"iPhone5,1"]) {
        return MODEL_IPHONE_5G;
    }
	
    if ([platform isEqualToString:@"iPod1,1"])      
		return MODEL_IPOD_TOUCH;
	
    if ([platform isEqualToString:@"iPod2,1"])      
		return MODEL_IPOD_TOUCH_2G;
	
    if ([platform isEqualToString:@"iPod3,1"])      
		return MODEL_IPOD_TOUCH_3G;
	
    if ([platform isEqualToString:@"iPod4,1"])      
		return MODEL_IPOD_TOUCH_4G;
	
    if ([platform isEqualToString:@"iPad1,1"])      
		return MODEL_IPAD;
	
    if ([platform isEqualToString:@"i386"])         
		return MODEL_IPHONE_SIMULATOR;
	
    return MODEL_UNKNOWN;
}

static BOOL _isSimulator = NO;

+ (BOOL)isSimulator
{
    static dispatch_once_t simulatorOnceToken;
    dispatch_once(&simulatorOnceToken, ^{
        NSString *model= [[UIDevice currentDevice] model];
        if ([model rangeOfString:@"Simulator"].location != NSNotFound){
            _isSimulator = YES;
        }
        else{
            _isSimulator = NO;
        }
    });
    
    return _isSimulator;
}

+ (uint) detectDevice {
    NSString *model= [[UIDevice currentDevice] model];
	
    // Some iPod Touch return "iPod Touch", others just "iPod"
	
    NSString *iPodTouch = @"iPod Touch";
    NSString *iPodTouchLowerCase = @"iPod touch";
    NSString *iPodTouchShort = @"iPod";
	NSString *iPad = @"iPad";
	
    NSString *iPhoneSimulator = @"iPhone Simulator";
	
    uint detected = 0;
	
    if ([model compare:iPhoneSimulator] == NSOrderedSame) {
        // iPhone simulator
        detected = MODEL_IPHONE_SIMULATOR;
	}
	else if ([model compare:iPad] == NSOrderedSame) {
		// iPad
		detected = MODEL_IPAD;
	} else if ([model compare:iPodTouch] == NSOrderedSame) {
		// iPod Touch
		detected = MODEL_IPOD_TOUCH;
    } else if ([model compare:iPodTouchLowerCase] == NSOrderedSame) {
        // iPod Touch
        detected = MODEL_IPOD_TOUCH;
    } else if ([model compare:iPodTouchShort] == NSOrderedSame) {
        // iPod Touch
        detected = MODEL_IPOD_TOUCH;
    } else {
        // Could be an iPhone V1 or iPhone 3G (model should be "iPhone")
        struct utsname u;
		
        // u.machine could be "i386" for the simulator, "iPod1,1" on iPod Touch, "iPhone1,1" on iPhone V1 & "iPhone1,2" on iPhone3G
		
        uname(&u);
		
        if (!strcmp(u.machine, "iPhone1,1")) {
            detected = MODEL_IPHONE;
        } else if (!strcmp(u.machine, "iPhone1,2")){
            detected = MODEL_IPHONE_3G;
        } else if (!strcmp(u.machine, "iPhone2,1")){
            detected = MODEL_IPHONE_3GS;
        } else if (!strcmp(u.machine, "iPhone3,1")){
            detected = MODEL_IPHONE_4G;
        } else if (!strcmp(u.machine, "iPhone4,1")){
            detected = MODEL_IPHONE_4GS;
        } else if (!strcmp(u.machine, "iPhone5,1")){
            detected = MODEL_IPHONE_5G;
        }
    }
    return detected;
}

+ (NSString *) returnDeviceName:(BOOL)ignoreSimulator {
    NSString *returnValue = @"Unknown";
	
    switch ([DeviceDetection detectDevice]) {
        case MODEL_IPHONE_SIMULATOR:
            if (ignoreSimulator) {
                returnValue = @"iPhone 3G";
            } else {
                returnValue = @"iPhone Simulator";
            }
            break;
        case MODEL_IPOD_TOUCH:
            returnValue = @"iPod Touch";
            break;
        case MODEL_IPHONE:
            returnValue = @"iPhone";
            break;
        case MODEL_IPHONE_3G:
            returnValue = @"iPhone 3G";
            break;
        default:
            break;
    }
	
    return returnValue;
}

+ (NSString *)deviceOS
{
    return [NSString stringWithFormat:@"%@_%@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];    
}

+ (DeviceType)deviceType
{
    return  [DeviceDetection isIPAD] ?  DeviceTypeIPad :  DeviceTypeIPhone;

}

static int _deviceScreenType;
static NSString* _deviceScreenTypeString;

+ (DeviceScreenType)deviceScreenType
{
    static dispatch_once_t onceTokenDeviceScreenType;
    dispatch_once(&onceTokenDeviceScreenType, ^{
        UIScreen* screen = [UIScreen mainScreen];
        CGSize size = [screen bounds].size;
        if (size.height == 1024){
            // iPad
            if (screen.scale == 1.0f){
                _deviceScreenType = DEVICE_SCREEN_IPAD;
            }
            else{
                _deviceScreenType = DEVICE_SCREEN_NEW_IPAD;
            }
        }
        else if (size.height == 480){
            // iPhone
            _deviceScreenType = DEVICE_SCREEN_IPHONE;
        }
        else if (size.height == 568){
            // iPhone5
            _deviceScreenType = DEVICE_SCREEN_IPHONE5;
        }
        else{
            _deviceScreenType = DEVICE_SCREEN_IPHONE;
        }
    });

    return _deviceScreenType;
}

+ (NSString*)deviceScreenTypeString
{
    static dispatch_once_t onceTokenDeviceScreenTypeString;
    dispatch_once(&onceTokenDeviceScreenTypeString, ^{
        switch ([DeviceDetection deviceScreenType]){
            case DEVICE_SCREEN_IPAD:
                _deviceScreenTypeString = @"ipad";
                break;
            case DEVICE_SCREEN_IPHONE:
                _deviceScreenTypeString = @"iphone";
                break;
            case DEVICE_SCREEN_IPHONE5:
                _deviceScreenTypeString = @"iphone5";
                break;
            case DEVICE_SCREEN_NEW_IPAD:
                _deviceScreenTypeString = @"new_ipad";
                break;
            default:
                _deviceScreenTypeString = @"iphone";
                break;

        }
        
    });
    
    return _deviceScreenTypeString;
}

+ (NSUInteger)freeMemory
{
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t     vm_stat;
    
    host_page_size(host_port, &pagesize);
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) NSLog(@"Failed to fetch vm statistics");
    
//    natural_t   mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    NSUInteger   mem_free = vm_stat.free_count * pagesize;
//    natural_t   mem_total = mem_used + mem_free;
    
    return mem_free;
}

+ (NSUInteger)totalMemory
{
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t     vm_stat;
    
    host_page_size(host_port, &pagesize);
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) NSLog(@"Failed to fetch vm statistics");
    
    NSUInteger   mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    NSUInteger   mem_free = vm_stat.free_count * pagesize;
    NSUInteger   mem_total = mem_used + mem_free;
    
    return mem_total;
}

@end