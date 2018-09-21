//
//  JT_KLine.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/30.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JT_KLineModel;
@interface JT_DrawCandleLine : NSObject

@property (nonatomic, assign) CGPoint timePostion;

@property (nonatomic, assign) CGFloat maxY;
/**
 日期的 size
 */
@property (nonatomic, assign) CGSize  timeSize;


@property (nonatomic ,assign) CGFloat timeViewWidth;

/**
 蜡烛线对应的时间
 */
@property (nonatomic, strong) NSString  *timeString;

/**
 *  根据context初始化
 */
- (instancetype)initWithContext:(CGContextRef)context;

/**
 画柱状图

 @param color 颜色
 @width 线宽
 @param beginPoint 起点
 @param endPoint 终点
 */
- (void)drawBarWithColor:(UIColor *)color width:(float)width begin:(CGPoint)beginPoint end:(CGPoint)endPoint;

/**
 画X轴时间
 */
- (void)drawDateTime;


/**
 画美国线

 @param color 颜色
 @width 线宽
 @param openPoint 开盘坐标
 @param closePoint 收盘坐标
 */
- (void)drawAMLineWithColor:(UIColor *)color width:(float)width left:(CGPoint)openPoint right:(CGPoint)closePoint;


/**
 画买卖点的圆

 */
- (void)drawRoundPoint:(CGPoint)point;

@end
