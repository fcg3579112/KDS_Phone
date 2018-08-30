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
#import "JT_KLineMAView.h"
#import "JT_KLineVolumeView.h"
#import "JT_KLineConfig.h"
#import <MApi.h>
@interface JT_KLineView () <UIScrollViewDelegate,JT_KLineChartViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
//主视图，用于绘制蜡烛线及均线
@property (nonatomic, strong) JT_KLineChartView *klineChart;
//顶部显示 MA 均线
@property (nonatomic, strong) JT_KLineMAView *klineMA;
//成交量及各种指标视图
@property (nonatomic, strong) JT_KLineVolumeView *klineVolume;
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

- (void)JT_KLineChartViewNeedDrawKLineModels:(NSArray *)needDrawKLineModels {
    
}


#pragma mark 手势
#pragma mark 缩放执行方法
- (void)event_pichMethod:(UIPinchGestureRecognizer *)pinch {
}
#pragma mark 长按手势执行方法
- (void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress {

}

#pragma mark 重绘
- (void)drawChart
{
    [self.klineChart drawView];
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
- (void)setKLineModels:(NSArray<MOHLCItem *> *)kLineModels {
    if (!kLineModels.count) {
        return;
    }
    _kLineModels = kLineModels;
    [self p_drawKLineView];
    
    //设置contentOffset
    CGFloat kLineViewWidth = self.kLineModels.count * ([JT_KLineConfig kLineWidth]) + (self.kLineModels.count + 1) * ([JT_KLineConfig kLineGap]) + 10;
    CGFloat offset = kLineViewWidth - self.scrollView.frame.size.width;
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
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(event_pichMethod:)];
        [_scrollView addGestureRecognizer:pinchGesture];
        
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressMethod:)];
        [_scrollView addGestureRecognizer:longPressGesture];
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.MALineHeight);
            make.right.mas_equalTo( - self.rightSelecterWidth);
        }];
        [self layoutIfNeeded];
    }
    return _scrollView;
}
- (JT_KLineMAView *)klineMA {
    if (!_klineMA) {
        _klineMA = [JT_KLineMAView new];
        [self addSubview:_klineMA];
        [_klineMA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0);
            make.right.mas_equalTo(self.rightSelecterWidth);
            make.height.mas_equalTo(self.MALineHeight);
        }];
    }
    return _klineMA;
}
- (JT_KLineChartView *)klineChart {
    if (!_klineChart) {
        _klineChart = [JT_KLineChartView new];
        _klineChart.delegate = self;
        _klineChart.klineViewRatio = self.klineViewRatio;
        _klineChart.topAndBottomMargin = self.KlineChartTopMargin;
        [self.scrollView addSubview:_klineChart];
        [_klineChart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView).multipliedBy(self.klineViewRatio);
            make.width.equalTo(self.scrollView);
        }];
    }
    return _klineChart;
}
- (JT_KLineVolumeView *)klineVolume {
    if (!_klineVolume) {
        _klineVolume = [JT_KLineVolumeView new];
        [self.scrollView addSubview:_klineVolume];
        [_klineVolume mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.klineChart);
            make.top.equalTo(self.klineChart.mas_bottom).offset(self.timeViewHeight + self.indicatorViewHeight);
            make.width.equalTo(self.klineChart.mas_width);
            make.height.equalTo(self.scrollView).multipliedBy(1 - self.klineViewRatio).and.offset( - self.timeViewHeight - self.indicatorViewHeight);
        }];
    }
    return _klineVolume;
}
- (CGFloat)klineViewRatio {
    return _klineViewRatio ? _klineViewRatio : 0.6;
}
- (CGFloat)MALineHeight {
    return _MALineHeight ? _MALineHeight : 10;
}
- (CGFloat)timeViewHeight {
    return _timeViewHeight ? _timeViewHeight : 10;
}
- (CGFloat)indicatorViewHeight {
    return _indicatorViewHeight ? _indicatorViewHeight : 10;
}
@end
