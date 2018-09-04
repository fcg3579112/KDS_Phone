//
//  JT_TimelineOrKlineSegment.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/27.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JT_KLineEnum.h"
@protocol JT_TimelineAndKlineSegmentDelegate <NSObject>
@optional
- (void)JT_TimelineAndKlineSegmentItemClick:(JT_TimelineAndKlineItemType)itemType;
- (void)JT_TimelineAndKlineSegmentSettingClick;
- (void)JT_TimelineAndKlineSegmentSimilarKlineClick;
@end

@interface JT_TimelineAndKlineSegment : UIView


/**
 该方法返回控件坐标 origin 为(0,0)

 @param orientation 横屏与竖屏
 @return 返回横屏或者竖屏下的控件，而不是控件的排列方式
 */
+ (instancetype)segmentWithType:(JT_DeviceOrientation)orientation delegte:(id <JT_TimelineAndKlineSegmentDelegate>)delegate;

/**
 是否支持相似 k 线
 */
@property (nonatomic ,assign) BOOL supportedSimilarKline;


/**
 设置 item 默认选中项，第一次显示页面时调用。
 */
@property (nonatomic ,assign) JT_TimelineAndKlineItemType seletedItemType;
@end

