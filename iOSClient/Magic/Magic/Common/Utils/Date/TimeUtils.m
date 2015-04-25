//
//  TimeUtils.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-6.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "TimeUtils.h"
#import "LocaleUtils.h"

NSArray *weekDays = nil; 
NSArray *weekDays2 = nil;

static NSArray *getWeekDayArray()
{
    if(weekDays == nil)
    {
        weekDays = [[NSArray alloc]initWithObjects: @"星期日", @"星期一", @"星期二",
                      @"星期三",@"星期四",@"星期五",@"星期六", nil];
    }
    return weekDays;
}

static NSArray *getWeekDay2Array()
{
    if(weekDays2 == nil)
    {
        weekDays2 = [[NSArray alloc]initWithObjects: @"周日", @"周一", @"周二",
                    @"周三",@"周四",@"周五",@"周六", nil];
    }
    return weekDays2;
}

NSDateFormatter *dateFormatter = nil;
static NSDateFormatter *getDateFormatter()
{
    @synchronized(dateFormatter){
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
        }
        return dateFormatter;
    }
}

// return YEAR, MONTH, DAY in NSDateComponents by given NSDate
NSDateComponents *getDateComponents(NSDate *date)
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];	
	return comps;
}

static NSDateComponents *getChineseDateComponents(NSDate *date)
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];	
	return comps;
}

static NSDateComponents *getLocalDateComponents(NSDate *date)
{
	NSCalendar *calendar = [NSCalendar currentCalendar];	
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
	NSDateComponents *comps = [calendar components:unitFlags fromDate:date];	
	return comps;
}

// return whether given date and today is the same day
BOOL isToday(NSDate *date)
{
    if (date == nil) {
        return NO;
    }
    
	// Get Today's YYYY-MM-DD
	NSDateComponents *today_comps = getDateComponents([NSDate date]);
	
	// Given Date's YYYY-MM-DD
	NSDateComponents *select_comps = getDateComponents(date);		
	
	// if it's today, return TODAY
	if ( [today_comps year] == [select_comps year] &&
		[today_comps month] == [select_comps month] &&
		[today_comps day] == [select_comps day]){		
		return YES;
	}
	else {
		return NO;
	}

}

// return whether given date and today is the same day
BOOL isLocalToday(NSDate *date)
{
	// Get Today's YYYY-MM-DD
	NSDateComponents *today_comps = getLocalDateComponents([NSDate date]);
	
	// Given Date's YYYY-MM-DD
	NSDateComponents *select_comps = getLocalDateComponents(date);		
	
	// if it's today, return TODAY
	if ( [today_comps year] == [select_comps year] &&
		[today_comps month] == [select_comps month] &&
		[today_comps day] == [select_comps day]){		
		return YES;
	}
	else {
		return NO;
	}
}

BOOL isYesterday(NSDate *date){
    // Get Today's YYYY-MM-DD
    NSDateComponents *today_comps = getChineseDateComponents([NSDate date]);
    
    // Given Date's YYYY-MM-DD
    NSDateComponents *select_comps = getChineseDateComponents(date);
    
    // if it's today, return TODAY
    if ( [today_comps year] == [select_comps year] &&
        [today_comps month] == [select_comps month]&&
        ([today_comps day] - [select_comps day] == 1)){
        return YES;
    }
    else {
        return NO;
    }
}


BOOL isTheDayBeforeYesterday(NSDate *date)
{
    // Get Today's YYYY-MM-DD
    NSDateComponents *today_comps = getChineseDateComponents([NSDate date]);
    
    // Given Date's YYYY-MM-DD
    NSDateComponents *select_comps = getChineseDateComponents(date);
    
    // if it's today, return TODAY
    if ( [today_comps year] == [select_comps year] &&
        [today_comps month] == [select_comps month]&&
        ([today_comps day] - [select_comps day] == 2)){
        return YES;
    }
    else {
        return NO;
    }
}

BOOL isThisYear(NSDate *date)
{
    // Get Today's YYYY-MM-DD
    NSDateComponents *today_comps = getChineseDateComponents([NSDate date]);
    
    // Given Date's YYYY-MM-DD
    NSDateComponents *select_comps = getChineseDateComponents(date);
    
    // if it's today, return TODAY
    if ( [today_comps year] == [select_comps year]){
        return YES;
    }
    else {
        return NO;
    }
}

// return whether given date and today is the same day
BOOL isLocalDay(NSDate *date, int interval)
{
	// Get Today's YYYY-MM-DD
	NSDateComponents *today_comps = getLocalDateComponents([NSDate date]);
	
	// Given Date's YYYY-MM-DD
	NSDateComponents *select_comps = getLocalDateComponents(date);
	
	// if it's today, return TODAY
	if ( [today_comps year] == [select_comps year] &&
		[today_comps month] == [select_comps month] &&
		[today_comps day] == ([select_comps day] + 1)){
		return YES;
	}
	else {
		return NO;
	}
}

BOOL isChineseToday(NSDate *date)
{
	// Get Today's YYYY-MM-DD
	NSDateComponents *today_comps = getChineseDateComponents([NSDate date]);
	
	// Given Date's YYYY-MM-DD
	NSDateComponents *select_comps = getChineseDateComponents(date);		
	
	// if it's today, return TODAY
	if ( [today_comps year] == [select_comps year] &&
		[today_comps month] == [select_comps month] &&
		[today_comps day] == [select_comps day]){		
		return YES;
	}
	else {
		return NO;
	}
    
}



NSString *dateToLocaleStringWithFormat(NSDate *date, NSString* format)
{
	NSDateFormatter *dateFormatter = getDateFormatter(); //[[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    if (format != nil) {
        [dateFormatter setDateFormat:format];
    }
    
	NSLocale *locale = [NSLocale currentLocale];
	[dateFormatter setLocale:locale];
    NSTimeZone *tzGMT = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:tzGMT];

    //	NSLog(@"Date string for locale %@: %@",
    //		  [[dateFormatter locale] localeIdentifier], [dateFormatter stringFromDate:date]);
    
	return [dateFormatter stringFromDate:date];
    
}

// covert date to string by given locale
NSString *dateToLocaleString(NSDate *date)
{
    //	NSDateFormatter *dateFormatter = getDateFormatter(); //[[[NSDateFormatter alloc] init] autorelease];
    //	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    //	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //
    //	NSLocale *locale = [NSLocale currentLocale];
    //	[dateFormatter setLocale:locale];
    ////	NSLog(@"Date string for locale %@: %@",
    ////		  [[dateFormatter locale] localeIdentifier], [dateFormatter stringFromDate:date]);
    //
    //	return [dateFormatter stringFromDate:date];
    return dateToLocaleStringWithFormat(date, nil);
    
}

// convert date to string in YYYY-MM-DD format
//NSString *dateToString(NSDate *date)
//{
//	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//	
//	[dateFormatter setDateFormat:@"YYYY-MM-DD"];
//	return [dateFormatter stringFromDate:date];	
//}

NSString *dateToChineseString(NSDate *date)
{
    if(date == nil)
        return nil;
	NSDateFormatter *dateFormatter = getDateFormatter(); //[[[NSDateFormatter alloc] init] autorelease];
    
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:TIME_ZONE_GMT];
    [dateFormatter setTimeZone:tzGMT];
    [dateFormatter setDateFormat:DATE_CHINESE_FORMAT];
    NSString *period = [dateFormatter stringFromDate:date];
    return period;
}

NSString *dateToChineseStringByFormat(NSDate *date, NSString *format)
{
    if(date == nil)
        return nil;
	NSDateFormatter *formatter = getDateFormatter(); //[[[NSDateFormatter alloc] init] autorelease];
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:TIME_ZONE_GMT];
    [formatter setTimeZone:tzGMT];
    [formatter setDateFormat:format];
    NSString *period = [formatter stringFromDate:date];
    return period;
}

NSString *dateToString(NSDate *date)
{
    if(date == nil)
        return nil;
	NSDateFormatter *formatter = getDateFormatter(); //[[[NSDateFormatter alloc] init] autorelease];
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:TIME_ZONE_GMT];
    [formatter setTimeZone:tzGMT];
    [formatter setDateFormat:DATE_FORMAT];
    NSString *period = [formatter stringFromDate:date];
    return period;
}



// covert date to string by given format
NSString *dateToStringByFormat(NSDate *date, NSString *format)
{
    if(date == nil)
        return nil;
	NSDateFormatter *formatter = getDateFormatter(); //[[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:format];
	return [formatter stringFromDate:date];	
}



NSString *dateToUTCStringByFormat(NSDate *date, NSString *format)
{
	NSDateFormatter *formatter = getDateFormatter(); //[[[NSDateFormatter alloc] init] autorelease];
	
	[formatter setDateFormat:format];
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	
	return [formatter stringFromDate:date];		
}

// convert string to date by given format
NSDate *dateFromStringByFormat(NSString *string, NSString *format)
{
	NSDateFormatter *formatter = getDateFormatter(); //[[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:format];
	
	return [formatter dateFromString:string];	
	
}
	 
// convert string to date by given format
NSDate *dateFromUTCStringByFormat(NSString *string, NSString *format)
{
	if (string == nil)
		return nil;
	
	NSDateFormatter *formatter = getDateFormatter(); //[[[NSDateFormatter alloc] init] autorelease];
	 
	[formatter setDateFormat:format];
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	 
	return [formatter dateFromString:string];	
	 
}

// convert string to date by given format
NSDate *dateFromChineseStringByFormat(NSString *string, NSString *format)
{
	if (string == nil || [string length] == 0)
		return nil;
	
	NSDateFormatter *formatter = getDateFormatter(); //[[[NSDateFormatter alloc] init] autorelease];
    
	[formatter setDateFormat:format];
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:TIME_ZONE_GMT]];
	return [formatter dateFromString:string];	    
    
}


// convert GMT to BeiJing time(GMT+8)
NSString *GMTToBeiJingTime(NSString* gmt,NSString *dateFormat)
{
    NSDateFormatter *inDateFormatter = [[NSDateFormatter alloc] init];
    inDateFormatter.dateFormat = dateFormat;
    inDateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDate *inDate = [inDateFormatter dateFromString:gmt];
    
    // about output date(BeiJing)
    NSDateFormatter *outDateFormatter = [[NSDateFormatter alloc] init];
    outDateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+8"];
    outDateFormatter.dateFormat = dateFormat;
    NSString *outDateStr = [outDateFormatter stringFromDate:inDate];
    return outDateStr;
}

// return start date time of the day
NSDate *getDateStart(NSDate* date)
{
	NSDateComponents* comp = getDateComponents(date);
	
	NSDateFormatter *formatter = getDateFormatter(); //[[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 00:00:00",
							[comp year], [comp month], [comp day]];
	
	return [formatter dateFromString:dateString];
	
}

// return end date time of the day
NSDate *getDateEnd(NSDate* date)
{
	NSDateComponents* comp = getDateComponents(date);
	
	NSDateFormatter *formatter = getDateFormatter(); //[[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 23:59:59",
							[comp year], [comp month], [comp day]];
	
	return [formatter dateFromString:dateString];	
}

// next date of given date
NSDate *nextDate(NSDate *date)
{
	return [[NSDate alloc] initWithTimeInterval:24*3600 sinceDate:date];
}

// previous date of given date
NSDate *previousDate(NSDate *date)
{
	return [[NSDate alloc] initWithTimeInterval:-24*3600 sinceDate:date];
	
}

NSDate *nextNDate(NSDate *date, NSInteger days)
{
	return [[NSDate alloc] initWithTimeInterval:24*3600*days sinceDate:date];
	
}

NSString *chineseWeekDayFromDate(NSDate *date)
{
    NSDateComponents *dc = getChineseDateComponents(date);
    [dc setTimeZone:[NSTimeZone timeZoneWithName:TIME_ZONE_GMT]];    
    NSInteger weekIndex = [dc weekday];
    if(weekIndex > [getWeekDayArray() count]){
        return @"";
    }
    return [getWeekDayArray() objectAtIndex:weekIndex-1];
}

NSString* chineseLeftTime(NSDate* date)
{
    int interval = [date timeIntervalSinceNow];
    if (interval >= 0) {
        if (interval >= 3600*24) {
            return [NSString stringWithFormat:@"还有%d天",interval/(3600*24)];
        } else if (interval >= 3600) {
            return [NSString stringWithFormat:@"还有%d小时",interval/3600];
        } else if (interval >= 60) {
            return [NSString stringWithFormat:@"还有%d分钟",interval/60];
        } else {
            return [NSString stringWithFormat:@"还有%d秒",interval];
        }
    } else {
        return nil;
    }
    
    return nil;
}

NSString* englishLeftTime(NSDate* date)
{
    int interval = [date timeIntervalSinceNow];
    if (interval >= 0) {
        if (interval >= 3600*24) {
            return [NSString stringWithFormat:@"%d day%@ left",interval/(3600*24), ((interval/(3600*24) == 1) ? @"":  @"s")];
        } else if (interval >= 3600) {
            return [NSString stringWithFormat:@"%d hour%@ left",interval/3600, ((interval/(3600) == 1) ? @"":  @"s")];
        } else if (interval >= 60) {
            return [NSString stringWithFormat:@"%d minute%@ left",interval/60, ((interval/(60) == 1) ? @"":  @"s")];
        } else {
            return [NSString stringWithFormat:@"%d second%@ left",interval, ((interval == 1) ? @"":  @"s")];
        }
    } else {
        return nil;
    }
    
    return nil;
}

NSString* chineseBeforeTime(NSDate* date)
{
    int interval = [date timeIntervalSinceNow];
    if (interval <= 0) {
        if (interval > -60) {
            return [NSString stringWithFormat:@"%d秒前",interval/(-1)];
        } else if (interval >-3600) {
            return [NSString stringWithFormat:@"%d分钟前",interval/(-60)];
        } else if (interval > -3600*24) {
            return [NSString stringWithFormat:@"%d小时前",interval/(-60*60)];
        } else if (interval > -3600*24*4) {
            return [NSString stringWithFormat:@"%d天前",interval/(-60*60*24)];
        } else {
            return dateToChineseStringByFormat(date, DEFALT_TIME_FORMAT);
        }
    } else {
        return @"20秒前";
    }
    
    return nil;
}

#define TIME_ONLY_FORMAT             @"HH:mm"
#define DAY_ONLY_FORMAT              @"yyyy-MM-dd"
#define MONTH_ONLY_FORMAT            @"MM-dd"
#define DATE_TIME_FORMAT             @"yyyy-MM-dd HH:mm"

NSString* dayChineseString(NSDate* date)
{
	// Get Today's YYYY-MM-DD
	NSDateComponents *today_comps = getLocalDateComponents([NSDate date]);
	
	// Given Date's YYYY-MM-DD
	NSDateComponents *select_comps = getLocalDateComponents(date);
	
	if ([today_comps year] == [select_comps year])
    {
        // same year, only show month
        if ([today_comps month] == [select_comps month]){
            if ([today_comps day] == [select_comps day]){
                return @"今天";
            }
            else if ([today_comps day] == ([select_comps day]+1)){
                return @"昨天";
            }
            else if ([today_comps day] == ([select_comps day]+2)){
                return @"前天";
            }
            else{
                return dateToChineseStringByFormat(date, MONTH_ONLY_FORMAT);
            }
        }
        else{
            return dateToChineseStringByFormat(date, MONTH_ONLY_FORMAT);            
        }
	}
	else {
        return dateToChineseStringByFormat(date, DAY_ONLY_FORMAT);
	}
}

NSString* dayEnglishString(NSDate* date)
{
	// Get Today's YYYY-MM-DD
	NSDateComponents *today_comps = getLocalDateComponents([NSDate date]);
	
	// Given Date's YYYY-MM-DD
	NSDateComponents *select_comps = getLocalDateComponents(date);
	
	if ([today_comps year] == [select_comps year])
    {
        // same year, only show month
        if ([today_comps month] == [select_comps month]){
            if ([today_comps day] == [select_comps day]){
                return @"Today";
            }
            else if ([today_comps day] == ([select_comps day]+1)){
                return @"Yesterday";
            }
            else{
                return dateToStringByFormat(date, MONTH_ONLY_FORMAT);
            }
        }
        else{
            return dateToStringByFormat(date, MONTH_ONLY_FORMAT);
        }
	}
	else {
        return dateToStringByFormat(date, DAY_ONLY_FORMAT);
	}
}

NSString* chineseBeforeTimeForChat(NSDate* date)
{
    int interval = [date timeIntervalSinceNow];
    if (interval <= 0) {
        if (interval > -60) {
            return [NSString stringWithFormat:@"%d秒前",interval/(-1)];
        } else if (interval >-3600) {
            return [NSString stringWithFormat:@"%d分钟前",interval/(-60)];
        } else {
            return [NSString stringWithFormat:@"%@ %@", dayChineseString(date), dateToChineseStringByFormat(date, TIME_ONLY_FORMAT)];
        }
    } else {
        return @"20秒前";
    }
    
    return nil;
}

NSString* englishBeforeTimeForChat(NSDate* date)
{
    int interval = [date timeIntervalSinceNow];
    if (interval <= 0) {
        if (interval > -60) {
            return [NSString stringWithFormat:@"%d second%@ ago",interval/(-1), (interval/(-1) == 1)?@"":@"s"];
        } else if (interval >-3600) {
            return [NSString stringWithFormat:@"%d minute%@ ago",interval/(-60), (interval/(-60) == 1)?@"":@"s"];
        } else {
            return [NSString stringWithFormat:@"%@ %@", dayEnglishString(date), dateToStringByFormat(date, TIME_ONLY_FORMAT)];
        }
    } else {
        return @"20 seconds ago";
    }
    
    return nil;
}

NSString* englishBeforeTime(NSDate* date)
{
    int interval = [date timeIntervalSinceNow];
    if (interval <= 0) {
        if (interval > -60) {
            return [NSString stringWithFormat:@"%d second%@ ago",interval/(-1), (interval/(-1) == 1)?@"":@"s"];
        } else if (interval >-3600) {
            return [NSString stringWithFormat:@"%d minute%@ ago",interval/(-60), (interval/(-60) == 1)?@"":@"s"];
        } else if (interval > -3600*24) {
            return [NSString stringWithFormat:@"%d hour%@ ago",interval/(-60*60), (interval/(-60*60) == 1)?@"":@"s"];
        } else if (interval > -3600*24*2) {
            return [NSString stringWithFormat:@"Yesterday"];
        }else if (interval > -3600*24*4) {
            return [NSString stringWithFormat:@"%d days ago",interval/(-60*60*24)];
        } else {
            return dateToStringByFormat(date, DEFALT_TIME_FORMAT);
        }
    } else {
        return @"20 seconds ago";
    }
    
    return nil;
}


NSString *chineseWeekDay2FromDate(NSDate *date)
{
    NSDateComponents *dc = getChineseDateComponents(date);
    [dc setTimeZone:[NSTimeZone timeZoneWithName:TIME_ZONE_GMT]];
    NSInteger weekIndex = [dc weekday];
    if(weekIndex > [getWeekDay2Array() count]){
        return @"";
    }
    return [getWeekDay2Array() objectAtIndex:weekIndex-1];

}

NSString *dateLeftString(NSDate *date)
{
    if ([LocaleUtils isChinese]) {
        NSString *dString = chineseLeftTime(date);
        return dString;
    }else{
        NSString *dString = englishLeftTime(date);
        return dString;
    }
}


NSString *dateToTimeLineString(NSDate *date)
{
    if ([LocaleUtils isChinese]) {
        NSString *dString = chineseBeforeTime(date);
        if (dString == nil) {
            return dateToChineseStringByFormat(date, DEFALT_TIME_FORMAT);
        }
        return dString;
    }else{
        NSString *dString = englishBeforeTime(date);
        if (dString == nil) {
            return dateToChineseStringByFormat(date, DEFALT_TIME_FORMAT);
        }
        return dString;
    }
}


NSString *dateToChatTimeLineString(NSDate *date)
{
    if ([LocaleUtils isChinese]) {
        NSString *dString = chineseBeforeTimeForChat(date);
        if (dString == nil) {
            return dateToChineseStringByFormat(date, DATE_TIME_FORMAT);
        }
        return dString;
    }else{
        NSString *dString = englishBeforeTimeForChat(date);
        if (dString == nil) {
            return dateToChineseStringByFormat(date, DATE_TIME_FORMAT);
        }
        return dString;
    }
}

NSInteger getYear(NSDate *date)
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    return [components year];
}

NSInteger getMonth(NSDate *date)
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    return [components month];
}

NSInteger getDay(NSDate *date)
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    return [components day];
}

enum {
    ZODIAC_ARIES = 1,//白羊座
    ZODIAC_TAURUS, //金牛座
    ZODIAC_GEMINI, //双子座
    ZODIAC_CANCER, //巨蟹座
    ZODIAC_LEO,    //狮子座
    ZODIAC_VIRGO,  //处女
    ZODIAC_LIBRA,  //天秤
    ZODIAC_SCORPIO,  //天蝎
    ZODIAC_SAGITTARIUS, //射手
    ZODIAC_CAPRICORN, //摩羯
    ZODIAC_AQURAIUS, //水瓶
    ZODIAC_PISCES,   //双鱼
};

int dateToZodiac(NSDate* date) {
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM"];
    int i_month = 0;
    NSString * theMonth = [dateFormat stringFromDate:date];
    if ([[theMonth substringToIndex:0] isEqualToString:@"0"]) {
        i_month = [[theMonth substringFromIndex:1] intValue];
    }
    else {
        i_month = [theMonth intValue];
    }
    
    [dateFormat setDateFormat:@"dd"];
    int i_day = 0;
    NSString * theDay = [dateFormat stringFromDate:date];
    if ([[theDay substringToIndex:0] isEqualToString:@"0"]) {
        i_day = [[theDay substringFromIndex:1] intValue];
    }
    else {
        i_day = [theDay intValue];
    }
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    switch (i_month) {
        case 1:
            if (i_day >= 20 && i_day <= 31) {
//                returnString = @"水瓶座";
                return ZODIAC_AQURAIUS;
            }
            if (i_day >= 1 && i_day <= 19) {
//                returnString = @"摩羯座";
                return ZODIAC_CAPRICORN;
            }
            break;
        case 2:
            if (i_day >= 1 && i_day <= 18) {
//                returnString = @"水瓶座";
                return ZODIAC_AQURAIUS;
            }
            if (i_day >= 19 && i_day <=31) {
//                returnString = @"双鱼座";
                return ZODIAC_PISCES;
            }
            break;
        case 3:
            if (i_day >= 1 && i_day <= 20) {
//                returnString = @"双鱼座";
                return ZODIAC_PISCES;
            }
            if (i_day >= 21 && i_day <=31) {
//                returnString = @"白羊座";
                return ZODIAC_ARIES;
            }
            break;
        case 4:
            if (i_day >= 1 && i_day <= 19) {
//                returnString = @"白羊座";
                return ZODIAC_ARIES;
            }
            if (i_day >= 20 && i_day <=31) {
//                returnString = @"金牛座";
                return ZODIAC_TAURUS;
            }
            break;
        case 5:
            if (i_day >= 1 && i_day <= 20) {
//                returnString = @"金牛座";
                return ZODIAC_TAURUS;
            }
            if (i_day >= 21 && i_day <=31) {
//                returnString = @"双子座";
                return ZODIAC_GEMINI;
            }
            break;
        case 6:
            if (i_day >= 1 && i_day <= 21) {
//                returnString = @"双子座";
                return ZODIAC_GEMINI;
            }
            if (i_day >= 22 && i_day <=30) {
//                returnString = @"巨蟹座";
                return ZODIAC_CANCER;
            }
            break;
        case 7:
            if (i_day >= 1 && i_day <= 22) {
//                returnString = @"巨蟹座";
                return ZODIAC_CANCER;
            }
            if (i_day >= 23 && i_day <=31) {
//                returnString = @"狮子座";
                return ZODIAC_LEO;
            }
            break;
        case 8:
            if (i_day >= 1 && i_day <= 22) {
//                returnString = @"狮子座";
                return ZODIAC_LEO;
            }
            if (i_day >= 23 && i_day <=31) {
//                returnString = @"处女座";
                return ZODIAC_VIRGO;
            }
            break;
        case 9:
            if (i_day >= 1 && i_day <= 22) {
//                returnString = @"处女座";
                return ZODIAC_VIRGO;
            }
            if (i_day >= 23 && i_day <=30) {
//                returnString = @"天秤座";
                return ZODIAC_LIBRA;
            }
            break;
        case 10:
            if (i_day >= 1 && i_day <= 23) {
//                returnString = @"天秤座";
                return ZODIAC_LIBRA;
            }
            if (i_day >= 24 && i_day <=31) {
//                returnString = @"天蝎座";
                return ZODIAC_SCORPIO;
            }
            break;
        case 11:
            if (i_day >= 1 && i_day <= 21) {
//                returnString = @"天蝎座";
                return ZODIAC_SCORPIO;
            }
            if (i_day >= 22 && i_day <=30) {
//                returnString = @"射手座";
                return ZODIAC_SAGITTARIUS;
            }
            break;
        case 12:
            if (i_day >= 1 && i_day <= 21) {
//                returnString = @"射手座";
                return ZODIAC_SAGITTARIUS;
            }
            if (i_day >= 22 && i_day <=31) {
//                returnString = @"摩羯座";
                return ZODIAC_CAPRICORN;
            }
            break;
        default:
            break;
    }
    return -1;
}

int nowInDateRange(NSDate* from, NSDate* to)
{
    int fromInterval = [from timeIntervalSinceNow];
    int toInterval = [to timeIntervalSinceNow];
    
    if (fromInterval <=0 && toInterval >= 0){
        // in range
        return 0;
    }
    else if (fromInterval <=0 && toInterval < 0){
        // both before now
        return -1;
    }
    else{
        return 1;
    }
}


/*
 // The date in your source timezone (eg. EST)
 NSDate* sourceDate = [NSDate date];
 
 NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"EST"];
 NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
 
 NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
 NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
 NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
 
 NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
 */

/*
 NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
 [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSDate* sourceDate = [formatter dateFromString:@"2009-07-04 10:23:23"];
 */


/*
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
 [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
 
 NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:118800];
 
 NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
 [dateFormatter setLocale:usLocale];
 
 NSLog(@"Date for locale %@: %@",
 [[dateFormatter locale] localeIdentifier], [dateFormatter stringFromDate:date]);
 // Output:
 // Date for locale en_US: Jan 2, 2001
 
 NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
 [dateFormatter setLocale:frLocale];
 NSLog(@"Date for locale %@: %@",
 [[dateFormatter locale] localeIdentifier], [dateFormatter stringFromDate:date]);
 // Output:
 // Date for locale fr_FR: 2 janv. 2001
*/