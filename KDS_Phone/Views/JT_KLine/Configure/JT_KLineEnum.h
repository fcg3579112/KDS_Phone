//
//  JT_KLineEnum.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/4.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#ifndef JT_KLineEnum_h
#define JT_KLineEnum_h

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
};

typedef NS_ENUM(NSInteger,JT_KLineType) {
    JT_KLineTypeUnKnow = -1,
    JT_KLineTypeDay = 0,
    JT_KLineTypeWeek,
    JT_KLineTypeMonth,
    JT_KLineType5Min,
    JT_KLineType15Min,
    JT_KLineType30Min,
    JT_KLineType60Min,
    
};

typedef NS_ENUM(NSUInteger,JT_KLineIndicatorType) {
    JT_Volume = 0,
    JT_KDJ,
    JT_MACD,
    JT_BOLL,
    JT_RSI,
    JT_DMA,
    JT_DMI,
    JT_BIAS,
    JT_CCI,
    JT_WR,
    JT_VR,
    JT_CR,
    JT_OBV
};

typedef NS_ENUM(NSUInteger,JT_KLineFQType) {
    JT_KLineFQTypeNone = 0, //不复权
    JT_KLineFQTypePre,      //前复权
    JT_KLineFQTypePost,     //后复权
};

#endif /* JT_KLineEnum_h */
