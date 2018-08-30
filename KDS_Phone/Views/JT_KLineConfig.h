//
//  JT_KLineConfig.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/30.
//  Copyright © 2018年 com.csc. All rights reserved.
//  配置 k 线相关参数，k 线默认宽度及最大宽度，最小宽度，k线间间隔，上下影线宽度

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
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

@end
