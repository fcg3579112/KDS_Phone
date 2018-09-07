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
- (void)drawDateTime {
    UIColor *color = JT_ColorDayOrNight(@"A1A1A1", @"878788");
    CGPoint drawDatePoint = self.timePostion;
    if (drawDatePoint.x > 0 && drawDatePoint.x < (self.timeViewWidth - self.timeSize.width / 2.f)) {
        [self.timeString drawAtPoint:drawDatePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineX_AxisTimeFontSize],NSForegroundColorAttributeName : color}];
    }
}

@end
