//
//  JT_KLineConfig.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/30.
//  Copyright © 2018年 com.csc. All rights reserved.
//  配置 k 线相关参数，k 线默认宽度及最大宽度，最小宽度，k线间间隔，上下影线宽度

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//时间轴字体大小
#define JT_KLineX_AxisTimeFontSize           10

//最高价字体大小
#define JT_KLineHighestPriceFontSize         12

//Y轴价格字体
#define JT_KLineY_AxisPriceFontSize          11


// k 线缩放手势最小边界
#define JT_KLineChartScaleBound              0.03

// 每次缩放的比例
#define JT_KLineChartScaleFactor            0.03

#import "JT_TimelineAndKlineSegment.h"
@interface JT_KLineConfig : NSObject
/**
 *  K线图的宽度，默认20
 */
+(CGFloat)kLineWidth;

+(void)setkLineWith:(CGFloat)kLineWidth;

/**
 *  K线图的间隔，默认1
 */
+(CGFloat)kLineGap;

+(void)setkLineGap:(CGFloat)kLineGap;

/**
  最高最低价影线的宽度
 */
+ (CGFloat)kLineShadeLineWidth;
+ (void)setkLineShadeLineWidth:(CGFloat)width;


/**
 涨的颜色

 */
+ (UIColor *)kLineIncreaseColor;

/**
 
 跌的颜色
 */
+ (UIColor *)kLineDecreaseColor;


/**
 设置 k 线的类型

 */
+ (JT_TimelineAndKlineItemType)kLineType;

+ (void)setkLineType:(JT_TimelineAndKlineItemType)type;

@end
