//
//  TimeUtils.h
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-6.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_DATE_FORMAT		@"yyyyMMddHHmmss"
#define TIME_ZONE_GMT           @"Asia/Shanghai"
#define DATE_FORMAT             @"yyyy-MM-dd"
#define DATE_CHINESE_FORMAT     @"yyyy年MM月dd日"

#define DEFALT_TIME_FORMAT             @"yy-MM-dd HH:mm"

NSDateComponents *getDateComponents(NSDate *date);

BOOL isToday(NSDate *date);

BOOL isChineseToday(NSDate *date);

BOOL isLocalToday(NSDate *date);

BOOL isYesterday(NSDate *date);

BOOL isTheDayBeforeYesterday(NSDate *date);

BOOL isThisYear(NSDate *date);

NSString *dateToLocaleString(NSDate *date);

NSString *dateToString(NSDate *date);
NSString *dateToLocaleStringWithFormat(NSDate *date, NSString* format);

NSString *dateToChineseString(NSDate *date);

NSString *dateToChineseStringByFormat(NSDate *date, NSString *format);

NSString *dateToStringByFormat(NSDate *date, NSString *format);

NSString *dateToUTCStringByFormat(NSDate *date, NSString *format);

NSDate *dateFromStringByFormat(NSString *string, NSString *format);

NSDate *dateFromUTCStringByFormat(NSString *string, NSString *format);

NSDate *getDateStart(NSDate* date);

NSDate *getDateEnd(NSDate* date);

NSDate *nextDate(NSDate *date);

NSDate *nextNDate(NSDate *date, NSInteger interval);

NSDate *previousDate(NSDate *date);

NSDate *dateFromChineseStringByFormat(NSString *string, NSString *format);

NSString *chineseWeekDayFromDate(NSDate *date);

NSString* chineseBeforeTime(NSDate* date);

NSString* englishBeforeTime(NSDate* date);

NSString *chineseWeekDay2FromDate(NSDate *date);

NSString *GMTToBeiJingTime(NSString* gmt,NSString *dateFormat);

NSString *dateToTimeLineString(NSDate *date);

NSString *dateToChatTimeLineString(NSDate *date);

NSInteger getYear(NSDate *date);

NSInteger getMonth(NSDate *date);

NSInteger getDay(NSDate *date);

int dateToZodiac(NSDate* date);

int nowInDateRange(NSDate* from, NSDate* to);

NSString *dateLeftString(NSDate *date);

BOOL isLocalDay(NSDate *date, int interval);
