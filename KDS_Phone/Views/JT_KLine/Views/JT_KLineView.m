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
#import "JT_KLineCrossLineView.h"
#import "JT_KLineChangeRateView.h"
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

/**
 显示涨跌幅标尺视图
 */
@property (nonatomic ,strong) JT_KLineChangeRateView *rightChangeRateView;

/**
 画十字线视图
 */
@property (nonatomic ,strong) JT_KLineCrossLineView *crossLineView;

//指标上方显示对应指标信息视图
@property (nonatomic ,strong) JT_KLineIndicatorAccessoryView *indicatorAccessory;

/**
 *  需要绘制的model数组
 */
@property (nonatomic, strong) NSMutableArray <JT_KLineModel *> *needDrawKLineModels;

/**
 成交量视图高度
 */
@property (nonatomic ,assign) float volumeViewHeight;

/**
 最高价model
 */

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

@property (nonatomic ,weak) id <JT_KLineViewDelegate> delegate;

@property (nonatomic ,assign) JT_DeviceOrientation orientation;

@property (nonatomic ,strong) NSTimer *delayHidenCrossLineTimer;

@end


@implementation JT_KLineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithDelegate:(id <JT_KLineViewDelegate>) delegate orientation:(JT_DeviceOrientation)orientation {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _orientation = orientation;
        _needDrawKLineModels = @[].mutableCopy;
        _needDrawStartIndex = 0;
        _oldContentOffsetX = 0;
    }
    return self;
}
#pragma mark 加载数据
/**
 更新所有的 K 线数据,用于第一次加载 k 线页面、 k 线类型变化、及前后复权的切换。
 效果是： k 线页面刷新后，k 偏移到最右端，显示最新的数据
 */
- (void)updateKLineWithModels:(NSArray <MOHLCItem *>*)models {
    if (models.count == 0) {
        return;
    }
    [models enumerateObjectsUsingBlock:^(MOHLCItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JT_KLineModel *model = [[JT_KLineModel alloc] initWithModel:obj];
        [self.kLineModels addObject:model];
        model.allKLineModel = self.kLineModels;
        [model initData];
    }];
    
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
/**
 加载 k 线历史数据，效果是：视图保持现在的状态，可以向右拖动，显示历史数据
 
 */
- (void)loadWithHistoryModels:(NSArray <MOHLCItem *>*)models {
    if (models.count == 0) {
        return;
    }
    //存储历史数据，历史数据
    NSMutableArray *historyArray = @[].mutableCopy;
    [models enumerateObjectsUsingBlock:^(MOHLCItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JT_KLineModel *model = [[JT_KLineModel alloc] initWithModel:obj];
        [historyArray addObject:model];
    }];
    NSArray <JT_KLineModel *>*oldDataArray = self.kLineModels.copy;
    NSMutableArray <JT_KLineModel *>*oldDataArrayM = @[].mutableCopy;
    [oldDataArray enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JT_KLineModel *model = [JT_KLineModel new];
        model.openPrice = obj.openPrice;
        model.closePrice = obj.closePrice;
        model.highPrice = obj.highPrice;
        model.lowPrice = obj.lowPrice;
        model.tradeVolume = obj.tradeVolume;
        model.referencePrice = obj.referencePrice;
        model.datetime = obj.datetime;
        [oldDataArrayM addObject:model];
    }];
    
    [self.kLineModels removeAllObjects];
    [self.kLineModels addObjectsFromArray:historyArray];
    [self.kLineModels addObjectsFromArray:oldDataArrayM];

    [self.kLineModels enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.allKLineModel = self.kLineModels;
    }];
    
    CGPoint offset = self.scrollView.contentOffset;

    [self updateScrollViewWidth];
    
    self.scrollView.contentOffset = CGPointMake(offset.x + models.count * ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]), 0);
}

/**
 加载最新的几条数据。
 
 */
- (void)reloadWithNewestModels:(NSArray <MOHLCItem *>*)models {
    if (models.count == 0) {
        return;
    }
    //如果之前有数据,只需要找到对应日期，把数据更新成最新的
    if (self.kLineModels.count) {
        MOHLCItem *firstModel = models.firstObject;
        //找出需要更新的Model对应的索引
        NSInteger beginUpdaeIndex = -1;
        for (NSInteger i = self.kLineModels.count - 1; i >= 0; i --) {
            JT_KLineModel *model = self.kLineModels[i];
            if ([model.datetime isEqualToString:firstModel.datetime]) {
                beginUpdaeIndex = i;
            }
        }
        //未找到需要更新的Model对应的索引时，走刷新逻辑
        if (beginUpdaeIndex == -1) {
            [self updateKLineWithModels:models];
        } else {
            
            // 移除索引处及其后面的数据,然后加入最新的数据
            [self.kLineModels removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(beginUpdaeIndex, self.kLineModels.count - beginUpdaeIndex)]];
            [models enumerateObjectsUsingBlock:^(MOHLCItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                JT_KLineModel *model = [[JT_KLineModel alloc] initWithModel:obj];
                [self.kLineModels addObject:model];
                model.allKLineModel = self.kLineModels;
            }];
            [self updateScrollViewWidth];
            [self reDrawAllView];
        }
        
    } else { //如果之前没有数据，就走刷新页面逻辑
        [self updateKLineWithModels:models];
    }
}

#pragma mark JT_KLineFQSegmentDelegate

- (void)JT_KLineFQSegmentSelectedType:(JT_KLineFQType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JT_KLineFQSegmentClick:)]) {
        [self.delegate JT_KLineFQSegmentClick:type];
    }
    [self hidenCrossLine];
}
#pragma mark JT_KLineIndicatorSegmentDelegate

- (void)JT_KLineIndicatorSegmentSelectedType:(JT_KLineIndicatorType)type {
    [self hidenCrossLine];
    [JT_KLineConfig setkLineIndicatorType:type];
    [self p_drawIndicatorAccessory];
    [self p_drawVolume];
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
    
    self.klineChart.startXPosition = self.startXPosition;
    
    self.klineChart.kLineChartSafeAreaHeight = self.kLineChartSafeAreaHeight;
    
    self.klineChart.needDrawKLineModels = self.needDrawKLineModels;
    
}

/**
 绘制中心时间视图
 */
- (void)p_drawTimeView {
    self.klineTimeView.startXPosition = self.startXPosition;
    self.klineTimeView.needDrawKLineModels = self.needDrawKLineModels;
}

/**
 画指标显示视图
 */
- (void)p_drawIndicatorAccessory {
    [self.indicatorAccessory updateWith:self.needDrawKLineModels.lastObject];
}
/**
 绘制底部成交量、指标等
 */
- (void)p_drawVolume {
    
    self.klineVolume.maxY = self.volumeViewHeight;
    self.klineVolume.startXPosition = self.startXPosition;
    self.klineVolume.needDrawKLineModels = self.needDrawKLineModels;
}

/**
 更新右边涨跌幅
 */
- (void)p_updateRightChangeRate {
    JT_KLineModel *firstObject = self.needDrawKLineModels.firstObject;
    float max = (self.klineChart.screenMaxValue - firstObject.openPrice.floatValue) / firstObject.openPrice.floatValue * 100;
    float min  = (self.klineChart.screenMinValue - firstObject.openPrice.floatValue) / firstObject.openPrice.floatValue * 100;
    [self.rightChangeRateView updateChangeRate:max min:min];
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
#pragma mark 计算十字线 Y 轴的值
- (NSString *)calculateCrossLineValueY:(CGFloat)y {
    NSString *stringValue;
    y = y < 0 ? 0 : y;
    float yMax = self.frame.size.height - self.bottomMargin - self.MALineHeight;
    y = y > yMax ? yMax : y;
    
    if (y >= (self.kLineChartSafeAreaHeight) && y <= (self.klineChartViewHeight - self.kLineChartSafeAreaHeight)) { // k 线区域
        float maxY = self.klineChartViewHeight - self.kLineChartSafeAreaHeight;
        float minY = self.kLineChartSafeAreaHeight;
        float unitValue = (self.klineChart.screenMaxValue - self.klineChart.screenMinValue)/(maxY - minY);
        float value = (maxY - y) * unitValue + self.klineChart.screenMinValue;
        stringValue = [NSString stringWithFormat:@"%.2f",value];
    } else if (y > (self.klineChartViewHeight + self.timeViewHeight + self.indicatorViewHeight ) && y < yMax) { // 指数区域
        float maxY = self.volumeViewHeight;
        float minY = 0;
        float unitValue = (self.klineVolume.screenMaxValue - self.klineVolume.screenMinValue)/(maxY - minY);
        y = y - self.klineChartViewHeight - self.timeViewHeight - self.indicatorViewHeight;
        float value = (maxY - y) * unitValue + self.klineVolume.screenMinValue;
        if ([JT_KLineConfig kLineIndicatorType] == JT_Volume || [JT_KLineConfig kLineIndicatorType] == JT_OBV) {
            stringValue = formatVolume(value);
        } else {
            stringValue = [NSString stringWithFormat:@"%.2f",value];
        }
    } else { // 其他区域
        stringValue = @"";
    }
    return stringValue;
}

/**
 #pragma mark 计算十字线 Y 轴涨跌幅
 */
- (NSString *)calculateCrossLineRightChangeRate:(CGFloat)y {
    NSString *stringValue;
    y = y < 0 ? 0 : y;
    float yMax = self.frame.size.height - self.bottomMargin - self.MALineHeight;
    y = y > yMax ? yMax : y;
    JT_KLineModel *firstModel = self.needDrawKLineModels.firstObject;
    float maxChangeRate = (self.klineChart.screenMaxValue - firstModel.openPrice.floatValue) / firstModel.openPrice.floatValue * 100;
    float minChangeRate = (self.klineChart.screenMinValue - firstModel.openPrice.floatValue) / firstModel.openPrice.floatValue * 100;
    if (y >= (self.kLineChartSafeAreaHeight) && y <= (self.klineChartViewHeight - self.kLineChartSafeAreaHeight)) { // k 线区域
        float maxY = self.klineChartViewHeight - self.kLineChartSafeAreaHeight;
        float minY = self.kLineChartSafeAreaHeight;
        float unitValue = (maxChangeRate - minChangeRate)/(maxY - minY);
        float value = (maxY - y) * unitValue + minChangeRate;
        stringValue = [NSString stringWithFormat:@"%.2f%%",value];
    }
    return stringValue;
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
            
            if (self.needDrawKLineModels.count * ([JT_KLineConfig kLineGap] + [JT_KLineConfig kLineWidth]) < self.scrollView.frame.size.width
                && self.kLineModels.count * ([JT_KLineConfig kLineGap] + [JT_KLineConfig kLineWidth]) > self.scrollView.frame.size.width ) {
                float kLineViewWidth = self.kLineModels.count * ([JT_KLineConfig kLineWidth]) + (self.kLineModels.count - 1) * ([JT_KLineConfig kLineGap]);
                float offset = kLineViewWidth - self.scrollView.frame.size.width;
                [self.scrollView setContentOffset:CGPointMake(offset, 0)];
            }
            
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
    CGPoint point = [longPress locationInView:self];
    NSString *valueY = [self calculateCrossLineValueY:point.y];
    NSString *changeRate = [self calculateCrossLineRightChangeRate:point.y];
    float itemWidth = ([JT_KLineConfig kLineGap] + [JT_KLineConfig kLineWidth]);
    NSInteger index = floorf((point.x - self.startXPosition) / itemWidth);
    index = index >= self.needDrawKLineModels.count ? self.needDrawKLineModels.count - 1 : index;
    index = index < 0 ? 0 : index;
    
    point.x = self.startXPosition + index * itemWidth;
    JT_KLineModel *kLineModel = self.needDrawKLineModels[index];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            //显示十字线时，禁止页面滑动、显示十字线、显示右边涨跌幅标尺视图、关闭定时器
            self.scrollView.scrollEnabled = NO;
            self.crossLineView.hidden = NO;
            self.rightChangeRateView.hidden = NO;
            [_delayHidenCrossLineTimer invalidate];
            [self.indicatorAccessory updateWith:kLineModel];
            [self.klineMA updateMAWith:kLineModel];
            [self.crossLineView updateCrossLine:point valueY:valueY changeRate:changeRate kLineModel:kLineModel];
            break;
        case UIGestureRecognizerStateChanged:
            [self.indicatorAccessory updateWith:kLineModel];
            [self.klineMA updateMAWith:kLineModel];
            [self.crossLineView updateCrossLine:point valueY:valueY changeRate:changeRate kLineModel:kLineModel];
            break;
        case UIGestureRecognizerStateEnded:
            [self p_delayHidenCrossLine];
            break;
        case UIGestureRecognizerStateCancelled:
            [self p_delayHidenCrossLine];
            break;
        default:
            break;
    }
}
#pragma mark 双击手势，切换到竖屏
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(JT_KLineViewChange2Vertical)]) {
        [_delegate JT_KLineViewChange2Vertical];
    }
}
#pragma mark 单击手势，切换到横屏
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(JT_KLineViewChange2Horizontal)]) {
        [_delegate JT_KLineViewChange2Horizontal];
    }
}

/**
 切换指标
 */
- (void)changeIndex:(UITapGestureRecognizer *)tap {
    JT_KLineIndicatorType type = [JT_KLineConfig kLineIndicatorType];
    if (type == JT_OBV) {
        type = JT_Volume;
    } else {
        type ++;
    }
    [JT_KLineConfig setkLineIndicatorType:type];
    [self p_drawIndicatorAccessory];
    [self p_drawVolume];
    [self.volumeSegment update];
    [self hidenCrossLine];
}
#pragma mark 重绘

- (void)reDrawAllView {
    if (!self.kLineModels.count) {
        return;
    }
    //提取需要的kLineModel
    [self p_extractNeedDrawModels];
    
    [self p_updateTopMAAccessory];
    [self p_drawKLineView];
    [self p_drawTimeView];
    [self p_drawIndicatorAccessory];
    [self p_drawVolume];
    [self FQSegment];
    [self volumeSegment];
    [self p_updateRightChangeRate];
    if (self.orientation == JT_DeviceOrientationHorizontal) {
        
    }
}
#pragma mark 隐藏十字线
- (void)p_delayHidenCrossLine {
    _delayHidenCrossLineTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hidenCrossLine) userInfo:nil repeats:NO];
}

- (void)hidenCrossLine {
    self.scrollView.scrollEnabled = YES;
    self.crossLineView.hidden = YES;
    self.rightChangeRateView.hidden = YES;
    JT_KLineModel *lastModel = self.needDrawKLineModels.lastObject;
    [self.klineMA updateMAWith:lastModel];
    [self.indicatorAccessory updateWith:lastModel];
    [_delayHidenCrossLineTimer invalidate];
    _delayHidenCrossLineTimer = nil;
}


#pragma mark Getter
- (NSMutableArray <JT_KLineModel *>*)kLineModels {
    if (!_kLineModels) {
        _kLineModels = @[].mutableCopy;
    }
    return _kLineModels;
}

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
        _scrollView.decelerationRate = 0.2;
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
        longPressGesture.minimumPressDuration = 0.5;
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
        if (_orientation == JT_DeviceOrientationVertical) {
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
            [_klineChart addGestureRecognizer:singleTap];
        } else {
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
            doubleTap.numberOfTapsRequired = 2;
            [_klineChart addGestureRecognizer:doubleTap];
        }
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
- (JT_KLineCrossLineView *)crossLineView {
    if (!_crossLineView) {
        _crossLineView = [JT_KLineCrossLineView new];
        _crossLineView.userInteractionEnabled = NO;
        _crossLineView.timeViewTopMargin = self.klineChartViewHeight;
        _crossLineView.timeViewHeight = self.timeViewHeight;
        _crossLineView.kLineChartSafeAreaHeight = self.kLineChartSafeAreaHeight;
        _crossLineView.indexAccessoryViewHeight = self.indicatorViewHeight;
        _crossLineView.rightMargin = self.rightSelecterWidth;
        [self addSubview:_crossLineView];
        [_crossLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(self.MALineHeight, 0, self.bottomMargin,0));
        }];
    }
    return _crossLineView;
}
- (JT_KLineVolumeView *)klineVolume {
    if (!_klineVolume) {
        _klineVolume = [JT_KLineVolumeView new];
        [self.scrollView addSubview:_klineVolume];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIndex:)];
        [_klineVolume addGestureRecognizer:tap];
        [_klineVolume mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.klineChart);
            make.top.equalTo(self.klineTimeView.mas_bottom).offset(self.indicatorViewHeight);
            make.width.equalTo(self.klineChart);
            make.height.equalTo(@(self.volumeViewHeight));
        }];
    }
    return _klineVolume;
}
- (JT_KLineChangeRateView *)rightChangeRateView {
    if (!_rightChangeRateView) {
        _rightChangeRateView = [JT_KLineChangeRateView new];
        _rightChangeRateView.kLineMAAccessoryViewHeight = self.MALineHeight;
        _rightChangeRateView.kLineChartViewHeight  = self.klineChartViewHeight;
        _rightChangeRateView.backgroundColor = JT_KLineViewBackgroundColor;
        _rightChangeRateView.hidden = YES;
        [self addSubview:_rightChangeRateView];
        [self bringSubviewToFront:self.crossLineView];
        [self bringSubviewToFront:self.indicatorAccessory];
        [_rightChangeRateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(@0);
            make.width.equalTo(@(self.rightSelecterWidth));
        }];
    }
    return _rightChangeRateView;
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
    return _timeViewHeight ? _timeViewHeight : 13;
}
- (float)indicatorViewHeight {
    return _indicatorViewHeight ? _indicatorViewHeight : 15;
}
- (float)kLineChartSafeAreaHeight {
    return _kLineChartSafeAreaHeight ? _kLineChartSafeAreaHeight : 12;
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
