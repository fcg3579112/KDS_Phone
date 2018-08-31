//
//  JT_KLineConfig.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/30.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineConfig.h"
#import "JT_ColorManager.h"
static CGFloat JT_KLineWidth = 5;
static CGFloat const JT_KLineMaxWidth = 20;

static CGFloat const JT_KLineMinWidth = 2;

static CGFloat JT_KLineGap = 1;

static CGFloat JT_KLineShadeLineWidth = 1;

static NSInteger JT_kLineType = JT_SegmentItemTypeKline5Min;


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
    }
    JT_KLineWidth = kLineWidth;
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
@end
