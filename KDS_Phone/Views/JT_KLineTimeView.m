//
//  JT_KLineX_axisTimeView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/31.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineTimeView.h"
#import "JT_DrawCandleLine.h"
#import "JT_KLineConfig.h"
#import "JT_ColorManager.h"
#import "JT_KLineModel.h"

/**
 *  需要绘制的model位置数组
 */

@interface JT_KLineTimeView ()
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDrawKLinePositionModels;
@end
@implementation JT_KLineTimeView

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
        self.backgroundColor = JT_KLineViewBackgroundColor;
        _needDrawKLinePositionModels = @[].mutableCopy;
    }
    return self;
}

- (void)setNeedDrawKLineModels:(NSArray<JT_KLineModel *> *)needDrawKLineModels {
    _needDrawKLineModels = needDrawKLineModels;
    [self p_convertKLineModelsToPositionModels];
    [self setNeedsDisplay];
}
- (void)p_convertKLineModelsToPositionModels {
    [self.needDrawKLinePositionModels removeAllObjects];
    NSArray <JT_KLineModel *>*models = self.needDrawKLineModels;
    [models enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float xPosition = self.startXPosition + idx * ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]);
        CGPoint point = CGPointMake(xPosition, 0);
        NSValue *value = [NSValue valueWithCGPoint:point];
        [self.needDrawKLinePositionModels addObject:value];
    }];
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
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
    JT_DrawCandleLine *kLine = [[JT_DrawCandleLine alloc]initWithContext:context];
    kLine.timeViewWidth = self.frame.size.width;
    [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JT_KLineModel *item  = self.needDrawKLineModels[idx];
        if (item.needShowTime) {
            kLine.timePostion = obj.CGPointValue;
            kLine.timeSize = dateStringSize;
            JT_KLineModel *model = self.needDrawKLineModels[idx];
            kLine.timeString = [self formateDateFrom:model.datetime];
            [kLine drawDateTime];
        }
    }];
}


/**
 把时间 ‘’ 转成 ‘yyyy-MM-dd HH:mm’ 或 ‘yyyy-MM-dd ’

 @param dateString 需要格式的日期，只能是 ‘2018 0831 1315 23’ 格式
 @return 格式后的日期
 */
- (NSString *)formateDateFrom:(NSString *)dateString {
    if (dateString.length < 12) {
        return @"";
    }
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
