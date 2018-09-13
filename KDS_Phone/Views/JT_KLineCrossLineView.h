//
//  JT_KLineCrossLineView.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/12.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JT_KLineModel;
@interface JT_KLineCrossLineView : UIView
@property (nonatomic ,assign) CGFloat timeViewTopMargin;
@property (nonatomic ,assign) CGFloat timeViewHeight;
@property (nonatomic ,assign) CGFloat rightMargin;

/**
 指标信息显示视图
 */
@property (nonatomic ,assign) CGFloat indexAccessoryViewHeight;

/**
 k 线视图下部安全区的高度
 */
@property (nonatomic ,assign) CGFloat kLineChartSafeAreaHeight;
- (void)updateCrossLine:(CGPoint)point valueY:(NSString *)value changeRate:(NSString *)changeRate kLineModel:(JT_KLineModel *)kLineModel;
@end
