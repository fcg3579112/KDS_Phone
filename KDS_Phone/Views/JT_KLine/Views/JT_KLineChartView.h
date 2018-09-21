//
//  JT_KLineChartView.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#define JT_KLineMinWidth                   2
#define JT_KLineMinHeight                  2

#import <UIKit/UIKit.h>
@class JT_KLineModel,JT_PriceMarkModel;
@interface JT_KLineChartView : UIView

/**
 *  需要绘制的model数组
 */
@property (nonatomic, strong) NSMutableArray <JT_KLineModel *> *needDrawKLineModels;

@property (nonatomic, assign) float kLineChartSafeAreaHeight;

@property (nonatomic, assign) float startXPosition;

/**
 屏幕上最大最小值
 */
@property (nonatomic ,assign) float screenMaxValue;
@property (nonatomic ,assign) float screenMinValue;

@property (nonatomic ,assign) float costLinePrice;//成本线

@property (nonatomic ,assign) CGFloat costLineY; //成本线 Y 坐标

@property (nonatomic ,assign) BOOL showCostLinePrice;
@end
