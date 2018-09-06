//
//  JT_KLineView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//


#import "JT_KLineView.h"
#import <Masonry.h>
#import "JT_KLineChartView.h"
#import "JT_KLineMAAccessoryView.h"
#import "JT_KLineVolumeView.h"
#import "JT_KLineTimeView.h"
#import "JT_KLineConfig.h"
#import "JT_KLineModel.h"
#import "JT_KLineFQSegment.h"
#import "JT_KLineIndicatorSegment.h"
#import "JT_KLineIndicatorAccessoryView.h"
#import "JT_PriceMarkModel.h"
#import "JT_KLinePositionModel.h"
#import <MApi.h>

#define JT_ScrollViewContentOffset   @"contentOffset"

@interface JT_KLineView () <UIScrollViewDelegate,JT_KLineFQSegmentDelegate,JT_KLineIndicatorSegmentDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
//主视图，用于绘制蜡烛线及均线
@property (nonatomic, strong) JT_KLineChartView *klineChart;
//顶部显示 MA 均线
@property (nonatomic, strong) JT_KLineMAAccessoryView *klineMA;
//成交量及各种指标视图
@property (nonatomic, strong) JT_KLineVolumeView *klineVolume;
// y 轴时间
@property (nonatomic, strong) JT_KLineTimeView *klineTimeView;
//复权 sgment
@property (nonatomic ,strong) JT_KLineFQSegment *FQSegment;
//成交量指标切换 segment
@property (nonatomic ,strong) JT_KLineIndicatorSegment *volumeSegment;

//指标上方显示对应指标信息视图
@property (nonatomic ,strong) JT_KLineIndicatorAccessoryView *indicatorAccessory;

/**
 *  需要绘制的model数组
 */
@property (nonatomic, strong) NSMutableArray <JT_KLineModel *> *needDrawKLineModels;
/**
 *  需要绘制的model位置数组
 */
@property (nonatomic, strong) NSMutableArray <JT_KLinePositionModel *>*needDrawKLinePositionModels;


/**
 成交量视图高度
 */
@property (nonatomic ,assign) float volumeViewHeight;

/**
 最高价model
 */
@property (nonatomic, strong) JT_PriceMarkModel *highestItem;
/**
 最低价model
 */
@property (nonatomic, strong) JT_PriceMarkModel *lowestItem;

//y轴最高点坐标，
@property (nonatomic ,assign) float highestPriceY;

//y轴最高低点坐标
@property (nonatomic ,assign) float lowestPriceY;

/**
 *  需要绘制Index开始值
 */
@property (nonatomic, assign) NSInteger needDrawStartIndex;
/**
 *  Index开始X的值
 */
@property (nonatomic, assign) float startXPosition;

/**
 *  旧的contentoffset值
 */
@property (nonatomic, assign) float oldContentOffsetX;


/**
 屏幕上最大的成交量;
 */
@property (nonatomic, assign) NSUInteger screenMaxVolume;


/**
 屏幕上最大及最小的KDJ 值
 */
@property (nonatomic, assign) float screenMaxKDJ;
@property (nonatomic, assign) float screenMinKDJ;

@end


@implementation JT_KLineView

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
#pragma mark JT_KLineFQSegmentDelegate

- (void)JT_KLineFQSegmentSelectedType:(JT_KLineFQType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JT_KLineFQSegmentClick:)]) {
        [self.delegate JT_KLineFQSegmentClick:type];
    }
}
#pragma mark JT_KLineIndicatorSegmentDelegate

- (void)JT_KLineIndicatorSegmentSelectedType:(JT_KLineIndicatorType)type {

}

#pragma mark KVO监听实现
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:JT_ScrollViewContentOffset])
    {
        float difValue = ABS(self.scrollView.contentOffset.x - self.oldContentOffsetX);
        if (difValue > [JT_KLineConfig kLineShadeLineWidth]) {
            self.oldContentOffsetX = self.scrollView.contentOffset.x;
            [self reDrawAllView];
        }
        [self.klineChart mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(self.scrollView.contentOffset.x);
        }];
    }
}
#pragma mark 私有方法计算坐标

- (void)p_extractNeedDrawModels {
    
    //数组个数
    float scrollViewWidth = self.scrollView.frame.size.width;
    
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
    JT_KLineModel *firstModel = kLineModels.firstObject;
    
    //屏幕上Y轴的最大价格最小价格，包括 5、10 日均线等的价格
    __block float minAssert = firstModel.lowPrice.floatValue;
    __block float maxAssert = firstModel.highPrice.floatValue;
    
    //屏幕上最高点最低点价格,不包含 5、10 日均线的价格
    __block float maxPrice = minAssert;
    __block float minPrice = maxAssert;
    
    //最高点最低点价格对应的索引
    __block NSInteger minIndex = 0;
    __block NSInteger maxIndex = 0;
    
    //屏幕上最大的成交量
    
    __block NSUInteger maxVolume = 0;
    
    
    [kLineModels enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        if ([JT_KLineConfig kLineIndicatorType] == JT_Volume) { // 计算屏幕上成交量的最大值
            if (kLineModel.tradeVolume > maxVolume) {
                maxVolume = kLineModel.tradeVolume;
            }
        } else if ([JT_KLineConfig kLineIndicatorType] == JT_KDJ) { // 计算屏幕上KDJ的最大值及最小值
            if (kLineModel.KDJ_K > self.screenMaxKDJ) {
                self.screenMaxKDJ = kLineModel.KDJ_K;
            }
            if (kLineModel.KDJ_D > self.screenMaxKDJ) {
                self.screenMaxKDJ = kLineModel.KDJ_D;
            }
            if (kLineModel.KDJ_J > self.screenMaxKDJ) {
                self.screenMaxKDJ = kLineModel.KDJ_J;
            }
            
            if (kLineModel.KDJ_K < self.screenMaxKDJ) {
                self.screenMinKDJ = kLineModel.KDJ_K;
            }
            if (kLineModel.KDJ_D < self.screenMaxKDJ) {
                self.screenMinKDJ = kLineModel.KDJ_D;
            }
            if (kLineModel.KDJ_J < self.screenMaxKDJ) {
                self.screenMaxKDJ = kLineModel.KDJ_J;
            }
        }
        
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
        
        if(kLineModel.highPrice.floatValue > maxAssert)
        {
            maxAssert = kLineModel.highPrice.floatValue;
            
        }
        if(kLineModel.lowPrice.floatValue < minAssert)
        {
            minAssert = kLineModel.lowPrice.floatValue;
        }
        
        if ([JT_KLineConfig MA5]) {
            if(kLineModel.MA5.floatValue > maxAssert)
            {
                maxAssert = kLineModel.MA5.floatValue;
            }
            if(kLineModel.MA5.floatValue < minAssert)
            {
                minAssert = kLineModel.MA5.floatValue;
            }
        }
        if ([JT_KLineConfig MA10]) {
            if(kLineModel.MA10.floatValue > maxAssert)
            {
                maxAssert = kLineModel.MA10.floatValue;
            }
            if(kLineModel.MA10.floatValue < minAssert)
            {
                minAssert = kLineModel.MA10.floatValue;
            }
        }
        if ([JT_KLineConfig MA20]) {
            if(kLineModel.MA20.floatValue > maxAssert)
            {
                maxAssert = kLineModel.MA20.floatValue;
            }
            if(kLineModel.MA20.floatValue < minAssert)
            {
                minAssert = kLineModel.MA20.floatValue;
            }
        }
        if ([JT_KLineConfig MA30]) {
            if(kLineModel.MA30.floatValue > maxAssert)
            {
                maxAssert = kLineModel.MA30.floatValue;
            }
            if(kLineModel.MA30.floatValue < minAssert)
            {
                minAssert = kLineModel.MA30.floatValue;
            }
        }
        if ([JT_KLineConfig MA60]) {
            if(kLineModel.MA60.floatValue > maxAssert)
            {
                maxAssert = kLineModel.MA60.floatValue;
            }
            if(kLineModel.MA60.floatValue < minAssert)
            {
                minAssert = kLineModel.MA60.floatValue;
            }
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
    
    self.highestPriceY = maxAssert;
    self.lowestPriceY = minAssert;
    
    // 蜡烛线视图，最大与最小 Y 值
    float minKLineY = self.KlineChartTopMargin;
    float maxKLineY = self.klineChart.frame.size.height - self.KlineChartTopMargin;
    float unitValue = (maxAssert - minAssert)/(maxKLineY - minKLineY);
    
    //成交量视图最大 Y 值

    float maxVolumeY = self.volumeViewHeight;
    
    [self.needDrawKLinePositionModels removeAllObjects];
    
    [kLineModels enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        float xPosition = self.startXPosition + idx * ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]);
        CGPoint openPoint = CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.openPrice.floatValue - minAssert)/unitValue));
        float closePointY = ABS(maxKLineY - (kLineModel.closePrice.floatValue - minAssert)/unitValue);
        
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
        CGPoint highPoint = CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.highPrice.floatValue - minAssert)/unitValue));
        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.lowPrice.floatValue - minAssert)/unitValue));
        JT_KLinePositionModel *positionModel = [JT_KLinePositionModel new];
        positionModel.closePoint = closePoint;
        positionModel.openPoint = openPoint;
        positionModel.highPoint = highPoint;
        positionModel.lowPoint = lowPoint;
        if ([JT_KLineConfig MA5]) {
            positionModel.MA5 = CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.MA5.floatValue - minAssert)/unitValue));
        }
        if ([JT_KLineConfig MA10]) {
            positionModel.MA10 = CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.MA10.floatValue - minAssert)/unitValue));
        }
        if ([JT_KLineConfig MA20]) {
            positionModel.MA20 = CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.MA20.floatValue - minAssert)/unitValue));
        }
        if ([JT_KLineConfig MA30]) {
            positionModel.MA30 = CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.MA30.floatValue - minAssert)/unitValue));
        }
        if ([JT_KLineConfig MA60]) {
            positionModel.MA60 = CGPointMake(xPosition, ABS(maxKLineY - (kLineModel.MA60.floatValue - minAssert)/unitValue));
        }
        
        //如果选中的是成交量
        if ([JT_KLineConfig kLineIndicatorType] == JT_Volume) {
            positionModel.volume = CGPointMake(xPosition, ABS(maxVolumeY - kLineModel.tradeVolume / ( maxVolume / maxVolumeY )));
            positionModel.volumeMA5 = CGPointMake(xPosition, ABS(maxVolumeY - kLineModel.volumeMA5 / ( maxVolume / maxVolumeY )));
            positionModel.volumeMA10 = CGPointMake(xPosition, ABS(maxVolumeY - kLineModel.volumeMA10 / ( maxVolume / maxVolumeY )));
            self.screenMaxVolume = maxVolume;
        }
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

#pragma mark 私有方法绘制页面
/**
 更新顶部MA信息视图
 */
- (void)p_updateTopMAAccessory {
    [self.klineMA updateMAWith:self.needDrawKLineModels.lastObject];
}

/**
 绘制蜡烛线，均线等
 */
- (void)p_drawKLineView {
    self.klineChart.needDrawKLinePositionModels = self.needDrawKLinePositionModels;
    self.klineChart.needDrawKLineModels = self.needDrawKLineModels;
    [self.klineChart drawView];
}

/**
 绘制中心时间视图
 */
- (void)p_drawTimeView {
    self.klineTimeView.needDrawKLineModels = self.needDrawKLineModels;
    self.klineTimeView.needDrawKLinePositionModels = self.needDrawKLinePositionModels;
}

/**
 画指标显示视图
 */
- (void)p_drawIndicatorAccessory {
    [self.indicatorAccessory updateWith:self.needDrawKLineModels.firstObject];
}

/**
 绘制底部成交量、指标等
 */
- (void)p_drawVolume {
    self.klineVolume.needDrawKLinePositionModels = self.needDrawKLinePositionModels;
    self.klineVolume.needDrawKLineModels = self.needDrawKLineModels;
    [self.klineVolume drawVolume:self.screenMaxVolume];
}
/**
 *  更新K线视图的宽度
 */
- (void)updateScrollViewWidth{
    //根据stockModels的个数和间隔和K线的宽度计算出self的宽度，并设置contentsize
    // 总宽度为 蜡烛线的个数 n  * 单个的宽度  + 中间 (n-1)个间隔 * 间隔的宽度
    float kLineViewWidth = self.kLineModels.count * [JT_KLineConfig kLineWidth] + (self.kLineModels.count - 1) * [JT_KLineConfig kLineGap];
    
    if(kLineViewWidth < self.scrollView.bounds.size.width) {
        kLineViewWidth = self.scrollView.bounds.size.width;
    }
    //更新scrollview的contentsize
    self.scrollView.contentSize = CGSizeMake(kLineViewWidth, self.scrollView.contentSize.height);
}
#pragma mark UIScrollViewDelegaet
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

#pragma mark 缩放执行方法
- (void)pinchGestureEvent:(UIPinchGestureRecognizer *)pinch {
    static float oldScale = 1.0f;
    float difValue = pinch.scale - oldScale;
    oldScale = pinch.scale;
    if (ABS(difValue) > JT_KLineChartScaleBound) {
        if( pinch.numberOfTouches == 2 ) {
            CGPoint p1 = [pinch locationOfTouch:0 inView:self.scrollView];
            CGPoint p2 = [pinch locationOfTouch:1 inView:self.scrollView];
            CGPoint centerPoint = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
            NSInteger leftTotalCount = floorf(centerPoint.x / ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]));
            NSInteger leftCount = leftTotalCount - floorf((centerPoint.x - self.scrollView.contentOffset.x) / ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]));
            float newWidth = [JT_KLineConfig kLineWidth] * (difValue > 0 ? (1 + JT_KLineChartScaleFactor) : (1 - JT_KLineChartScaleFactor));
            [JT_KLineConfig setkLineWith:newWidth];
            float contentOffsetX = leftCount * ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]);
            contentOffsetX = contentOffsetX > 0 ? contentOffsetX : 0;
            [self updateScrollViewWidth];
            [self.scrollView setContentOffset:CGPointMake(contentOffsetX, self.scrollView.contentOffset.y)];
            
            //当 self.scrollView contentOffset 变化时，会触发  self.klineChar 里面  KVO监听，监听里会调用 [self.klineChart drawView]，
            // 当 self.scrollView.contentOffset.x == 0 时，不会触发 KVO监听 ，所以直接调用 [self.klineChart drawView];重新绘制
            if (contentOffsetX == 0) {
                [self reDrawAllView];
            }
        }
    }
}
#pragma mark 长按手势执行方法
- (void)longPressGestureEvent:(UILongPressGestureRecognizer *)longPress {

}

#pragma mark 重绘

- (void)reDrawAllView {
    if (!self.kLineModels.count) {
        return;
    }
    //提取需要的kLineModel
    [self p_extractNeedDrawModels];
    
    //转换model为坐标model
    [self p_convertKLineModelsToPositionModels];
    self.klineChart.highestPriceY = self.highestPriceY;
    self.klineChart.lowestPriceY = self.lowestPriceY;
    
    //计算最高点最低点坐标
    if ([JT_KLineConfig showHighAndLowPrice]) {
        [self p_calculateHighestPriceAndLowestPricePosition];
        self.klineChart.highestItem = self.highestItem;
        self.klineChart.lowestItem = self.lowestItem;
    }
    [self p_updateTopMAAccessory];
    [self p_drawKLineView];
    [self p_drawTimeView];
    [self p_drawIndicatorAccessory];
    [self p_drawVolume];
    
    [self FQSegment];
    [self volumeSegment];
}

#pragma mark Setter
- (void)setKLineModels:(NSArray<JT_KLineModel *> *)kLineModels {
    if (!kLineModels.count) {
        return;
    }
    _kLineModels = kLineModels;
    
    [self updateScrollViewWidth];
    
    //设置contentOffset,会触发 observeValueForKeyPath 方法里面 reDrawAllView 方法，进行计算绘图
    float kLineViewWidth = self.kLineModels.count * ([JT_KLineConfig kLineWidth]) + (self.kLineModels.count - 1) * ([JT_KLineConfig kLineGap]);
    float offset = kLineViewWidth - self.scrollView.frame.size.width;
    if (offset > 0)
    {
        self.scrollView.contentOffset = CGPointMake(offset, 0);
    } else {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
}
#pragma mark Getter

- (UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.maximumZoomScale = 1.0f;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.scrollEnabled = NO;
        [self addSubview:_scrollView];
        [_scrollView addObserver:self forKeyPath:JT_ScrollViewContentOffset options:NSKeyValueObservingOptionNew context:nil];
        if (self.needZoomAndScroll) {
            //缩放手势
            UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureEvent:)];
            [_scrollView addGestureRecognizer:pinchGesture];
            _scrollView.scrollEnabled = YES;
        }
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureEvent:)];
        [_scrollView addGestureRecognizer:longPressGesture];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.MALineHeight);
            make.right.mas_equalTo( - self.rightSelecterWidth);
        }];
        [self layoutIfNeeded];
    }
    return _scrollView;
}
- (JT_KLineMAAccessoryView *)klineMA {
    if (!_klineMA) {
        _klineMA = [JT_KLineMAAccessoryView new];
        [self addSubview:_klineMA];
        [_klineMA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0);
            make.right.mas_equalTo(- self.rightSelecterWidth);
            make.height.mas_equalTo(self.MALineHeight);
        }];
    }
    return _klineMA;
}
- (JT_KLineTimeView *)klineTimeView {
    if (!_klineTimeView) {
        _klineTimeView = [JT_KLineTimeView new];
        [self.scrollView addSubview:_klineTimeView];
        [_klineTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.klineChart);
            make.top.equalTo(self.klineChart.mas_bottom);
            make.height.mas_offset(self.timeViewHeight);
            make.width.equalTo(self.klineChart);
        }];
    }
    return _klineTimeView;
}
- (JT_KLineChartView *)klineChart {
    if (!_klineChart) {
        _klineChart = [JT_KLineChartView new];
        [self.scrollView addSubview:_klineChart];
        [_klineChart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.scrollView);
            make.height.equalTo(@(self.klineChartViewHeight));
            make.width.equalTo(self.scrollView);
        }];
    }
    return _klineChart;
}
- (JT_KLineIndicatorAccessoryView *)indicatorAccessory {
    if (!_indicatorAccessory) {
        _indicatorAccessory = [JT_KLineIndicatorAccessoryView new];
        _indicatorAccessory.volumeButtonEnable = self.volumeButtonEnable;
        [self addSubview:_indicatorAccessory];
        [_indicatorAccessory mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.mas_equalTo(- self.rightSelecterWidth);
            make.height.mas_equalTo(self.indicatorViewHeight);
            make.top.equalTo(@(self.timeViewHeight + self.MALineHeight + self.klineChart.frame.size.height));
        }];
    }
    return _indicatorAccessory;
}
- (JT_KLineVolumeView *)klineVolume {
    if (!_klineVolume) {
        _klineVolume = [JT_KLineVolumeView new];
        [self.scrollView addSubview:_klineVolume];
        [_klineVolume mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.klineChart);
            make.top.equalTo(self.klineTimeView.mas_bottom).offset(self.indicatorViewHeight);
            make.width.equalTo(self.klineChart);
            make.height.equalTo(@(self.volumeViewHeight));
        }];
    }
    return _klineVolume;
}

- (JT_KLineFQSegment *)FQSegment {
    if (!_FQSegment) {
        _FQSegment = [JT_KLineFQSegment new];
        _FQSegment.delegate = self;
        [self addSubview:_FQSegment];
        [_FQSegment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(@(0));
            make.width.equalTo(@(self.rightSelecterWidth));
            make.height.equalTo(@(3 * JT_KLineFQSegmentItemHight));
        }];
    }
    return _FQSegment;
}

- (JT_KLineIndicatorSegment *)volumeSegment {
    if (!_volumeSegment) {
        _volumeSegment = [JT_KLineIndicatorSegment new];
        _volumeSegment.delegate = self;
        [self addSubview:_volumeSegment];
        [_volumeSegment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(@(0));
            make.width.equalTo(self.FQSegment);
            make.top.equalTo(self.FQSegment.mas_bottom);
        }];
    }
    return _volumeSegment;
}

- (float)klineChartViewHeight {
    return _klineChartViewHeight ? _klineChartViewHeight : 200;
}
- (float)volumeViewHeight {
    return self.frame.size.height - self.MALineHeight - self.klineChartViewHeight - self.timeViewHeight -  self.indicatorViewHeight - self.bottomMargin;
}
- (float)MALineHeight {
    return _MALineHeight ? _MALineHeight : 15;
}
- (float)timeViewHeight {
    return _timeViewHeight ? _timeViewHeight : 10;
}
- (float)indicatorViewHeight {
    return _indicatorViewHeight ? _indicatorViewHeight : 15;
}
- (float)KlineChartTopMargin {
    return _KlineChartTopMargin ? _KlineChartTopMargin : 12;
}
- (float)startXPosition{
    NSInteger leftArrCount = self.needDrawStartIndex;
    float x = ([JT_KLineConfig kLineWidth] / 2.f) - (self.scrollView.contentOffset.x - leftArrCount * ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]));
    return x;
}
- (NSInteger)needDrawStartIndex{
    float scrollViewOffsetX = self.scrollView.contentOffset.x < 0 ? 0 : self.scrollView.contentOffset.x;
    NSInteger leftArrCount = floorf(scrollViewOffsetX / ([JT_KLineConfig kLineGap] + [JT_KLineConfig kLineWidth]));
    _needDrawStartIndex = leftArrCount;
    return _needDrawStartIndex;
}

- (void)dealloc
{
     [_scrollView removeObserver:self forKeyPath:JT_ScrollViewContentOffset context:nil];
}
@end
