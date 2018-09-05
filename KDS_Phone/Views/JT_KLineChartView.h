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
@protocol  JT_KLineChartViewDelegate<NSObject>
@optional;
/**
 *  当前需要绘制的K线模型数组
 */
- (void)JT_KLineChartViewWithModels:(NSArray *)needDrawKLineModels positionModels:(NSArray *)needDrawKLinePositionModels;


/**
 把蜡烛线滑动后，起点的索引及 xPosition 回传到主页面，因为成交量的绘制也需要 索引及 xPosition;
 */
- (void)JT_KLineChartViewNeedDrawStartIndexChange:(NSUInteger)startIndex;
- (void)JT_KLineChartViewNeedDrawStartIndexXPositionChange:(CGFloat)xPosition;

@end
@class JT_KLineModel,JT_KLinePositionModel,JT_PriceMarkModel;
@interface JT_KLineChartView : UIView
@property (nonatomic ,weak) id <JT_KLineChartViewDelegate> delegate;
/**
 *  需要绘制Index开始值
 */
@property (nonatomic, assign) NSInteger needDrawStartIndex;

/**
 *  Index开始X的值
 */
@property (nonatomic, assign) CGFloat startXPosition;
/**
 k 线视图所占的比率
 */
@property (nonatomic, assign) CGFloat klineViewRatio;


@property (nonatomic, assign) CGFloat topAndBottomMargin;

/**
 *  需要绘制的model数组
 */
@property (nonatomic, strong) NSMutableArray <JT_KLineModel *> *needDrawKLineModels;

/**
 *  需要绘制的model位置数组
 */
@property (nonatomic, strong) NSMutableArray <JT_KLinePositionModel *>*needDrawKLinePositionModels;

/**
 最高价model
 */
@property (nonatomic, strong) JT_PriceMarkModel *highestItem;
/**
 最低价model
 */
@property (nonatomic, strong) JT_PriceMarkModel *lowestItem;

//y轴最高点坐标，
@property (nonatomic ,assign) CGFloat highestPriceY;
//y轴最高低点坐标
@property (nonatomic ,assign) CGFloat lowestPriceY;

- (void)drawView;

@end
