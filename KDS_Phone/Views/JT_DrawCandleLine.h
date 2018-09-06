//
//  JT_KLine.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/30.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JT_KLinePositionModel,JT_KLineModel;
@interface JT_DrawCandleLine : NSObject
/**
 *  K线的位置model
 */
@property (nonatomic ,strong) JT_KLineModel *kLineModel;
@property (nonatomic, strong) JT_KLinePositionModel *kLinePositionModel;

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
 *  绘制K线蜡烛线
 */
- (void)drawCandleLine;

/**
 画X轴时间
 */
- (void)drawDateTime;

/**
 画成交量
 */
- (void)drawVolume;

/**
 画 MACD  bar
 */
- (void)drawMACD_Bar;
@end
