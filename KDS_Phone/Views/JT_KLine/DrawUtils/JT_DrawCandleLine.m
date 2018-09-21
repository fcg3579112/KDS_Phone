//
//  JT_KLine.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/30.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_DrawCandleLine.h"
#import <MApi.h>
#import "JT_KLineConfig.h"
#import "JT_ColorManager.h"
@interface JT_DrawCandleLine ()
/**
 *  context
 */
@property (nonatomic, assign) CGContextRef context;

@end
@implementation JT_DrawCandleLine

#pragma mark 根据context初始化
- (instancetype)initWithContext:(CGContextRef)context
{
    self = [super init];
    if (self) {
        _context = context;
    }
    return self;
}

- (void)drawBarWithColor:(UIColor *)color width:(float)width begin:(CGPoint)beginPoint end:(CGPoint)endPoint {
    CGContextRef context = self.context;
    //设置画笔颜色
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context,width);
    const CGPoint solidPoints[] = {beginPoint, endPoint};
    //画线
    CGContextStrokeLineSegments(context, solidPoints, 2);
}
- (void)drawAMLineWithColor:(UIColor *)color width:(float)width left:(CGPoint)openPoint right:(CGPoint)closePoint {
    
    CGContextRef context = self.context;
    //设置画笔颜色
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context,width);
    //坐标开盘线
    const CGPoint leftSolidPoints[] = {openPoint, CGPointMake(openPoint.x - ([JT_KLineConfig kLineWidth] / 2), openPoint.y)};
    CGContextStrokeLineSegments(context, leftSolidPoints, 2);
    //右边收盘线
    const CGPoint rightSolidPoints[] = {closePoint, CGPointMake(closePoint.x + ([JT_KLineConfig kLineWidth] / 2), closePoint.y)};
    CGContextStrokeLineSegments(context, rightSolidPoints, 2);
}
- (void)drawDateTime {
    
    CGPoint drawDatePoint = self.timePostion;
    if (drawDatePoint.x > 0 && drawDatePoint.x < (self.timeViewWidth - self.timeSize.width / 2.f)) {
        [self.timeString drawAtPoint:drawDatePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineX_AxisTimeFontSize],NSForegroundColorAttributeName : JT_KLineY_AxisPriceColor}];
    }
}

- (void)drawRoundPoint:(CGPoint)point {
    CGContextRef context = self.context;
    CGContextAddArc(context, point.x, point.y, 2, 0, M_PI * 2, 0);
}

@end
