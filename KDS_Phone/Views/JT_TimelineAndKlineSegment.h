//
//  JT_TimelineOrKlineSegment.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/27.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,JT_DeviceOrientation) {
    JT_DeviceOrientationVertical,
    JT_DeviceOrientationHorizontal,
};

typedef NS_ENUM(NSInteger,JT_TimelineAndKlineItemType) {
    JT_SegmentItemTypeTimeline = 0,
    JT_SegmentItemTypeTimeline5Day,
    JT_SegmentItemTypeKlineDay,
    JT_SegmentItemTypeKlineWeek,
    JT_SegmentItemTypeKlineMonth,
    JT_SegmentItemTypeKline5Min,
    JT_SegmentItemTypeKline15Min,
    JT_SegmentItemTypeKline30Min,
    JT_SegmentItemTypeKline60Min,
    JT_SegmentItemTypeSetting,
    JT_SegmentItemTypeSimilarKline,
};

@protocol JT_TimelineAndKlineSegmentDelegate <NSObject>
- (void)JT_TimelineAndKlineSegmentItemClick:(JT_TimelineAndKlineItemType)itemType;
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

