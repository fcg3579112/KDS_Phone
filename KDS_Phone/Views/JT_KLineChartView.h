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
/**
 *  当前需要绘制的K线模型数组
 */
- (void)JT_KLineChartViewNeedDrawKLineModels:(NSArray *)needDrawKLineModels;

/**
 需要绘制的k线坐标数组

 @param needDrawKLinePositionModels 坐标数组
 */
- (void)JT_KLineChartViewNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels;
@end
@class MOHLCItem;
@interface JT_KLineChartView : UIView
@property (nonatomic ,weak) id <JT_KLineChartViewDelegate> delegate;

@property(nonatomic, copy) NSArray<MOHLCItem *> *kLineModels;
//蜡烛线的宽度
@property (nonatomic ,assign) CGFloat itemWidth;
//蜡烛线的间隔
@property (nonatomic ,assign) CGFloat itemGap;

/**
 *  需要绘制Index开始值
 */
@property (nonatomic, assign) NSInteger needDrawStartIndex;

/**
 *  捏合点
 */
@property (nonatomic, assign) NSInteger pinchStartIndex;

/**
 k 线视图所占的比率
 */
@property (nonatomic, assign) CGFloat klineViewRatio;


@property (nonatomic, assign) CGFloat topAndBottomMargin;

- (void)drawView;
@end
