//
//  JT_KLineConfig.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/30.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineConfig.h"
#import "JT_ColorManager.h"
static CGFloat const JT_KLineDefaultWidth = 6;
static CGFloat JT_KLineWidth = JT_KLineDefaultWidth;
static CGFloat const JT_KLineMaxWidth = 16;

static CGFloat const JT_KLineMinWidth = 3;

static CGFloat JT_KLineGap = 1;

static CGFloat JT_KLineShadeLineWidth = 1;

static NSInteger JT_kLineType = JT_SegmentItemTypeKlineDay;

static NSUInteger JT_KlineFQType = 0;

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
+(CGFloat)kLineWidth
{
    return JT_KLineWidth;
}
+(void)setkLineWith:(CGFloat)kLineWidth
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
+(CGFloat)kLineGap
{
    return JT_KLineGap;
}

+(void)setkLineGap:(CGFloat)kLineGap
{
    JT_KLineGap = kLineGap;
}
/**
 最高最低价影线的宽度
 */
+ (CGFloat)kLineShadeLineWidth{
    return JT_KLineShadeLineWidth;
}
+ (void)setkLineShadeLineWidth:(CGFloat)width{
    JT_KLineShadeLineWidth = width;
}
/**
 获取系统复权类型
 
 @return 返回复权类型 0 不复权，1前复权，2后复权
 */
+ (NSUInteger)kLineFQType {
    return JT_KlineFQType;
}
+ (void)setkLineFQType:(NSUInteger)type {
    JT_KlineFQType = type;
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

/**
 涨的颜色
 
 */
+ (UIColor *)kLineIncreaseColor {
    return JT_ColorDayOrNight(@"E83700", @"D64723");
}

/**
 
 跌的颜色
 */
+ (UIColor *)kLineDecreaseColor {
    return JT_ColorDayOrNight(@"00A23B", @"489F49");
}

+ (JT_TimelineAndKlineItemType)kLineType {
    return JT_kLineType;
}

+ (void)setkLineType:(JT_TimelineAndKlineItemType)type {
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
    if ([JT_KLineConfig kLineIndicatorType] == JT_Volume) {
        return @"成交量";
    } else if ([JT_KLineConfig kLineIndicatorType] == JT_KDJ) {
        return @"KDJ";
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_MACD) {
        return @"MACD";
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_BOLL) {
        return @"BOLL";
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_RSI) {
        return @"RSI";
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_DMA) {
        return @"DMA";
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_DMI) {
        return @"DMI";
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_BIAS) {
        return @"BIAS";
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_CCI) {
        return @"CCI";
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_WR) {
        return @"WR";
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_VR) {
        return @"VR";
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_CR) {
        return @"CR";
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_OBV) {
        return @"OBV";
    }
    return @"";
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
@end
