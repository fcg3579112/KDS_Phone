//
//  JT_KLineView.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JT_KLineModel;
@interface JT_KLineView : UIView

/**
 顶部5日均线、10日均线显示区域的高度
 */
@property (nonatomic ,assign ) CGFloat MALineHeight;


/**
 右侧选择器的宽度
 */
@property (nonatomic ,assign ) CGFloat rightSelecterWidth;

/**
 k 线视图所占的比率
 */
@property (nonatomic ,assign) CGFloat klineViewRatio;

/**
 中间时间区域的高度
 */
@property (nonatomic ,assign) CGFloat timeViewHeight;


/**
 下部指标选择区高度
 */
@property (nonatomic ,assign) CGFloat indicatorViewHeight;

@property(nonatomic, copy) NSArray<JT_KLineModel *> *kLineModels;

@property (nonatomic, assign) CGFloat KlineChartTopMargin;

- (void)drawChart;

@end
