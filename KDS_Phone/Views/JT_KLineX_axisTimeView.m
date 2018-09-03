//
//  JT_KLineX_axisTimeView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/31.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineX_axisTimeView.h"
#import "JT_KLinePositionModel.h"
#import "JT_KLine.h"
#import "JT_KLineConfig.h"
#import "JT_ColorManager.h"
#import "JT_KLineModel.h"
#import "NSDate+KDS_Manage.h"
@implementation JT_KLineX_axisTimeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setNeedDrawKLineModels:(NSArray<JT_KLineModel *> *)needDrawKLineModels {
    _needDrawKLineModels = needDrawKLineModels;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置View的背景颜色
    
    UIColor *backgroundColor = JT_ColorDayOrNight(@"FFFFFF", @"1B1C20");
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    if (!self.needDrawKLineModels.count) {
        return;
    }
    //画时间

    //计算日期对应的size; 日、月、周 k 时间格式是 2017-01-01，分钟 k 时间日期是  2017-01-01 08:00
    NSString *timeFormat = @"yyyy-MM-dd HH:mm";
    JT_TimelineAndKlineItemType kLineType = [JT_KLineConfig kLineType];
    if ( kLineType == JT_SegmentItemTypeKlineDay ||
         kLineType == JT_SegmentItemTypeKlineWeek ||
         kLineType == JT_SegmentItemTypeKlineMonth ||
         kLineType == JT_SegmentItemTypeKlineWeek ) {
        timeFormat = @"yyyy-MM-dd";
    }
    
    CGSize dateStringSize = [timeFormat sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineX_AxisTimeFontSize]}];
    JT_KLine *kLine = [[JT_KLine alloc]initWithContext:context];
    kLine.timeViewWidth = self.frame.size.width;
    [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(JT_KLinePositionModel * _Nonnull kLinePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        JT_KLineModel *item  = self.needDrawKLineModels[idx];
        if (item.needShowTime) {
            kLine.kLinePositionModel = kLinePositionModel;
            kLine.kLineModel = self.needDrawKLineModels[idx];
            kLine.timeSize = dateStringSize;
            kLine.timeString = [self formateDateFrom:kLine.kLineModel.datetime];
            [kLine drawDateTime];
        }
    }];
}


/**
 把时间 ‘’ 转成 ‘yyyy-MM-dd HH:mm’ 或 ‘yyyy-MM-dd ’

 @param dateString 需要格式的日期，只能是 ‘20180831131523’ 格式
 @return 格式后的日期
 */
- (NSString *)formateDateFrom:(NSString *)dateString {
    
    JT_TimelineAndKlineItemType kLineType = [JT_KLineConfig kLineType];
    NSString *resultString = [NSString stringWithFormat:@"%@-%@-%@",[dateString substringWithRange:NSMakeRange(0, 4)],[dateString substringWithRange:NSMakeRange(4, 2)],[dateString substringWithRange:NSMakeRange(6, 2)]];
    
    //如果是分钟 k，需要在后面添加上时间
    if ( kLineType == JT_SegmentItemTypeKline5Min ||
        kLineType == JT_SegmentItemTypeKline15Min ||
        kLineType == JT_SegmentItemTypeKline30Min ||
        kLineType == JT_SegmentItemTypeKline60Min ) {
        resultString = [NSString stringWithFormat:@"%@ %@:%@",resultString,[dateString substringWithRange:NSMakeRange(8, 2)],[dateString substringWithRange:NSMakeRange(10, 2)]];
    }
    return resultString;
}
@end
