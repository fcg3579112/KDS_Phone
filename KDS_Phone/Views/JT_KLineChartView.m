//
//  JT_KLineChartView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineChartView.h"
#import "JT_KLineModel.h"
#import <Masonry.h>
#import "KDS_UtilsMacro.h"
#import "JT_KLinePositionModel.h"
#import "JT_ColorManager.h"
#import "JT_DrawCandleLine.h"
#import "JT_KLineConfig.h"
#import "JT_DrawMALine.h"
#import "JT_PriceMarkModel.h"
@interface JT_KLineChartView ()

@end

@implementation JT_KLineChartView

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
- (void)drawView {
    //间接调用drawRect方法
    [self setNeedsDisplay];
}

#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置View的背景颜色
    
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, JT_KLineViewBackgroundColor.CGColor);
    CGContextFillRect(context, rect);
    //画背景方格线
    CGContextSetStrokeColorWithColor(context, JT_KLineViewGridLineColor.CGColor);
    CGContextSetLineWidth(context, JT_KLineViewGridLineWidth * 2);
    // 画边框
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
    //画中间的3条横线
    float gap = rect.size.height / 4.f;
    CGContextSetLineWidth(context, JT_KLineViewGridLineWidth);
    for (int i = 1; i < 4; i ++) {
        CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + i * gap);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + i * gap);
    }
    CGContextStrokePath(context);    
    //画蜡烛线
    JT_DrawCandleLine *kLine = [[JT_DrawCandleLine alloc]initWithContext:context];
    [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(JT_KLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        kLine.kLinePositionModel = obj;
        kLine.kLineModel = self.needDrawKLineModels[idx];
        [kLine drawCandleLine];
    }];
    
    //画均线 5日、10日等
    [self drawAllMAline:context];

    //画Y轴上对应的价格坐标
    [self drawY_AxisPrice:rect context:context];
    
    //画最高点及最低点价格
    if ([JT_KLineConfig showHighAndLowPrice]) {
        [self drawHigtestAndLowestPriceInRect:(CGRect)rect context:context];
    }
}

//画均线 5日、10日等
- (void)drawAllMAline:(CGContextRef)context {
    JT_DrawMALine *drawMALineUtil = [[JT_DrawMALine alloc] initWithContext:context];
    drawMALineUtil.kLinePositionModels = self.needDrawKLinePositionModels;
    [drawMALineUtil drawMA5];
    [drawMALineUtil drawMA10];
    [drawMALineUtil drawMA20];
    [drawMALineUtil drawMA30];
    [drawMALineUtil drawMA60];
}

/**
 画最高点及最低点价格标示

 */
- (void)drawHigtestAndLowestPriceInRect:(CGRect)rect context:(CGContextRef)context {
    UIColor *markLineColor = JT_ColorDayOrNight(@"A1A1A1", @"878788");
    CGContextSetStrokeColorWithColor(context, markLineColor.CGColor);
    CGContextSetLineWidth(context, 1);
    if (self.lowestItem.index > 0 && self.lowestItem.index < self.needDrawKLineModels.count - 1) {
        CGPoint lowPoints[2] = {((NSValue *)self.lowestItem.points[0]).CGPointValue , ((NSValue *)self.lowestItem.points[1]).CGPointValue};
        CGContextStrokeLineSegments(context, lowPoints, 2);
        //画最低点价格
        [self.lowestItem.kLineModel.lowPrice drawAtPoint:self.lowestItem.priceRect.origin withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineHighestPriceFontSize],NSForegroundColorAttributeName : markLineColor}];
    }
    if (self.highestItem.index > 0 && self.highestItem.index < self.needDrawKLineModels.count - 1) {
        CGPoint hightPoints[2] = {((NSValue *)self.highestItem.points[0]).CGPointValue, ((NSValue *)self.highestItem.points[1]).CGPointValue};
        CGContextStrokeLineSegments(context, hightPoints, 2);
        //画最高点价格
        [self.highestItem.kLineModel.highPrice drawAtPoint:self.highestItem.priceRect.origin withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineHighestPriceFontSize],NSForegroundColorAttributeName : markLineColor}];
    }
}

/**
 画Y轴上的价格，三个价格，最高、最低、及中间价

 @param rect kLineRect
 @param context 上下文
 */
- (void)drawY_AxisPrice:(CGRect)rect context:(CGContextRef)context {
    NSString *highPrice = [NSString stringWithFormat:@"%.2f",self.highestPriceY];
    NSString *lowPrice = [NSString stringWithFormat:@"%.2f",self.lowestPriceY];
    NSString *middlePrice = [NSString stringWithFormat:@"%.2f",(self.highestPriceY + self.lowestPriceY) / 2.f];
    UIColor *color = JT_ColorDayOrNight(@"A1A1A1", @"878788");
    UIFont *font = [UIFont systemFontOfSize:JT_KLineY_AxisPriceFontSize];
    
    CGSize highPriceSize = [highPrice sizeWithAttributes:@{ NSFontAttributeName : font}];
    CGRect highPriceRect = CGRectMake(rect.origin.x, rect.origin.y + 2, highPriceSize.width, highPriceSize.height);
    [highPrice drawInRect:highPriceRect withAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : color}];
    
    CGSize lowPriceSize = [lowPrice sizeWithAttributes:@{ NSFontAttributeName : font}];
    CGRect lowPriceRect = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - lowPriceSize.height - 2, lowPriceSize.width, lowPriceSize.height);
    [lowPrice drawInRect:lowPriceRect withAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : color}];
    
    CGSize middlePriceSize = [middlePrice sizeWithAttributes:@{ NSFontAttributeName : font}];
    CGRect middlePriceRect = CGRectMake(rect.origin.x, rect.size.height / 2.f - middlePriceSize.height / 2, middlePriceSize.width, middlePriceSize.height);
    [middlePrice drawInRect:middlePriceRect withAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : color}];
}
@end
