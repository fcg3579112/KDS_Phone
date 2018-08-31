//
//  JT_KLine.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/30.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLine.h"
#import "JT_KLinePositionModel.h"
#import <MApi.h>
#import "JT_KLineConfig.h"
#import "JT_ColorManager.h"
@interface JT_KLine ()
/**
 *  context
 */
@property (nonatomic, assign) CGContextRef context;

/**
 *  最后一个绘制日期点
 */
@property (nonatomic, assign) CGPoint lastDrawDatePoint;
@end
@implementation JT_KLine

#pragma mark 根据context初始化
- (instancetype)initWithContext:(CGContextRef)context
{
    self = [super init];
    if (self) {
        _context = context;
        _lastDrawDatePoint = CGPointZero;
    }
    return self;
}

#pragma 绘制K线 - 单个
- (UIColor *)drawCandleLine
{
    //判断数据是否为空
    if(!self.kLineModel || !self.context || !self.kLinePositionModel)
    {
        return UIColor.clearColor;
    }
    
    CGContextRef context = self.context;
    
    //设置画笔颜色
    UIColor *strokeColor = self.kLinePositionModel.openPoint.y < self.kLinePositionModel.closePoint.y ? [JT_KLineConfig kLineIncreaseColor] : [JT_KLineConfig kLineDecreaseColor];
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    //画中间较宽的开收盘线段-实体线
    CGContextSetLineWidth(context, [JT_KLineConfig kLineWidth]);
    const CGPoint solidPoints[] = {self.kLinePositionModel.openPoint, self.kLinePositionModel.closePoint};
    //画线
    CGContextStrokeLineSegments(context, solidPoints, 2);
    
    //画上下影线
    CGContextSetLineWidth(context, [JT_KLineConfig kLineShadeLineWidth]);
    const CGPoint shadowPoints[] = {self.kLinePositionModel.highPoint, self.kLinePositionModel.lowPoint};
    //画线
    CGContextStrokeLineSegments(context, shadowPoints, 2);
    
    return strokeColor;
}
- (void)drawDateTime {
    UIColor *color = JT_ColorDayOrNight(@"A1A1A1", @"878788");
    CGPoint drawDatePoint = CGPointMake(self.kLinePositionModel.lowPoint.x + 10, 0);
    if((CGPointEqualToPoint(self.lastDrawDatePoint, CGPointZero) || drawDatePoint.x - self.lastDrawDatePoint.x > self.timeSize.width + 50) && (drawDatePoint.x + self.timeSize.width) < 300)
    {
        [self.timeString drawAtPoint:drawDatePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineX_AxisTimeFontSize],NSForegroundColorAttributeName : color}];
        self.lastDrawDatePoint = drawDatePoint;
    }
}
@end
