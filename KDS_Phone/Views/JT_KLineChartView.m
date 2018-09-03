//
//  JT_KLineChartView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineChartView.h"
#import <MApi.h>
#import <Masonry.h>
#import "JT_KLinePositionModel.h"
#import "JT_ColorManager.h"
#import "JT_KLine.h"
#import "JT_KLineConfig.h"
#define JT_ScrollViewContentOffset   @"contentOffset"

#define JT_kLineMarkLineWidth     23
#define JT_KLineMarkLineHeight    6

/**
 存储最高点，最低点信息
 */
@interface JT_PriceMarkModel : NSObject
@property (nonatomic ,strong) MOHLCItem *kLineModel;
@property (nonatomic ,strong) NSMutableArray *points; //斜线上的2个点
@property (nonatomic ,assign) CGRect priceRect;
//在屏幕上的索引，用于判断该标识是遍左还偏右
@property (nonatomic ,assign) NSInteger index;
@end
@implementation JT_PriceMarkModel
- (NSMutableArray *)points {
    if (!_points) {
        _points = @[].mutableCopy;
    }
    return _points;
}
@end
@interface JT_KLineChartView ()
@property (nonatomic, weak, readonly) UIScrollView *parentScrollView;
/**
 *  旧的contentoffset值
 */
@property (nonatomic, assign) CGFloat oldContentOffsetX;
/**
 *  Index开始X的值
 */
@property (nonatomic, assign) CGFloat startXPosition;

/**
 *  需要绘制的model数组
 */
@property (nonatomic, strong) NSMutableArray <MOHLCItem *> *needDrawKLineModels;

/**
 *  需要绘制的model位置数组
 */
@property (nonatomic, strong) NSMutableArray <JT_KLinePositionModel *>*needDrawKLinePositionModels;


/**
 最高价model
 */
@property (nonatomic, strong) JT_PriceMarkModel *highestItem;

/**
 最低价model
 */
@property (nonatomic, strong) JT_PriceMarkModel *lowestItem;

@property (nonatomic ,strong) NSString *highPrice;

@property (nonatomic ,strong) NSString *lowPrice;

@property (nonatomic ,strong) NSString *middlePrice;

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
        _needDrawKLineModels = @[].mutableCopy;
        _needDrawKLinePositionModels = @[].mutableCopy;
        _needDrawStartIndex = 0;
        _oldContentOffsetX = 0;
    }
    return self;
}
- (void)drawView {
    //提取需要的kLineModel
    [self p_extractNeedDrawModels];
    //转换model为坐标model
    [self p_convertKLineModelsToPositionModels];
    
    //响应代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(JT_KLineChartViewWithModels:positionModels:)]) {
        [self.delegate JT_KLineChartViewWithModels:self.needDrawKLineModels.copy positionModels:self.needDrawKLinePositionModels.copy];
    }
    //计算最高点最低点坐标
    [self p_calculateHighestPriceAndLowestPricePosition];
    
    //间接调用drawRect方法
    [self setNeedsDisplay];
}

- (void)didMoveToSuperview {
    _parentScrollView = (UIScrollView *)self.superview;
    [_parentScrollView addObserver:self forKeyPath:JT_ScrollViewContentOffset options:NSKeyValueObservingOptionNew context:nil];
    [super didMoveToSuperview];
}
#pragma mark KVO监听实现
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:JT_ScrollViewContentOffset])
    {
        CGFloat difValue = ABS(self.parentScrollView.contentOffset.x - self.oldContentOffsetX);
        if (difValue > [JT_KLineConfig kLineGap]) {
            self.oldContentOffsetX = self.parentScrollView.contentOffset.x;
            [self drawView];
        }
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.parentScrollView);
            make.left.equalTo(self.parentScrollView).offset(self.parentScrollView.contentOffset.x);
        }];
    }
}
#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置View的背景颜色
    UIColor *backgroundColor = JT_ColorDayOrNight(@"FFFFFF", @"1B1C20");
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    //画背景方格线
    CGFloat lineWidth = 1.0;
    UIColor *gridLineColor = JT_ColorDayOrNight(@"F5F7F9", @"14171C");
    CGContextSetStrokeColorWithColor(context, gridLineColor.CGColor);
    CGContextSetLineWidth(context, lineWidth * 2);
    // 画边框
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
    //画中间的3条横线
    CGFloat gap = rect.size.height / 4.f;
    CGContextSetLineWidth(context, lineWidth);
    for (int i = 1; i < 4; i ++) {
        CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + i * gap);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + i * gap);
    }
    CGContextStrokePath(context);
    if (!self.kLineModels.count) {
        return;
    }
    
    //画蜡烛线
    JT_KLine *kLine = [[JT_KLine alloc]initWithContext:context];
    kLine.maxY = self.frame.size.height - self.topAndBottomMargin;
    [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(JT_KLinePositionModel * _Nonnull kLinePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        kLine.kLinePositionModel = kLinePositionModel;
        kLine.kLineModel = self.needDrawKLineModels[idx];
        [kLine drawCandleLine];
    }];
    
    //画Y轴上对应的价格坐标
    [self drawY_AxisPrice:rect context:context];
    
    //画最高点及最低点价格
    [self drawHigtestAndLowestPriceInRect:(CGRect)rect context:context];

}
/**
 画最高点及最低点价格标示

 */
- (void)drawHigtestAndLowestPriceInRect:(CGRect)rect context:(CGContextRef)context {
    UIColor *markLineColor = JT_ColorDayOrNight(@"A1A1A1", @"878788");
    CGContextSetStrokeColorWithColor(context, markLineColor.CGColor);
    CGContextSetLineWidth(context, 1);
    CGPoint lowPoints[2];
    lowPoints[0] = ((NSValue *)self.lowestItem.points[0]).CGPointValue;
    lowPoints[1] = ((NSValue *)self.lowestItem.points[1]).CGPointValue;
    CGPoint hightPoints[2];
    hightPoints[0] = ((NSValue *)self.highestItem.points[0]).CGPointValue;
    hightPoints[1] = ((NSValue *)self.highestItem.points[1]).CGPointValue;
    CGContextStrokeLineSegments(context, lowPoints, 2);
    CGContextStrokeLineSegments(context, hightPoints, 2);
    //画最高点价格
    [self.highestItem.kLineModel.highPrice drawAtPoint:self.highestItem.priceRect.origin withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineHighestPriceFontSize],NSForegroundColorAttributeName : markLineColor}];
    //画最低点价格
    [self.lowestItem.kLineModel.lowPrice drawAtPoint:self.lowestItem.priceRect.origin withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineHighestPriceFontSize],NSForegroundColorAttributeName : markLineColor}];
}

/**
 画Y轴上的价格，三个价格，最高、最低、及中间价

 @param rect kLineRect
 @param context 上下文
 */
- (void)drawY_AxisPrice:(CGRect)rect context:(CGContextRef)context {
    NSString *highPrice = self.highestItem.kLineModel.highPrice;
    NSString *lowPrice = self.highestItem.kLineModel.lowPrice;
    NSString *middlePrice = [NSString stringWithFormat:@"%.2f",(highPrice.floatValue + lowPrice.floatValue) / 2.f];
    
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
    
//    //计算出的新的最高点与之前的最高点不一样，就开始画最高点
//    if (![self.highPrice isEqualToString:highPrice]) {
//        self.highPrice = highPrice;
//
//    }
//    if (![self.lowPrice isEqualToString:lowPrice]) {
//        self.lowPrice = lowPrice;
//
//    }
//    if (![self.middlePrice isEqualToString:middlePrice]) {
//
//    }
}

#pragma mark 私有方法

- (void)p_extractNeedDrawModels {
    
    //数组个数
    CGFloat scrollViewWidth = self.parentScrollView.frame.size.width;
    
    //屏幕上可以绘制的蜡烛线个数为.
    NSInteger needDrawKLineCount = floorf(scrollViewWidth / ([JT_KLineConfig kLineGap] + [JT_KLineConfig kLineWidth])) + 1;
    

    //起始位置
    NSInteger needDrawKLineStartIndex;
    
    //当 KLine 总的数量小于屏幕上可以画的数量时
    if (self.kLineModels.count < needDrawKLineCount) {
        needDrawKLineStartIndex = 0;
    } else {
        needDrawKLineStartIndex = self.needDrawStartIndex;
    }
    
    [self.needDrawKLineModels removeAllObjects];
    
    if(needDrawKLineStartIndex + needDrawKLineCount < self.kLineModels.count)
    {
        [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount)]];
    } else{
        [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.kLineModels.count - needDrawKLineStartIndex)]];
    }
}
- (void)p_convertKLineModelsToPositionModels {
    
    if(!self.needDrawKLineModels) {
        return;
    }
    NSArray *kLineModels = self.needDrawKLineModels;
    
    //计算最小单位
    MOHLCItem *firstModel = kLineModels.firstObject;
    //找出屏幕上的最大值与最小值
    
    //计算出5日均线、10日、均线等
    __block CGFloat minAssert = firstModel.lowPrice.floatValue;
    __block CGFloat maxAssert = firstModel.highPrice.floatValue;

    
    __block NSInteger minIndex = 0;
    __block NSInteger maxIndex = 0;
    [kLineModels enumerateObjectsUsingBlock:^(MOHLCItem * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(kLineModel.highPrice.floatValue > maxAssert)
        {
            maxAssert = kLineModel.highPrice.floatValue;
            maxIndex = idx;
        }
        if(kLineModel.lowPrice.floatValue < minAssert)
        {
            minAssert = kLineModel.lowPrice.floatValue;
            minIndex = idx;
        }
    }];
    self.highestItem = [JT_PriceMarkModel new];
    self.lowestItem = [JT_PriceMarkModel new];
    self.highestItem.kLineModel = kLineModels[maxIndex];
    self.highestItem.index = maxIndex;
    self.lowestItem.kLineModel = kLineModels[minIndex];
    self.lowestItem.index = minIndex;
    
    maxAssert *= 1.0001;
    minAssert *= 0.9991;
    
    CGFloat minY = self.topAndBottomMargin;
    CGFloat maxY = self.parentScrollView.frame.size.height * self.klineViewRatio - self.topAndBottomMargin;
    CGFloat unitValue = (maxAssert - minAssert)/(maxY - minY);
    
    [self.needDrawKLinePositionModels removeAllObjects];
    
    [kLineModels enumerateObjectsUsingBlock:^(MOHLCItem * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        //由于 k 线数据，很多时候没有昨收，所以当天的昨收取前一天的收盘价
        if (idx > 0) {
            MOHLCItem *preItem = kLineModels[idx -1];
            kLineModel.referencePrice = preItem.closePrice;
        }
        CGFloat xPosition = self.startXPosition + idx * ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]);
        CGPoint openPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.openPrice.floatValue - minAssert)/unitValue));
        CGFloat closePointY = ABS(maxY - (kLineModel.closePrice.floatValue - minAssert)/unitValue);
        
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
                    MOHLCItem *preItem = kLineModels[idx-1];
                    if(kLineModel.openPrice.floatValue > preItem.closePrice.floatValue)
                    {
                        openPoint.y = closePointY + JT_KLineMinHeight;
                    } else {
                        closePointY = openPoint.y + JT_KLineMinHeight;
                    }
                } else {
                    //idx==0即第一个时
                    MOHLCItem *subKLineModel = kLineModels[idx+1];
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
        CGPoint highPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.highPrice.floatValue - minAssert)/unitValue));
        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.lowPrice.floatValue - minAssert)/unitValue));
        JT_KLinePositionModel *positionModel = [JT_KLinePositionModel new];
        positionModel.closePoint = closePoint;
        positionModel.openPoint = openPoint;
        positionModel.highPoint = highPoint;
        positionModel.lowPoint = lowPoint;
        [self.needDrawKLinePositionModels addObject:positionModel];
    }];
}

/**
 计算屏幕上最高点及最低对应的位置，包括2条斜线及2个文本的位置
 */
- (void)p_calculateHighestPriceAndLowestPricePosition {
    [self layoutIfNeeded];
    NSInteger canShowItemCount = self.frame.size.width / ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]);
    JT_KLinePositionModel *highPositionModel = self.needDrawKLinePositionModels[self.highestItem.index];
    JT_KLinePositionModel *lowPositionModel = self.needDrawKLinePositionModels[self.lowestItem.index];
    
    
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
/**
 *  更新K线视图的宽度
 */
- (void)updateKlineChartWidth{
    //根据stockModels的个数和间隔和K线的宽度计算出self的宽度，并设置contentsize
    // 总宽度为 蜡烛线的个数 n  * 单个的宽度  + 中间 (n-1)个间隔 * 间隔的宽度
    CGFloat kLineViewWidth = self.kLineModels.count * [JT_KLineConfig kLineWidth] + (self.kLineModels.count - 1) * [JT_KLineConfig kLineGap];
    
    if(kLineViewWidth < self.parentScrollView.bounds.size.width) {
        kLineViewWidth = self.parentScrollView.bounds.size.width;
    }
    //更新scrollview的contentsize
    self.parentScrollView.contentSize = CGSizeMake(kLineViewWidth, self.parentScrollView.contentSize.height);
}
#pragma mark Setter
- (void)setKLineModels:(NSArray<MOHLCItem *> *)kLineModels {
    _kLineModels = kLineModels;
    [self updateKlineChartWidth];
}
#pragma mark Getter
- (CGFloat)startXPosition{
    NSInteger leftArrCount = self.needDrawStartIndex;
    CGFloat x = ([JT_KLineConfig kLineWidth] / 2.f) - (self.parentScrollView.contentOffset.x - leftArrCount * ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]));
    return x;
}
- (NSInteger)needDrawStartIndex{
    CGFloat scrollViewOffsetX = self.parentScrollView.contentOffset.x < 0 ? 0 : self.parentScrollView.contentOffset.x;
    NSInteger leftArrCount = floorf(scrollViewOffsetX / ([JT_KLineConfig kLineGap] + [JT_KLineConfig kLineWidth]));
    _needDrawStartIndex = leftArrCount;
    return _needDrawStartIndex;
}
- (void)dealloc
{
    [_parentScrollView removeObserver:self forKeyPath:JT_ScrollViewContentOffset context:nil];
}
@end
