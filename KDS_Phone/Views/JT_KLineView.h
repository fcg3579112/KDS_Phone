//
//  JT_KLineView.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JT_KLineEnum.h"
@class JT_KLineModel;

@protocol JT_KLineViewDelegate <NSObject>

/**
 复权选项点击

 @param type 复权类型
 */
- (void)JT_KLineFQSegmentClick:(JT_KLineFQType)type;

@end
@interface JT_KLineView : UIView

@property (nonatomic ,weak) id <JT_KLineViewDelegate> delegate;

/**
 顶部5日均线、10日均线显示区域的高度
 */
@property (nonatomic ,assign ) CGFloat MALineHeight;


/**
 右侧选择器的宽度
 */
@property (nonatomic ,assign ) CGFloat rightSelecterWidth;

/**
 k 线蜡烛线视图高度
 */
@property (nonatomic ,assign) CGFloat klineChartViewHeight;

/**
 中间时间区域的高度
 */
@property (nonatomic ,assign) CGFloat timeViewHeight;


/**
 成交量底部的Margin
 */
@property (nonatomic ,assign) CGFloat bottomMargin;




/**
 下部指标选择区高度
 */
@property (nonatomic ,assign) CGFloat indicatorViewHeight;

@property(nonatomic, copy) NSArray<JT_KLineModel *> *kLineModels;
// k 线是否需要拖动和缩放
@property (nonatomic ,assign) BOOL needZoomAndScroll;
//可以设置蜡烛线区域top And Bottom Margin
@property (nonatomic ,assign ) CGFloat KlineChartTopMargin;
- (void)reDrawAllView;

@end

