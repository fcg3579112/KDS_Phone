//
//  NSDate+KDS_Manage.m
//  KDS_Phone
//
//  Created by yehot on 15/10/22.
//  Copyright (c) 2015年 kds. All rights reserved.
//

#import "NSDate+KDS_Manage.h"

@implementation NSDate (KDS_Manage)

+ (NSDate *)kds_getDateWithString:(NSString *)string dateType:(NSString *)dateType {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateType];
    NSDate *date = [dateFormatter dateFromString:string]; //当前日期
    return date;
}

+ (NSInteger)kds_timeIntervalDaySinceDate:(NSDate *)date {
    NSInteger intervalDayNum = [[NSDate date] timeIntervalSinceDate:date]/60/60/24;
    if (intervalDayNum < 0) {
        intervalDayNum = 0;
    }
    
    return intervalDayNum;
}

+ (NSInteger)kds_timeIntervalHourSinceDate:(NSDate *)date {
    NSInteger intervalHourNum = [[NSDate date] timeIntervalSinceDate:date]/60/60;
    if (intervalHourNum < 0) {
        intervalHourNum = 0;
    }
    
    return intervalHourNum;
}

+ (NSInteger)kds_timeIntervalMinuteSinceDate:(NSDate *)date {
    NSInteger intervalMinNum = [[NSDate date] timeIntervalSinceDate:date]/60;
    if (intervalMinNum < 0) {
        intervalMinNum = 0;
    }
    
    return intervalMinNum;
}

+ (NSString *)kds_getDateStringWithDate:(NSDate *)date dateType:(NSString *)dateType {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateType];
    NSString *stringDate = [dateFormatter stringFromDate:date]; //当前日期
    
    return [stringDate length] > 0 ? stringDate : @"";
}

+ (NSString *)kds_timeFormatWithDate:(int)date time:(int)time {
    // date:20150624  time:192500
    NSString *dateStr = [NSString stringWithFormat:@"%d", date];
    NSString *timeStr = [NSString stringWithFormat:@"%d", time];
    NSMutableString *retStr = [NSMutableString stringWithString:dateStr];
    if ([dateStr length] >= 8 && [timeStr length] >= 5) {
        retStr = [NSMutableString stringWithString:[dateStr substringFromIndex:4]];
        if ([retStr length] >= 2) {
            [retStr insertString:@"-" atIndex:2];
        }
        
        NSRange range = NSMakeRange(0, [timeStr length]-2);
        timeStr = [timeStr substringWithRange:range];
        NSMutableString *timeMutableStr = [NSMutableString stringWithString:timeStr];
        if ([timeMutableStr length] <= 3) {
            [timeMutableStr insertString:@"0" atIndex:0];
        }
        if ([timeMutableStr length] >= 2) {
            [timeMutableStr insertString:@":" atIndex:2];
        }
        
        retStr = [NSMutableString stringWithFormat:@"%@ %@", retStr, timeMutableStr];
    }
    return retStr;
}

+ (NSString *)kds_dateStrWithToday {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *retStr = [formatter stringFromDate:[NSDate date]];
    return retStr;
}

+ (BOOL)isToday:(NSDate *)beginDate {
    if (!beginDate) {
        return NO;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1. 获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2. 获得 beginDate 的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:beginDate];
    
    //直接分别用当前对象和现在的时间进行比较，比较的属性就是年月日
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

+ (BOOL)isYesterday:(NSDate *)beginDate {
    if (!beginDate) {
        return NO;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1. 获得当前时间昨天的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate dateWithTimeIntervalSinceNow:-(24*60*60)]];
    
    // 2. 获得 beginDate 的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:beginDate];
    
    //直接分别用当前对象和现在的时间进行比较，比较的属性就是年月日
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

+ (NSString *)kds_standardDateStringWithString:(NSString *)string {
    NSDate *date = [self kds_getDateWithString:string dateType:@"yyyy-MM-dd HH:mm"];
    NSString *stringDate = string;
    if ([self isToday:date]) {  // 今天
        stringDate = [NSString stringWithFormat:@"今天 %@", [self kds_getDateStringWithDate:date dateType:@"HH:mm"]];
    }
//    if ([self isYesterday:date]) {
//        stringDate = [NSString stringWithFormat:@"昨天 %@", [self kds_getDateStringWithDate:date dateType:@"HH:mm"]];
//    }
    
    return stringDate;
}

+ (NSString *)kds_standardDateStringTimeOrDateWithString:(NSString *)string {
    NSDate *date = [self kds_getDateWithString:string dateType:@"yyyy-MM-dd HH:mm"];
    
    return [self kds_standardDateStringTimeOrDateWithDate:date];
}

+ (NSString *)kds_standardDateStringTimeOrDateWithDate:(NSDate *)date {
    NSString *stringDate = nil;
    if ([self isToday:date]) {  // 今天
        stringDate = [self kds_getDateStringWithDate:date dateType:@"HH:mm"];
    } else if ([self isYesterday:date]) {
        stringDate = @"昨天";
    } else {
        stringDate = [self kds_getDateStringWithDate:date dateType:@"YY/MM/dd"];
    }
    
    return stringDate;
}

+ (NSString *)kds_standardDateStringTimeOrDateShowNoneYesterdayWithDate:(NSDate *)date {
    NSString *stringDate = nil;
    if ([self isToday:date]) {  // 今天
        stringDate = [self kds_getDateStringWithDate:date dateType:@"HH:mm"];
    }else {
        stringDate = [self kds_getDateStringWithDate:date dateType:@"YY/MM/dd"];
    }
    
    return stringDate;
}
+ (NSDate *)kds_dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (BOOL)isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].day == self.day;
}

+ (NSString *)kds_standardDateStringWithSystemTimeString:(NSString *)string {
    NSDate *date = [self kds_getDateWithString:string dateType:@"yyyyMMddHHmmss"];
    NSString *stringDate = string;
//   stringDate = [self  kds_getDateStringWithDate:date dateType:@"MMdd"];
    stringDate = [self kds_getDateStringWithDate:date dateType:@"MM/dd"];

    
    return stringDate;
}
@end
