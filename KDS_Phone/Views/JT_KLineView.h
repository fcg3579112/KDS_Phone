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
@optional
/**
 复权选项点击

 @param type 复权类型
 */
- (void)JT_KLineFQSegmentClick:(JT_KLineFQType)type;

/**
 切换到竖屏状态
 */
- (void)JT_KLineViewChange2Horizontal;

/**
 切换到横屏状态
 */
- (void)JT_KLineViewChange2Vertical;


/**
 长按显示十字线时的回调

 @param show 十字线是否显示
 @param kLineModel 十字线选中的 K 线数据
 */
- (void)JT_KLineViewCrossLineShow:(BOOL)show kLineModel:(JT_KLineModel *)kLineModel;

@end
@interface JT_KLineView : UIView
/**
 顶部5日均线、10日均线显示区域的高度
 */
@property (nonatomic ,assign ) float MALineHeight;


/**
 右侧选择器的宽度
 */
@property (nonatomic ,assign ) float rightSelecterWidth;

/**
 k 线蜡烛线视图高度
 */
@property (nonatomic ,assign) float klineChartViewHeight;

/**
 中间时间区域的高度
 */
@property (nonatomic ,assign) float timeViewHeight;


/**
 成交量底部的Margin
 */
@property (nonatomic ,assign) float bottomMargin;


/**
 成交量按钮是否可以点击,如果可以点击，需要显示右边的三角
 */
@property (nonatomic ,assign) BOOL volumeButtonEnable;

/**
 下部指标选择区高度
 */
@property (nonatomic ,assign) float indicatorViewHeight;

@property(nonatomic, copy) NSArray<JT_KLineModel *> *kLineModels;
// k 线是否需要拖动和缩放
@property (nonatomic ,assign) BOOL needZoomAndScroll;
//可以设置蜡烛线区域安全区
@property (nonatomic ,assign ) float kLineChartSafeAreaHeight;
- (void)reDrawAllView;

/**
 @param orientation k 线的方向，横屏或者竖屏
 */
- (instancetype)initWithDelegate:(id <JT_KLineViewDelegate>) delegate orientation:(JT_DeviceOrientation)orientation;

/**
 隐藏十字线
 */
- (void)hidenKLineViewCrossLine;
@end

