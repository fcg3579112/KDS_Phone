//
//  JT_KLineZDFView.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/13.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JT_KLineChangeRateView : UIView
/**
 k线蜡烛线区间高度
 */
@property (nonatomic ,assign) float kLineChartViewHeight;

@property (nonatomic ,assign) float kLineMAAccessoryViewHeight;

/**
 更新涨跌幅视图最高最低价

 */
- (void)updateChangeRate:(float)maxValue min:(float)minValue;
@end
