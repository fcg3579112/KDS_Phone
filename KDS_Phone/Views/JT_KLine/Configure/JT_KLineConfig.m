//
//  JT_KLineConfig.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/30.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineConfig.h"
#import "JT_ColorManager.h"
static float const JT_KLineDefaultWidth = 6;
static float JT_KLineWidth = JT_KLineDefaultWidth;
static float const JT_KLineMaxWidth = 16;

static float const JT_KLineMinWidth = 3;

static float JT_KLineGap = 1;

static float JT_KLineShadeLineWidth = 1;

static NSInteger JT_kLineType = JT_KLineTypeUnKnow;

static NSUInteger JT_KlineFQType = -1;

static JT_KLineIndicatorType JT_IndicatorType = JT_Volume;

static NSUInteger JT_MA5 = 5;

static NSUInteger JT_MA10 = 10;

static NSUInteger JT_MA20 = 20;

static NSUInteger JT_MA30 = 0;

static NSUInteger JT_MA60 = 0;



static BOOL JT_ShowHighAndLowPrice = YES;


@implementation JT_KLineConfig
/**
 *  K线图的宽度，默认20
 */
+(float)kLineWidth
{
    return JT_KLineWidth;
}
+(void)setkLineWith:(float)kLineWidth
{
    if (kLineWidth > JT_KLineMaxWidth) {
        JT_KLineWidth = JT_KLineMaxWidth;
    }else if (kLineWidth < JT_KLineMinWidth){
        JT_KLineWidth = JT_KLineMinWidth;
    } else {
        JT_KLineWidth = kLineWidth;
    }
}
+(void)resetKlineWidth {
    JT_KLineWidth = JT_KLineDefaultWidth;
}

/**
 *  K线图的间隔，默认1
 */
+(float)kLineGap
{
    return JT_KLineGap;
}

+(void)setkLineGap:(float)kLineGap
{
    JT_KLineGap = kLineGap;
}
/**
 最高最低价影线的宽度
 */
+ (float)kLineShadeLineWidth{
    return JT_KLineShadeLineWidth;
}
+ (void)setkLineShadeLineWidth:(float)width{
    JT_KLineShadeLineWidth = width;
}
/**
 获取系统复权类型
 
 @return 返回复权类型 0 不复权，1前复权，2后复权
 */
+ (NSUInteger)kLineFQType {
    if (JT_KlineFQType == -1) {
        JT_KlineFQType = [[NSUserDefaults standardUserDefaults] integerForKey:@"JT_KLine_FQ_Type_Key"];
        return JT_KlineFQType;
    } else {
        return JT_KlineFQType;
    }
}
+ (void)setkLineFQType:(NSUInteger)type {
    JT_KlineFQType = type;
    //存储复权类型
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:@"JT_KLine_FQ_Type_Key"];
}

/**
 获取选中的指标类型
 */
+ (JT_KLineIndicatorType)kLineIndicatorType {
    return JT_IndicatorType;
}
+ (void)setkLineIndicatorType:(JT_KLineIndicatorType)type {
    JT_IndicatorType = type;
}

+ (JT_KLineType)kLineType {
    return JT_kLineType;
}

+ (void)setkLineType:(JT_KLineType)type {
    JT_kLineType = type;
}

+ (NSUInteger)MA5{
    return JT_MA5;
}

+ (void)setMA5:(NSUInteger)ma {
    JT_MA5 = ma;
}

+ (NSUInteger)MA10 {
    return JT_MA10;
}

+ (void)setMA10:(NSUInteger)ma {
    JT_MA10 = ma;
}

+ (NSUInteger)MA20 {
    return JT_MA20;
}

+ (void)setMA20:(NSUInteger)ma {
    JT_MA20 = ma;
}

+ (NSUInteger)MA30 {
    return JT_MA30;
}

+ (void)setMA30:(NSUInteger)ma {
    JT_MA30 = ma;
}

+ (NSUInteger)MA60 {
    return JT_MA60;
}

+ (void)setMA60:(NSUInteger)ma {
    JT_MA60 = ma;
}

/**
 是否显示最高点最低点
 
 */
+ (BOOL)showHighAndLowPrice {
    return JT_ShowHighAndLowPrice;
}

+ (void)setShowHighAndLowPrice:(BOOL)show {
    JT_ShowHighAndLowPrice = show;
}

//当前显示的指数的类别名称
+ (NSString *)currentIndicatorTitle {

    
    switch ([JT_KLineConfig kLineIndicatorType]) {
            case JT_Volume:
                return @"成交量";
            break;
            case JT_KDJ:
                return @"KDJ";
            break;
            case JT_MACD:
                return @"MACD";
            break;
            case JT_BOLL:
                return @"BOLL";
            break;
            case JT_RSI:
                return @"RSI";
            break;
            case JT_DMA:
                return @"DMA";
            break;
            case JT_DMI:
                return @"DMI";
            break;
            case JT_BIAS:
                return @"BIAS";
            break;
            case JT_CCI:
                return @"CCI";
            break;
            case JT_WR:
                return @"WR";
            break;
            case JT_VR:
                return @"VR";
            break;
            case JT_CR:
                return @"CR";
            break;
            case JT_OBV:
                return @"OBV";
            break;
            
        default:
            return @"";
            break;
    }
}
//格式化成交量
NSString *formatVolume(NSUInteger volume) {
    if (volume > 100000000) {
        return [NSString stringWithFormat:@"%.2f亿",volume / 100000000.0];
    } else if (volume > 10000) {
        return [NSString stringWithFormat:@"%.2f万",volume / 10000.0];
    } else {
        return [NSString stringWithFormat:@"%lu",volume];
    }
}


NSString *formateDateFromString(NSString *dateString) {
    //2017 0605 1440 00
    JT_KLineType kLineType = [JT_KLineConfig kLineType];
    NSString *resultString = @"";
    
    //如果是分钟 k，需要在后面添加上时间
    if ( kLineType == JT_KLineType5Min ||
        kLineType == JT_KLineType15Min ||
        kLineType == JT_KLineType30Min ||
        kLineType == JT_KLineType60Min ) {
        if (dateString.length < 12) {
            return resultString;
        }
        resultString = [NSString stringWithFormat:@"%@-%@ %@:%@",[dateString substringWithRange:NSMakeRange(4, 2)],[dateString substringWithRange:NSMakeRange(6, 2)],[dateString substringWithRange:NSMakeRange(8, 2)],[dateString substringWithRange:NSMakeRange(10, 2)]];
    } else {
        if (dateString.length < 8) {
            return resultString;
        }
        resultString = [NSString stringWithFormat:@"%@-%@-%@",[dateString substringWithRange:NSMakeRange(0, 4)],[dateString substringWithRange:NSMakeRange(4, 2)],[dateString substringWithRange:NSMakeRange(6, 2)]];
    }
    return resultString;
}
+ (JT_KLineType)convert2KLineTypeWithSegmentIndex:(JT_TimelineAndKlineItemType)type {
    
    switch (type) {
        case JT_SegmentItemTypeKlineDay:
            return JT_KLineTypeDay;
            break;
        case JT_SegmentItemTypeKlineWeek:
            return JT_KLineTypeWeek;
            break;
        case JT_SegmentItemTypeKlineMonth:
            return JT_KLineTypeMonth;
            break;
        case JT_SegmentItemTypeKline5Min:
            return JT_KLineType5Min;
            break;
        case JT_SegmentItemTypeKline15Min:
            return JT_KLineType15Min;
            break;
        case JT_SegmentItemTypeKline30Min:
            return JT_KLineType30Min;
            break;
        case JT_SegmentItemTypeKline60Min:
            return JT_KLineType60Min;
            break;
        default:
            return JT_KLineTypeUnKnow;
            break;
    }
}
@end
