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

#define JT_ScrollViewContentOffset   @"contentOffset"
@interface JT_KLineChartView ()
@property (nonatomic, weak, readonly) UIScrollView *parentScrollView;
/**
 *  旧的contentoffset值
 */
@property (nonatomic, assign) CGFloat oldContentOffsetX;
@end
@implementation JT_KLineChartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawView {
    //提取需要的kLineModel
    [self p_extractNeedDrawModels];
    //转换model为坐标model
    [self p_convertKLineModelsToPositionModels];
    
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
        if(difValue >= self.itemGap + self.itemWidth)
        {
            self.oldContentOffsetX = self.parentScrollView.contentOffset.x;
            [self drawView];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.parentScrollView).offset(self.parentScrollView.contentOffset.x);
                make.width.equalTo(self.parentScrollView);
            }];
        }
    }
}
- (void)drawRect:(CGRect)rect {
    
}
#pragma makr 私有方法
- (void)p_extractNeedDrawModels {
//    CGFloat lineGap = [Y_StockChartGlobalVariable kLineGap];
//    CGFloat lineWidth = [Y_StockChartGlobalVariable kLineWidth];
    
//    //数组个数
//    CGFloat scrollViewWidth = self.parentScrollView.frame.size.width;
//    NSInteger needDrawKLineCount = (scrollViewWidth - lineGap)/(lineGap+lineWidth);
//
//    //起始位置
//    NSInteger needDrawKLineStartIndex ;
//
//    if(self.pinchStartIndex > 0) {
//        needDrawKLineStartIndex = self.pinchStartIndex;
//        _needDrawStartIndex = self.pinchStartIndex;
//        self.pinchStartIndex = -1;
//    } else {
//        needDrawKLineStartIndex = self.needDrawStartIndex;
//    }
//
//    NSLog(@"这是模型开始的index-----------%lu",needDrawKLineStartIndex);
//    [self.needDrawKLineModels removeAllObjects];
//
//    //赋值数组
//    if(needDrawKLineStartIndex < self.kLineModels.count)
//    {
//        if(needDrawKLineStartIndex + needDrawKLineCount < self.kLineModels.count)
//        {
//            [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount)]];
//        } else{
//            [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.kLineModels.count - needDrawKLineStartIndex)]];
//        }
//    }
//    //响应代理
//    if(self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLineModels:)])
//    {
//        [self.delegate kLineMainViewCurrentNeedDrawKLineModels:self.needDrawKLineModels];
//    }
//    return self.needDrawKLineModels;
}
- (void)p_convertKLineModelsToPositionModels {
    
}
#pragma mark Getter

- (CGFloat)itemGap {
    return _itemGap ? _itemGap : 1;
}
- (CGFloat)itemWidth {
    return _itemWidth ? _itemWidth : 2;
}
- (void)dealloc
{
    [_parentScrollView removeObserver:self forKeyPath:JT_ScrollViewContentOffset context:nil];
}
@end
