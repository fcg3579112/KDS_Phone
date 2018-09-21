//
//  JT_KLineChartView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//
#import "JT_PriceMarkModel.h"
#import "JT_KLineChartView.h"
#import "JT_KLineModel.h"
#import <Masonry.h>
#import "KDS_UtilsMacro.h"
#import "JT_KLineCandlePositionModel.h"
#import "JT_ColorManager.h"
#import "JT_DrawCandleLine.h"
#import "JT_KLineConfig.h"
#import "JT_DrawMALine.h"
#import "JT_PriceMarkModel.h"
@interface JT_KLineChartView ()
/**
 *  需要绘制的model位置数组
 */
@property (nonatomic, strong) NSMutableArray <JT_KLineCandlePositionModel *>*needDrawKLinePositionModels;

@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_MA5_Positions;
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_MA10_Positions;
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_MA20_Positions;
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_MA30_Positions;
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_MA60_Positions;

/**
 最高价model
 */
@property (nonatomic, strong) JT_PriceMarkModel *highestItem;
/**
 最低价model
 */
@property (nonatomic, strong) JT_PriceMarkModel *lowestItem;

//y轴最高点坐标，
@property (nonatomic ,assign) CGFloat highestPriceY;
//y轴最高低点坐标
@property (nonatomic ,assign) CGFloat lowestPriceY;

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
        _needDrawKLinePositionModels = @[].mutableCopy;
        _needDraw_MA5_Positions = @[].mutableCopy;
        _needDraw_MA10_Positions = @[].mutableCopy;
        _needDraw_MA20_Positions = @[].mutableCopy;
        _needDraw_MA30_Positions = @[].mutableCopy;
        _needDraw_MA60_Positions = @[].mutableCopy;
        self.backgroundColor = JT_KLineViewBackgroundColor;
    }
    return self;
}
- (void)p_convertKLineModelsToPositionModels {

    NSArray *kLineModels = self.needDrawKLineModels;
    
    //计算最小单位
    JT_KLineModel *firstModel = kLineModels.firstObject;
    
    //屏幕上Y轴的最大价格最小价格，包括 5、10 日均线等的价格
    self.screenMinValue = firstModel.lowPrice.floatValue;
    self.screenMaxValue = firstModel.highPrice.floatValue;
    
    //屏幕上最高点最低点价格,不包含 5、10 日均线的价格
    __block float maxPrice = self.screenMinValue;
    __block float minPrice = self.screenMaxValue;
    
    //最高点最低点价格对应的索引
    __block NSInteger minIndex = 0;
    __block NSInteger maxIndex = 0;
    
    [kLineModels enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 计算屏幕上最高点最低点价格,不包含 5、10 日均线的价格
        if (kLineModel.highPrice.floatValue > maxPrice) {
            maxPrice = kLineModel.highPrice.floatValue;
            maxIndex = idx;
        }
        if (kLineModel.lowPrice.floatValue < minPrice) {
            minPrice  = kLineModel.lowPrice.floatValue;
            minIndex = idx;
        }
        
        //计算屏幕上Y轴的最大价格最小价格，包括 5、10 日均线的价格
        
        self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.highPrice.floatValue);
        self.screenMinValue = MIN(self.screenMinValue, kLineModel.lowPrice.floatValue);
        
        if ([JT_KLineConfig MA5]) {
            
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.MA5.floatValue);
            
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.MA5.floatValue);
        }
        if ([JT_KLineConfig MA10]) {
            
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.MA10.floatValue);
            
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.MA10.floatValue);
        }
        if ([JT_KLineConfig MA20]) {
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.MA20.floatValue);
            
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.MA20.floatValue);
        }
        if ([JT_KLineConfig MA30]) {
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.MA30.floatValue);
            
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.MA30.floatValue);
        }
        if ([JT_KLineConfig MA60]) {
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.MA60.floatValue);
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.MA60.floatValue);
        }
        
    }];
    
    self.highestItem = [JT_PriceMarkModel new];
    self.lowestItem = [JT_PriceMarkModel new];
    self.highestItem.kLineModel = kLineModels[maxIndex];
    self.highestItem.index = maxIndex;
    self.lowestItem.kLineModel = kLineModels[minIndex];
    self.lowestItem.index = minIndex;
    
    //    maxAssert *= 1.0001;
    //    minAssert *= 0.9991;
    
    self.highestPriceY = self.screenMaxValue;
    self.lowestPriceY = self.screenMinValue;
    
    // 蜡烛线视图，最大与最小 Y 值
    float minKLineY = self.kLineChartSafeAreaHeight;
    float maxKLineY = self.frame.size.height - self.kLineChartSafeAreaHeight;
    float unitValue = (self.screenMaxValue - self.screenMinValue)/(maxKLineY - minKLineY);
    
    [self.needDrawKLinePositionModels removeAllObjects];
    [self.needDraw_MA5_Positions removeAllObjects];
    [self.needDraw_MA10_Positions removeAllObjects];
    [self.needDraw_MA20_Positions removeAllObjects];
    [self.needDraw_MA30_Positions removeAllObjects];
    [self.needDraw_MA60_Positions removeAllObjects];
    
    //计算成本线坐标，
    if (self.showCostLinePrice) {
        self.costLineY = ABS(maxKLineY - (_costLinePrice - self.screenMinValue)/unitValue);
    }
    [kLineModels enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        float xPosition = self.startXPosition + idx * ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]);
        CGPoint openPoint = CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.openPrice.floatValue - self.screenMinValue)/unitValue));
        float closePointY = ABS(maxKLineY - (kLineModel.closePrice.floatValue - self.screenMinValue)/unitValue);
        
        //如果开盘价与收盘价很接近，蜡烛线的高度就无法看清，所以做下处理，让蜡烛线的高度有一个最小值  JT_KLineMinHeight
        if (ABS(closePointY - openPoint.y) < JT_KLineMinHeight) {
            if(openPoint.y > closePointY)
            {
                openPoint.y = closePointY + JT_KLineMinHeight;
            } else if(openPoint.y < closePointY)
            {
                closePointY = openPoint.y + JT_KLineMinHeight;
            } else {
                if(idx > 0)
                {
                    JT_KLineModel *preItem = kLineModels[idx-1];
                    if(kLineModel.openPrice.floatValue > preItem.closePrice.floatValue)
                    {
                        openPoint.y = closePointY + JT_KLineMinHeight;
                    } else {
                        closePointY = openPoint.y + JT_KLineMinHeight;
                    }
                } else {
                    //idx==0即第一个时
                    JT_KLineModel *subKLineModel = kLineModels[idx+1];
                    if(kLineModel.closePrice.floatValue < subKLineModel.closePrice.floatValue)
                    {
                        openPoint.y = closePointY + JT_KLineMinHeight;
                    } else {
                        closePointY = openPoint.y + JT_KLineMinHeight;
                    }
                }
                
            }
        }
        CGPoint closePoint = CGPointMake(xPosition, closePointY);
        CGPoint highPoint = CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.highPrice.floatValue - self.screenMinValue)/unitValue));
        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.lowPrice.floatValue - self.screenMinValue)/unitValue));
        JT_KLineCandlePositionModel *positionModel = [JT_KLineCandlePositionModel new];
        positionModel.closePoint = closePoint;
        positionModel.openPoint = openPoint;
        positionModel.highPoint = highPoint;
        positionModel.lowPoint = lowPoint;
        [self.needDrawKLinePositionModels addObject:positionModel];
        
        if ([JT_KLineConfig MA5]) {
            NSValue *position = [NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.MA5.floatValue - self.screenMinValue)/unitValue))];
            [self.needDraw_MA5_Positions addObject:position];
        }
        if ([JT_KLineConfig MA10]) {
            NSValue *position = [NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.MA10.floatValue - self.screenMinValue)/unitValue))];
            [self.needDraw_MA10_Positions addObject:position];
        }
        if ([JT_KLineConfig MA20]) {
            NSValue *position = [NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.MA20.floatValue - self.screenMinValue)/unitValue))];
            [self.needDraw_MA20_Positions addObject:position];
        }
        if ([JT_KLineConfig MA30]) {
            NSValue *position = [NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.MA30.floatValue - self.screenMinValue)/unitValue))];
            [self.needDraw_MA30_Positions addObject:position];
        }
        if ([JT_KLineConfig MA60]) {
            NSValue *position = [NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.MA60.floatValue - self.screenMinValue)/unitValue))];
            [self.needDraw_MA60_Positions addObject:position];
        }
    }];
}


/**
 计算屏幕上最高点及最低对应的位置，包括2条斜线及2个文本的位置
 */
- (void)p_calculateHighestPriceAndLowestPricePosition {
    [self layoutIfNeeded];
    NSInteger canShowItemCount = self.frame.size.width / ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]);
    JT_KLineCandlePositionModel *highPositionModel = self.needDrawKLinePositionModels[self.highestItem.index];
    JT_KLineCandlePositionModel *lowPositionModel = self.needDrawKLinePositionModels[self.lowestItem.index];
    
    
    CGSize highPriceSize = [self.highestItem.kLineModel.highPrice sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineHighestPriceFontSize]}];
    CGSize lowPriceSize = [self.lowestItem.kLineModel.lowPrice sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineHighestPriceFontSize]}];
    
    //添加第一个点
    [self.highestItem.points addObject:[NSValue valueWithCGPoint:highPositionModel.highPoint]];
    [self.lowestItem.points addObject:[NSValue valueWithCGPoint:lowPositionModel.lowPoint]];
    //计算第二个点
    CGPoint highPoint = highPositionModel.highPoint;
    CGRect highPriceRect;
    if (self.highestItem.index > canShowItemCount / 2) { // 最高点在屏幕右边，所以斜线是朝向左边的
        highPoint = CGPointMake(highPoint.x - JT_kLineMarkLineWidth, highPoint.y - JT_KLineMarkLineHeight);
        highPriceRect = CGRectMake(highPoint.x - highPriceSize.width, highPoint.y - highPriceSize.height / 2.f, highPriceSize.width, highPriceSize.height);
    } else { // 最高点在屏幕左边，所以斜线是朝向右边的
        highPoint = CGPointMake(highPoint.x + JT_kLineMarkLineWidth, highPoint.y - JT_KLineMarkLineHeight);
        highPriceRect = CGRectMake(highPoint.x, highPoint.y - highPriceSize.height / 2.f, highPriceSize.width, highPriceSize.height);
    }
    [self.highestItem.points addObject:[NSValue valueWithCGPoint:highPoint]];
    self.highestItem.priceRect = highPriceRect;
    CGPoint lowPoint = lowPositionModel.lowPoint;
    CGRect lowPriceRect;
    if (self.lowestItem.index > canShowItemCount / 2) { // 最低点在屏幕右边，所以斜线是朝向左边的
        lowPoint = CGPointMake(lowPoint.x - JT_kLineMarkLineWidth, lowPoint.y + JT_KLineMarkLineHeight);
        lowPriceRect = CGRectMake(lowPoint.x - lowPriceSize.width, lowPoint.y - lowPriceSize.height / 2.f, lowPriceSize.width, lowPriceSize.height);
    } else { // 最低点在屏幕左边，所以斜线是朝向右边的
        lowPoint = CGPointMake(lowPoint.x + JT_kLineMarkLineWidth, lowPoint.y + JT_KLineMarkLineHeight);
        lowPriceRect  = CGRectMake(lowPoint.x, lowPoint.y - lowPriceSize.height / 2.f, lowPriceSize.width, lowPriceSize.height);
    }
    [self.lowestItem.points addObject:[NSValue valueWithCGPoint: lowPoint]];
    self.lowestItem.priceRect = lowPriceRect;
}

#pragma mark Setter

- (void)setNeedDrawKLineModels:(NSMutableArray<JT_KLineModel *> *)needDrawKLineModels {
    _needDrawKLineModels = needDrawKLineModels;
    [self p_convertKLineModelsToPositionModels];
    //计算最高点最低点坐标
    if ([JT_KLineConfig showHighAndLowPrice]) {
        [self p_calculateHighestPriceAndLowestPricePosition];
    }
    [self setNeedsDisplay];
}
#pragma mark Getter
- (BOOL)showCostLinePrice {
    if (self.costLinePrice > self.screenMinValue && self.costLinePrice < self.screenMaxValue) {
        return YES;
    }
    return NO;
}
#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
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
    
    //画成本线
    if (self.showCostLinePrice) {
        UIColor *color = JT_ColorDayOrNight(@"FF6E33 ", @"FF6E33 ");
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        //设置虚线宽度
        CGContextSetLineWidth(context, 1);
        //设置虚线绘制起点
        CGContextMoveToPoint(context, 0, _costLineY);
        //设置虚线绘制终点
        CGContextAddLineToPoint(context,rect.size.width, _costLineY);
        //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
        CGFloat arr[] = {5,5};
        //下面最后一个参数“2”代表排列的个数。
        CGContextSetLineDash(context, 5, arr, 2);
        CGContextDrawPath(context, kCGPathStroke);
    }
    CGContextSetLineDash(context, 0, NULL, 0);
    //画蜡烛线
    JT_DrawCandleLine *kLineDrawUtil = [[JT_DrawCandleLine alloc]initWithContext:context];
    [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(JT_KLineCandlePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JT_KLineModel *kLineModel = self.needDrawKLineModels[idx];
        UIColor *color = kLineModel.closePrice.floatValue > kLineModel.openPrice.floatValue ? JT_KLineIncreaseColor : JT_KLineDecreaseColor;
        [kLineDrawUtil drawBarWithColor:color width:[JT_KLineConfig kLineWidth] begin:obj.openPoint end:obj.closePoint];
        [kLineDrawUtil drawBarWithColor:color width:[JT_KLineConfig kLineShadeLineWidth] begin:obj.lowPoint end:obj.highPoint];
    }];
    
    JT_DrawMALine *drawLine = [[JT_DrawMALine alloc] initWithContext:context];
    //画均线 5日、10日等
    if ([JT_KLineConfig MA5]) {
        [drawLine drawLineWithColor:JT_KLineMA5Color positions:self.needDraw_MA5_Positions];
    }
    if ([JT_KLineConfig MA10]) {
        [drawLine drawLineWithColor:JT_KLineMA10Color positions:self.needDraw_MA10_Positions];
    }
    if ([JT_KLineConfig MA20]) {
        [drawLine drawLineWithColor:JT_KLineMA20Color positions:self.needDraw_MA20_Positions];
    }
    if ([JT_KLineConfig MA30]) {
        [drawLine drawLineWithColor:JT_KLineMA30Color positions:self.needDraw_MA30_Positions];
    }
    if ([JT_KLineConfig MA60]) {
        [drawLine drawLineWithColor:JT_KLineMA60Color positions:self.needDraw_MA60_Positions];
    }

    //画Y轴上对应的价格坐标
    [self drawY_AxisPrice:rect context:context];
    
    //画最高点及最低点价格
    if ([JT_KLineConfig showHighAndLowPrice]) {
        [self drawHigtestAndLowestPriceInRect:(CGRect)rect context:context];
    }
}
/**
 画最高点及最低点价格标示

 */
- (void)drawHigtestAndLowestPriceInRect:(CGRect)rect context:(CGContextRef)context {
    
    CGContextSetStrokeColorWithColor(context, JT_KLineY_AxisPriceColor.CGColor);
    CGContextSetLineWidth(context, 1);
    if (self.lowestItem.index > 0 && self.lowestItem.index < self.needDrawKLineModels.count - 1) {
        CGPoint lowPoints[2] = {((NSValue *)self.lowestItem.points[0]).CGPointValue , ((NSValue *)self.lowestItem.points[1]).CGPointValue};
        CGContextStrokeLineSegments(context, lowPoints, 2);
        //画最低点价格
        [self.lowestItem.kLineModel.lowPrice drawAtPoint:self.lowestItem.priceRect.origin withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineHighestPriceFontSize],NSForegroundColorAttributeName : JT_KLineY_AxisPriceColor}];
    }
    if (self.highestItem.index > 0 && self.highestItem.index < self.needDrawKLineModels.count - 1) {
        CGPoint hightPoints[2] = {((NSValue *)self.highestItem.points[0]).CGPointValue, ((NSValue *)self.highestItem.points[1]).CGPointValue};
        CGContextStrokeLineSegments(context, hightPoints, 2);
        //画最高点价格
        [self.highestItem.kLineModel.highPrice drawAtPoint:self.highestItem.priceRect.origin withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineHighestPriceFontSize],NSForegroundColorAttributeName : JT_KLineY_AxisPriceColor}];
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
    
    UIFont *font = [UIFont systemFontOfSize:JT_KLineY_AxisPriceFontSize];
    
    CGSize highPriceSize = [highPrice sizeWithAttributes:@{ NSFontAttributeName : font}];
    CGRect highPriceRect = CGRectMake(rect.origin.x, rect.origin.y + 2, highPriceSize.width, highPriceSize.height);
    [highPrice drawInRect:highPriceRect withAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : JT_KLineY_AxisPriceColor}];
    
    CGSize lowPriceSize = [lowPrice sizeWithAttributes:@{ NSFontAttributeName : font}];
    CGRect lowPriceRect = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - lowPriceSize.height - 2, lowPriceSize.width, lowPriceSize.height);
    [lowPrice drawInRect:lowPriceRect withAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : JT_KLineY_AxisPriceColor}];
    
    CGSize middlePriceSize = [middlePrice sizeWithAttributes:@{ NSFontAttributeName : font}];
    CGRect middlePriceRect = CGRectMake(rect.origin.x, rect.size.height / 2.f - middlePriceSize.height / 2, middlePriceSize.width, middlePriceSize.height);
    [middlePrice drawInRect:middlePriceRect withAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : JT_KLineY_AxisPriceColor}];
}
@end
