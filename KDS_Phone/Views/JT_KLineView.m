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
#import <MApi.h>
@interface JT_KLineView () <UIScrollViewDelegate,JT_KLineChartViewDelegate,JT_KLineFQSegmentDelegate,JT_KLineIndicatorSegmentDelegate>
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

@property (nonatomic, strong) MASConstraint *kLineChartHeightConstraint;
@property (nonatomic, strong) MASConstraint *kLineVolumeHeightConstraint;

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
        
    }
    return self;
}

#pragma mark JT_KLineChartViewDelegate

- (void)JT_KLineChartViewWithModels:(NSArray *)needDrawKLineModels positionModels:(NSArray *)needDrawKLinePositionModels {
    self.klineTimeView.needDrawKLineModels = needDrawKLineModels;
    self.klineTimeView.needDrawKLinePositionModels = needDrawKLinePositionModels;
    [self.klineMA updateMAWith:needDrawKLineModels.lastObject];
}
#pragma mark JT_KLineFQSegmentDelegate

- (void)JT_KLineFQSegmentSelectedType:(JT_KLineFQType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JT_KLineFQSegmentClick:)]) {
        [self.delegate JT_KLineFQSegmentClick:type];
    }
}
#pragma mark JT_KLineIndicatorSegmentDelegate

- (void)JT_KLineIndicatorSegmentSelectedType:(JT_KLineIndicatorType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JT_KLineIndicatorSegmentClick:)]) {
        [self.delegate JT_KLineIndicatorSegmentClick:type];
    }
}
#pragma mark UIScrollViewDelegaet
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

#pragma mark 缩放执行方法
- (void)pinchGestureEvent:(UIPinchGestureRecognizer *)pinch {
    static CGFloat oldScale = 1.0f;
    CGFloat difValue = pinch.scale - oldScale;
    oldScale = pinch.scale;
    if (ABS(difValue) > JT_KLineChartScaleBound) {
        if( pinch.numberOfTouches == 2 ) {
            CGPoint p1 = [pinch locationOfTouch:0 inView:self.scrollView];
            CGPoint p2 = [pinch locationOfTouch:1 inView:self.scrollView];
            CGPoint centerPoint = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
            NSInteger leftTotalCount = floorf(centerPoint.x / ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]));
            NSInteger leftCount = leftTotalCount - floorf((centerPoint.x - self.scrollView.contentOffset.x) / ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]));
            CGFloat newWidth = [JT_KLineConfig kLineWidth] * (difValue > 0 ? (1 + JT_KLineChartScaleFactor) : (1 - JT_KLineChartScaleFactor));
            [JT_KLineConfig setkLineWith:newWidth];
            CGFloat contentOffsetX = leftCount * ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]);
            contentOffsetX = contentOffsetX > 0 ? contentOffsetX : 0;
            [self.klineChart updateKlineChartWidth];
            [self.scrollView setContentOffset:CGPointMake(contentOffsetX, self.scrollView.contentOffset.y)];
            
            //当 self.scrollView contentOffset 变化时，会触发  self.klineChar 里面  KVO监听，监听里会调用 [self.klineChart drawView]，
            // 当 self.scrollView.contentOffset.x == 0 时，不会触发 KVO监听 ，所以直接调用 [self.klineChart drawView];重新绘制
            if (contentOffsetX == 0) {
                [self.klineChart drawView];
            }
        }
    }
}
#pragma mark 长按手势执行方法
- (void)longPressGestureEvent:(UILongPressGestureRecognizer *)longPress {

}

#pragma mark 重绘
- (void)drawChart
{
    [self.klineChart drawView];
//    [self klineTimeView];
//    [self klineVolume];
    
    [self FQSegment];
    [self volumeSegment];
    [self indicatorAccessory];
    [self klineVolume];
}

#pragma mark 私有方法

/**
 绘制蜡烛线，均线等
 */
- (void)p_drawKLineView {
    self.klineChart.kLineModels = self.kLineModels;
    [self.klineChart drawView];
}
#pragma mark Setter

- (void)setKLineModels:(NSArray<JT_KLineModel *> *)kLineModels {
    if (!kLineModels.count) {
        return;
    }
    //每隔 50 个显示一下时间
    [kLineModels enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx % 30 == 0) {
            obj.needShowTime = YES;
        }
    }];
    _kLineModels = kLineModels;
    
    //设置contentOffset
    CGFloat kLineViewWidth = self.kLineModels.count * ([JT_KLineConfig kLineWidth]) + (self.kLineModels.count - 1) * ([JT_KLineConfig kLineGap]);
    CGFloat offset = kLineViewWidth - self.scrollView.frame.size.width;
    if (offset > 0)
    {
        self.scrollView.contentOffset = CGPointMake(offset, 0);
    } else {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    [self p_drawKLineView];
    
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
        _klineChart.delegate = self;
        _klineChart.topAndBottomMargin = self.KlineChartTopMargin;
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
            make.height.equalTo(@(self.frame.size.height - self.MALineHeight - self.klineChartViewHeight - self.timeViewHeight -  self.indicatorViewHeight - self.bottomMargin));
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

- (CGFloat)klineChartViewHeight {
    return _klineChartViewHeight ? _klineChartViewHeight : 200;
}

- (CGFloat)MALineHeight {
    return _MALineHeight ? _MALineHeight : 15;
}
- (CGFloat)timeViewHeight {
    return _timeViewHeight ? _timeViewHeight : 10;
}
- (CGFloat)indicatorViewHeight {
    return _indicatorViewHeight ? _indicatorViewHeight : 15;
}
- (CGFloat)KlineChartTopMargin {
    return _KlineChartTopMargin ? _KlineChartTopMargin : 12;
}
@end
