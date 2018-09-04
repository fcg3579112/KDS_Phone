//
//  JT_KLineConfig.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/30.
//  Copyright © 2018年 com.csc. All rights reserved.
//  配置 k 线相关参数，k 线默认宽度及最大宽度，最小宽度，k线间间隔，上下影线宽度

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JT_ColorManager.h"
#import "JT_KLineEnum.h"

//时间轴字体大小
#define JT_KLineX_AxisTimeFontSize           10

//最高价字体大小
#define JT_KLineHighestPriceFontSize         12

//Y轴价格字体
#define JT_KLineY_AxisPriceFontSize          11


// MA 字体大小
#define JT_KLineMAFontSize                   11



// k 线缩放手势最小边界
#define JT_KLineChartScaleBound              0.03

// 每次缩放的比例
#define JT_KLineChartScaleFactor             0.03


#define JT_KLineFQSegmentItemHight           40



/**
 均线的颜色

 @param @"" 白模的色值
 @param @"" 夜模色值
 @return UIColor
 */

#define JT_KLineMATitleColor                  JT_ColorDayOrNight(@"5E6678",@"858C9E")
#define JT_KLineMA5Color                      JT_ColorDayOrNight(@"FF8000",@"FF8000")
#define JT_KLineMA10Color                     JT_ColorDayOrNight(@"00A7F8",@"00A7F8")
#define JT_KLineMA20Color                     JT_ColorDayOrNight(@"FF58FE",@"FF58FE")
#define JT_KLineMA30Color                     JT_ColorDayOrNight(@"2577FF",@"2577FF")
#define JT_KLineMA60Color                     JT_ColorDayOrNight(@"00C5B1",@"00C5B1")
#define JT_KLineMABackgroundColor             JT_ColorDayOrNight(@"FFF7F3",@"32221C")

//横屏复权按钮选中色
#define JT_KLineFQSegmentSelectedColor        JT_ColorDayOrNight(@"6B727C", @"F2F2F5")
//横屏复权按钮未选中色 
#define JT_KLineFQSegmentUnSelectedColor      JT_ColorDayOrNight(@"B0B3BA", @"80878D")
//复权、指标 segment 背景颜色
#define JT_KLineSegmentBackgroundColor        JT_ColorDayOrNight(@"F3F4F8", @"1B1C20")


#import "JT_KLineEnum.h"
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
 获取系统复权类型

 @return 返回复权类型 0 不复权，1前复权，2后复权
 */
+ (NSUInteger)kLineFQType;
+ (void)setkLineFQType:(NSUInteger)type;


/**
 获取选中的指标类型
 */
+ (JT_KLineIndicatorType)kLineIndicatorType;
+ (void)setkLineIndicatorType:(JT_KLineIndicatorType)type;


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
