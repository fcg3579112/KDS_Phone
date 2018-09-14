//
//  JT_KLineIndicatorAccessoryView.h
//  KDS_Phone
//  指标区上方显示 指标信息视图
//  Created by feng on 2018/9/4.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JT_KLineEnum.h"
@class JT_KLineModel;
@interface JT_KLineIndicatorAccessoryView : UIView

/**
 成交量按钮是否可以点击,如果可以点击，需要显示右边的三角
 */
@property (nonatomic ,assign) BOOL volumeButtonEnable;

- (void)updateWith:(JT_KLineModel *)model;
@end
