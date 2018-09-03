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

static NSInteger JT_kLineType = JT_SegmentItemTypeKline5Min;


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
@end
