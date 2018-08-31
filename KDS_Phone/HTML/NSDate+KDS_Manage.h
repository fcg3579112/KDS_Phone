//
//  NSDate+KDS_Manage.h
//  KDS_Phone
//
//  Created by yehot on 15/10/22.
//  Copyright (c) 2015年 kds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (KDS_Manage)
@property (nonatomic, readonly) BOOL isToday; ///< Weather date is today (based on current locale)

@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
/**
 *  根据字符串获取时间
 *
 *  @param string   时间字符串
 *  @param dateType 时间格式 yyyy:mm:dd hh:mm:ss
 *
 *  @return 时间
 */
+ (NSDate *)kds_getDateWithString:(NSString *)string dateType:(NSString *)dateType;

/**
 *  获取从一个时间开始到现在的天数
 *
 *  @param date 原时间
 *
 *  @return 返回天数 （不够一天的直接设置成无）
 */
+ (NSInteger)kds_timeIntervalDaySinceDate:(NSDate *)date;

/**
 *  获取从一个时间开始到现在的小时数
 *
 *  @param date 原时间
 *
 *  @return 返回小时数 （不够一小时的直接设置成无）
 */
+ (NSInteger)kds_timeIntervalHourSinceDate:(NSDate *)date;

/**
 *  获取从一个时间开始到现在的分钟数
 *
 *  @param date 原时间
 *
 *  @return 返回分钟数 （不够一分钟的直接设置成无）
 */
+ (NSInteger)kds_timeIntervalMinuteSinceDate:(NSDate *)date;

/**
 *  时间转成字符串
 *
 *  @param date     时间
 *  @param dateType 时间格式 yyyy:mm:dd hh:mm:ss
 *
 *  @return 时间串
 */
+ (NSString *)kds_getDateStringWithDate:(NSDate *)date dateType:(NSString *)dateType;

/**
 *  从日期以及时间返回时间字符串  06-24 10:30
 *
 *  @param date 日期
 *  @param time 时间
 *  @param warning date:20150624  time:192500
 *
 *  @return 时间
 */
+ (NSString *)kds_timeFormatWithDate:(int)date time:(int)time;

/**
 *  返回今日日期字符串
 *
 *  @return 今日日期
 */
+ (NSString *)kds_dateStrWithToday;

/**
 *  日期是否是今天
 *
 *  @param beginDate 给的日期
 *
 *  @return 结果
 */
+ (BOOL)isToday:(NSDate *)beginDate;

/**
 *  日期是否是昨天
 *
 *  @param beginDate 给的日期
 *
 *  @return 结果
 */
+ (BOOL)isYesterday:(NSDate *)beginDate;

/**
 *  规范时间字符串，小于一天的时间设置为今天 小于两天设置为昨天，三天以上才显示时间
 *
 *  @param string 原string
 *
 *  @return 规范后string
 */
+ (NSString *)kds_standardDateStringWithString:(NSString *)string;

/**
 *  规范时间字符串，小于一天的时间显示时间 小于两天设置为昨天，三天以上只显示日期
 *
 *  @param string 原string
 *
 *  @return 规范后string
 */
+ (NSString *)kds_standardDateStringTimeOrDateWithString:(NSString *)string;
/**
 *  规范时间字符串，小于一天的时间显示时间 小于两天设置为昨天，三天以上只显示日期
 *
 *  @param date 原date
 *
 *  @return 规范后string
 */
+ (NSString *)kds_standardDateStringTimeOrDateWithDate:(NSDate *)date;
/**
 *  规范时间字符串，小于一天的时间显示时间 其他显示日期
 *
 *  @param date 原date
 *
 *  @return 规范后string
 */
+ (NSString *)kds_standardDateStringTimeOrDateShowNoneYesterdayWithDate:(NSDate *)date;
/**
 Returns a date parsed from given string interpreted using the format.
 
 @param dateString The string to parse.
 @param format     The string's date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (NSDate *)kds_dateWithString:(NSString *)dateString format:(NSString *)format;
/**
 *  规范时间字符串，输入
 *
 *  @param string  系统时间yyyymmddhhmmss
 *
 *  @return 规范后MM/dd
 */
+ (NSString *)kds_standardDateStringWithSystemTimeString:(NSString *)string;
@end
