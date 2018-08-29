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

#define JT_ScrollViewContentOffset   @"contentOffset"
@interface JT_KLineChartView ()
@property (nonatomic, weak, readonly) UIScrollView *parentScrollView;
/**
 *  旧的contentoffset值
 */
@property (nonatomic, assign) CGFloat oldContentOffsetX;
/**
 *  Index开始X的值
 */
@property (nonatomic, assign) NSInteger startXPosition;

/**
 *  需要绘制的model数组
 */
@property (nonatomic, strong) NSMutableArray <MOHLCItem *> *needDrawKLineModels;

/**
 *  需要绘制的model位置数组
 */
@property (nonatomic, strong) NSMutableArray <JT_KLinePositionModel *>*needDrawKLinePositionModels;

/**
 最高价，默认保留2位小数
 */
@property (nonatomic, strong) NSString *highestPrice;

/**
 最低价，默认保留2位小数
 */
@property (nonatomic, strong) NSString *lowestPrice;

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
    
    //数组个数
    CGFloat scrollViewWidth = self.parentScrollView.frame.size.width;
    
    NSInteger needDrawKLineCount = (scrollViewWidth - self.itemGap)/(self.itemGap + self.itemWidth);
    //起始位置
    NSInteger needDrawKLineStartIndex ;
    if(self.pinchStartIndex > 0) {
        needDrawKLineStartIndex = self.pinchStartIndex;
        _needDrawStartIndex = self.pinchStartIndex;
        self.pinchStartIndex = -1;
    } else {
        needDrawKLineStartIndex = self.needDrawStartIndex;
    }
    NSLog(@"这是模型开始的index-----------%lu",needDrawKLineStartIndex);
    [self.needDrawKLineModels removeAllObjects];
    
    if(needDrawKLineStartIndex < self.kLineModels.count)
    {
        if(needDrawKLineStartIndex + needDrawKLineCount < self.kLineModels.count)
        {
            [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount)]];
        } else{
            [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.kLineModels.count - needDrawKLineStartIndex)]];
        }
    }
    //响应代理
    if(self.delegate && [self.delegate respondsToSelector:@selector(JT_KLineChartViewNeedDrawKLineModels:)])
    {
        [self.delegate JT_KLineChartViewNeedDrawKLineModels:self.needDrawKLineModels];
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
    
    self.highestPrice = [NSString stringWithFormat:@"%.2f",maxAssert];
    self.lowestPrice = [NSString stringWithFormat:@"%.2f",minAssert];
    
    [kLineModels enumerateObjectsUsingBlock:^(MOHLCItem * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(kLineModel.highPrice.floatValue > maxAssert)
        {
            maxAssert = kLineModel.highPrice.floatValue;
        }
        if(kLineModel.lowPrice.floatValue < minAssert)
        {
            minAssert = kLineModel.lowPrice.floatValue;
        }
    }];
    
    maxAssert *= 1.0001;
    minAssert *= 0.9991;
    
    CGFloat minY = self.topAndBottomMargin;
    CGFloat maxY = self.parentScrollView.frame.size.height * self.klineViewRatio - self.topAndBottomMargin;
    CGFloat unitValue = (maxAssert - minAssert)/(maxY - minY);
    
    [self.needDrawKLinePositionModels removeAllObjects];
    __block NSMutableArray *mArray = @[].mutableCopy;
    
    [kLineModels enumerateObjectsUsingBlock:^(MOHLCItem * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        //由于 k 线数据，很多时候没有昨收，所以当天的昨收取前一天的收盘价
        if (idx > 0) {
            MOHLCItem *preItem = kLineModels[idx -1];
            kLineModel.referencePrice = preItem.closePrice;
        }
        CGFloat xPosition = self.startXPosition + idx * (self.itemWidth + self.itemGap);
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
        positionModel.heightPoint = highPoint;
        positionModel.lowPoint = lowPoint;
        
        [self.needDrawKLinePositionModels addObject:positionModel];

    }];
    
    //响应代理方法
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(JT_KLineChartViewNeedDrawKLinePositionModels:)])
        {
            [self.delegate JT_KLineChartViewNeedDrawKLinePositionModels:self.needDrawKLinePositionModels];
        }
    }
    
//    NSInteger kLineModelsCount = kLineModels.count;
//    for (NSInteger idx = 0 ; idx < kLineModelsCount; ++idx)
//    {
//        //K线坐标转换
//        Y_KLineModel *kLineModel = kLineModels[idx];
//
//        CGFloat xPosition = self.startXPosition + idx * ([Y_StockChartGlobalVariable kLineWidth] + [Y_StockChartGlobalVariable kLineGap]);
//        CGPoint openPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.Open.floatValue - minAssert)/unitValue));
//        CGFloat closePointY = ABS(maxY - (kLineModel.Close.floatValue - minAssert)/unitValue);
//        if(ABS(closePointY - openPoint.y) < Y_StockChartKLineMinWidth)
//        {
//            if(openPoint.y > closePointY)
//            {
//                openPoint.y = closePointY + Y_StockChartKLineMinWidth;
//            } else if(openPoint.y < closePointY)
//            {
//                closePointY = openPoint.y + Y_StockChartKLineMinWidth;
//            } else {
//                if(idx > 0)
//                {
//                    Y_KLineModel *preKLineModel = kLineModels[idx-1];
//                    if(kLineModel.Open.floatValue > preKLineModel.Close.floatValue)
//                    {
//                        openPoint.y = closePointY + Y_StockChartKLineMinWidth;
//                    } else {
//                        closePointY = openPoint.y + Y_StockChartKLineMinWidth;
//                    }
//                } else if(idx+1 < kLineModelsCount){
//
//                    //idx==0即第一个时
//                    Y_KLineModel *subKLineModel = kLineModels[idx+1];
//                    if(kLineModel.Close.floatValue < subKLineModel.Open.floatValue)
//                    {
//                        openPoint.y = closePointY + Y_StockChartKLineMinWidth;
//                    } else {
//                        closePointY = openPoint.y + Y_StockChartKLineMinWidth;
//                    }
//                }
//            }
//        }
//
//        CGPoint closePoint = CGPointMake(xPosition, closePointY);
//        CGPoint highPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.High.floatValue - minAssert)/unitValue));
//        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.Low.floatValue - minAssert)/unitValue));
//
//        Y_KLinePositionModel *kLinePositionModel = [Y_KLinePositionModel modelWithOpen:openPoint close:closePoint high:highPoint low:lowPoint];
//        [self.needDrawKLinePositionModels addObject:kLinePositionModel];
//
//
//        //MA坐标转换
//        CGFloat ma7Y = maxY;
//        CGFloat ma30Y = maxY;
//        if(unitValue > 0.0000001)
//        {
//            if(kLineModel.MA7)
//            {
//                ma7Y = maxY - (kLineModel.MA7.floatValue - minAssert)/unitValue;
//            }
//
//        }
//        if(unitValue > 0.0000001)
//        {
//            if(kLineModel.MA30)
//            {
//                ma30Y = maxY - (kLineModel.MA30.floatValue - minAssert)/unitValue;
//            }
//        }
//
//        NSAssert(!isnan(ma7Y) && !isnan(ma30Y), @"出现NAN值");
//
//        CGPoint ma7Point = CGPointMake(xPosition, ma7Y);
//        CGPoint ma30Point = CGPointMake(xPosition, ma30Y);
//
//        if(kLineModel.MA7)
//        {
//            [self.MA7Positions addObject: [NSValue valueWithCGPoint: ma7Point]];
//        }
//        if(kLineModel.MA30)
//        {
//            [self.MA30Positions addObject: [NSValue valueWithCGPoint: ma30Point]];
//        }
//
//
//        if(_targetLineStatus == Y_StockChartTargetLineStatusBOLL){
//
//
//            //BOLL坐标转换
//            CGFloat boll_mbY = maxY;
//            CGFloat boll_upY = maxY;
//            CGFloat boll_dnY = maxY;
//
//            NSLog(@"position：\n上: %@ \n中: %@ \n下: %@",kLineModel.BOLL_UP,kLineModel.BOLL_MB,kLineModel.BOLL_DN);
//
//
//            if(unitValue > 0.0000001)
//            {
//
//                if(kLineModel.BOLL_MB)
//                {
//                    boll_mbY = maxY - (kLineModel.BOLL_MB.floatValue - minAssert)/unitValue;
//                }
//
//            }
//            if(unitValue > 0.0000001)
//            {
//                if(kLineModel.BOLL_DN)
//                {
//                    boll_dnY = maxY - (kLineModel.BOLL_DN.floatValue - minAssert)/unitValue ;
//                }
//            }
//
//            if(unitValue > 0.0000001)
//            {
//                if(kLineModel.BOLL_UP)
//                {
//                    boll_upY = maxY - (kLineModel.BOLL_UP.floatValue - minAssert)/unitValue;
//                }
//            }
//
//            NSAssert(!isnan(boll_mbY) && !isnan(boll_upY) && !isnan(boll_dnY), @"出现BOLL值");
//
//            CGPoint boll_mbPoint = CGPointMake(xPosition, boll_mbY);
//            CGPoint boll_upPoint = CGPointMake(xPosition, boll_upY);
//            CGPoint boll_dnPoint = CGPointMake(xPosition, boll_dnY);
//
//
//            if (kLineModel.BOLL_MB) {
//                [self.BOLL_MBPositions addObject:[NSValue valueWithCGPoint:boll_mbPoint]];
//            }
//
//            if (kLineModel.BOLL_UP) {
//                [self.BOLL_UPPositions addObject:[NSValue valueWithCGPoint:boll_upPoint]];
//            }
//            if (kLineModel.BOLL_DN) {
//                [self.BOLL_DNPositions addObject:[NSValue valueWithCGPoint:boll_dnPoint]];
//            }
//
//        }
//
//    }
    
//    //响应代理方法
//    if(self.delegate)
//    {
//        if([self.delegate respondsToSelector:@selector(kLineMainViewCurrentMaxPrice:minPrice:)])
//        {
//            [self.delegate kLineMainViewCurrentMaxPrice:maxAssert minPrice:minAssert];
//        }
//        if([self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLinePositionModels:)])
//        {
//            [self.delegate kLineMainViewCurrentNeedDrawKLinePositionModels:self.needDrawKLinePositionModels];
//        }
//    }
//    return self.needDrawKLinePositionModels;
}
#pragma mark Getter

- (NSInteger)needDrawStartIndex{
    CGFloat scrollViewOffsetX = self.parentScrollView.contentOffset.x < 0 ? 0 : self.parentScrollView.contentOffset.x;
    NSUInteger leftArrCount = ABS(scrollViewOffsetX - self.itemGap) / (self.itemGap + self.itemWidth);
    _needDrawStartIndex = leftArrCount;
    return _needDrawStartIndex;
}

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
