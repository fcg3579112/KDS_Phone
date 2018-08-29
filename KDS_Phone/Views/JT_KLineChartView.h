//
//  JT_KLineChartView.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  JT_KLineChartViewDelegate<NSObject>
@end
@class MOHLCItem;
@interface JT_KLineChartView : UIView
@property (nonatomic ,weak) id <JT_KLineChartViewDelegate> delegate;

@property(nonatomic, copy) NSArray<MOHLCItem *> *kLineModels;
//蜡烛线的宽度
@property (nonatomic ,assign) CGFloat itemWidth;
//蜡烛线的间隔
@property (nonatomic ,assign) CGFloat itemGap;

- (void)drawView;
@end
