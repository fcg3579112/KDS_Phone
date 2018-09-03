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
 重置 k 线宽度
 */
+(void)resetKlineWidth;

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


/**
 是否显示最高点最低点

 */
+ (BOOL)showHighAndLowPrice;

+ (void)setShowHighAndLowPrice:(BOOL)show;


//设置均线，这个是全局的，当设置为0时，不需要显示对应均线，设置为大于 0 的数时需要计算

+ (NSUInteger)MA5;

+ (void)setMA5:(NSUInteger)ma;

+ (NSUInteger)MA10;

+ (void)setMA10:(NSUInteger)ma;

+ (NSUInteger)MA20;

+ (void)setMA20:(NSUInteger)ma;

+ (NSUInteger)MA30;

+ (void)setMA30:(NSUInteger)ma;

+ (NSUInteger)MA60;

+ (void)setMA60:(NSUInteger)ma;

@end
