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
 最高价model
 */
@property (nonatomic, strong) MOHLCItem *highestItem;

/**
 最低价model
 */
@property (nonatomic, strong) MOHLCItem *lowestItem;

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
        if(difValue >= ([JT_KLineConfig kLineGap]) + ([JT_KLineConfig kLineWidth]))
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
    JT_KLine *kLine = [[JT_KLine alloc]initWithContext:context];
    kLine.maxY = self.frame.size.height - self.topAndBottomMargin;
    [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(JT_KLinePositionModel * _Nonnull kLinePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        kLine.kLinePositionModel = kLinePositionModel;
        kLine.kLineModel = self.needDrawKLineModels[idx];
        [kLine draw];
    }];

//
//    //设置显示日期的区域背景颜色
//    CGContextSetFillColorWithColor(context, [UIColor assistBackgroundColor].CGColor);
//    CGContextFillRect(context, CGRectMake(0, Y_StockChartKLineMainViewMaxY, self.frame.size.width, self.frame.size.height - Y_StockChartKLineMainViewMaxY));
//
//    Y_MALine *MALine = [[Y_MALine alloc]initWithContext:context];
//
//    if(self.MainViewType == Y_StockChartcenterViewTypeKline)
//    {
//        Y_KLine *kLine = [[Y_KLine alloc]initWithContext:context];
//        kLine.maxY = Y_StockChartKLineMainViewMaxY;
//
//        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(Y_KLinePositionModel * _Nonnull kLinePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
//            kLine.kLinePositionModel = kLinePositionModel;
//            kLine.kLineModel = self.needDrawKLineModels[idx];
//            UIColor *kLineColor = [kLine draw];
//            [kLineColors addObject:kLineColor];
//        }];
//
//    } else {
//        __block NSMutableArray *positions = @[].mutableCopy;
//        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(Y_KLinePositionModel * _Nonnull positionModel, NSUInteger idx, BOOL * _Nonnull stop) {
//            UIColor *strokeColor = positionModel.OpenPoint.y < positionModel.ClosePoint.y ? [UIColor increaseColor] : [UIColor decreaseColor];
//            [kLineColors addObject:strokeColor];
//            [positions addObject:[NSValue valueWithCGPoint:positionModel.ClosePoint]];
//        }];
//        MALine.MAPositions = positions;
//        MALine.MAType = -1;
//        [MALine draw];
//        //
//        __block CGPoint lastDrawDatePoint = CGPointZero;//fix
//        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(Y_KLinePositionModel * _Nonnull positionModel, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            CGPoint point = [positions[idx] CGPointValue];
//
//            //日期
//
//            NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.needDrawKLineModels[idx].Date.doubleValue];
//            NSDateFormatter *formatter = [NSDateFormatter new];
//            formatter.dateFormat = @"HH:mm";
//            NSString *dateStr = [formatter stringFromDate:date];
//
//            CGPoint drawDatePoint = CGPointMake(point.x + 1, Y_StockChartKLineMainViewMaxY + 1.5);
//            if(CGPointEqualToPoint(lastDrawDatePoint, CGPointZero) || point.x - lastDrawDatePoint.x > 60 )
//            {
//                [dateStr drawAtPoint:drawDatePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSForegroundColorAttributeName : [UIColor assistTextColor]}];
//                lastDrawDatePoint = drawDatePoint;
//            }
//        }];
//    }
//
//    if (self.targetLineStatus == Y_StockChartTargetLineStatusBOLL) {
//        // 画BOLL MB线 标准线
//        MALine.MAType = Y_BOLL_MB;
//        MALine.BOLLPositions = self.BOLL_MBPositions;
//        [MALine draw];
//
//        // 画BOLL UP 上浮线
//        MALine.MAType = Y_BOLL_UP;
//        MALine.BOLLPositions = self.BOLL_UPPositions;
//        [MALine draw];
//
//        // 画BOLL DN下浮线
//        MALine.MAType = Y_BOLL_DN;
//        MALine.BOLLPositions = self.BOLL_DNPositions;
//        [MALine draw];
//
//    } else if ( self.targetLineStatus != Y_StockChartTargetLineStatusCloseMA){
//
//        //画MA7线
//        MALine.MAType = Y_MA7Type;
//        MALine.MAPositions = self.MA7Positions;
//        [MALine draw];
//
//        //画MA30线
//        MALine.MAType = Y_MA30Type;
//        MALine.MAPositions = self.MA30Positions;
//        [MALine draw];
//
//    }
//
//    if(self.delegate && kLineColors.count > 0)
//    {
//        if([self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLineColors:)])
//        {
//            [self.delegate kLineMainViewCurrentNeedDrawKLineColors:kLineColors];
//        }
//    }
}
#pragma makr 私有方法
- (void)p_extractNeedDrawModels {
    
    //数组个数
    CGFloat scrollViewWidth = self.parentScrollView.frame.size.width;
    
    NSInteger needDrawKLineCount = (scrollViewWidth - [JT_KLineConfig kLineGap])/([JT_KLineConfig kLineGap] + [JT_KLineConfig kLineWidth]);
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
    
    _lowestItem = firstModel;
    _highestItem = firstModel;
    
    [kLineModels enumerateObjectsUsingBlock:^(MOHLCItem * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(kLineModel.highPrice.floatValue > maxAssert)
        {
            maxAssert = kLineModel.highPrice.floatValue;
            self.highestItem = kLineModel;
        }
        if(kLineModel.lowPrice.floatValue < minAssert)
        {
            minAssert = kLineModel.lowPrice.floatValue;
            self.lowestItem = kLineModel;
        }
    }];
    
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
    
    //响应代理方法
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(JT_KLineChartViewNeedDrawKLinePositionModels:)])
        {
            [self.delegate JT_KLineChartViewNeedDrawKLinePositionModels:self.needDrawKLinePositionModels];
        }
    }
}
#pragma mark Getter

- (NSInteger)needDrawStartIndex{
    CGFloat scrollViewOffsetX = self.parentScrollView.contentOffset.x < 0 ? 0 : self.parentScrollView.contentOffset.x;
    NSUInteger leftArrCount = ABS(scrollViewOffsetX - [JT_KLineConfig kLineGap]) / ([JT_KLineConfig kLineGap] + [JT_KLineConfig kLineWidth]);
    _needDrawStartIndex = leftArrCount;
    return _needDrawStartIndex;
}
- (void)dealloc
{
    [_parentScrollView removeObserver:self forKeyPath:JT_ScrollViewContentOffset context:nil];
}
@end
