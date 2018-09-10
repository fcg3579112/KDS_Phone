//
//  JT_KLineVolumeView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineVolumeView.h"
#import "JT_KLineConfig.h"
#import "JT_KLineBarPositionModel.h"
#import "JT_DrawCandleLine.h"
#import "JT_DrawMALine.h"
#import "JT_KLineModel.h"
#import "JT_KLineCandlePositionModel.h"

@interface JT_KLineVolumeView ()

@property (nonatomic ,assign) float screenMaxValue;
@property (nonatomic ,assign) float screenMinValue;

/**
 *  需要绘制的model位置数组
 */
@property (nonatomic, strong) NSMutableArray <JT_KLineBarPositionModel *>*needDrawBarPositionModels;

/**
 成交量均线坐标
 */
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_Volume_MA5_Positions;

@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_Volume_MA10_Positions;

/**
 KDJ 线坐标
 */
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_KDJ_K_Positions;

@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_KDJ_D_Positions;

@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_KDJ_J_Positions;

/**
 MACD 线坐标
 */
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_MACD_Positions;

@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_DIF_Positions;

@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_DEA_Positions;

/**
 BOOL线中轨
 */
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_MB_Positions;
/**
 BOOL线上轨
 */
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_UP_Positions;
/**
 BOOL线下轨
 */
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_DN_Positions;
/**
 BOOL线页面上的美国线坐标
 */
@property (nonatomic, strong) NSMutableArray <JT_KLineCandlePositionModel *>*needDraw_AMLine_Positions;


/**
 RSI_6 坐标
 */
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_RSI6_Positions;
/**
 RSI_12 坐标
 */
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_RSI12_Positions;
/**
 RSI_24 坐标
 */
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_RSI24_Positions;


/**
 平行线差（DMA）指标坐标
 */
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_DMA_Positions;
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_AMA_Positions;

/**
 乘离率 (BIAS)
 */
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_BIAS6_Positions;
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_BIAS12_Positions;
@property (nonatomic, strong) NSMutableArray <NSValue *>*needDraw_BIAS24_Positions;

@property (nonatomic, strong) JT_DrawMALine *drawLineUtil;

@property (nonatomic, strong) JT_DrawCandleLine *drawBarUtil;

@end
@implementation JT_KLineVolumeView

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
        
        //成交量
        _needDrawBarPositionModels = @[].mutableCopy;
        _needDraw_Volume_MA5_Positions = @[].mutableCopy;
        _needDraw_Volume_MA10_Positions = @[].mutableCopy;
        
        //KDJ指标(随机指标)
        _needDraw_KDJ_K_Positions = @[].mutableCopy;
        _needDraw_KDJ_D_Positions = @[].mutableCopy;
        _needDraw_KDJ_J_Positions = @[].mutableCopy;
        
        //MACD (指数平滑移动平均线)
        _needDraw_MACD_Positions = @[].mutableCopy;
        _needDraw_DIF_Positions = @[].mutableCopy;
        _needDraw_DEA_Positions = @[].mutableCopy;
        
        //BOOL(布林线指标)
        _needDraw_MB_Positions = @[].mutableCopy;
        _needDraw_UP_Positions = @[].mutableCopy;
        _needDraw_DN_Positions = @[].mutableCopy;
        _needDraw_AMLine_Positions = @[].mutableCopy;
        
        //相对强弱指标RSI
        _needDraw_RSI6_Positions = @[].mutableCopy;
        _needDraw_RSI12_Positions = @[].mutableCopy;
        _needDraw_RSI24_Positions = @[].mutableCopy;
        
        //DMA(平行线差指标)
        _needDraw_DMA_Positions = @[].mutableCopy;
        _needDraw_AMA_Positions = @[].mutableCopy;
        
        //乘离率 (BIAS)
        _needDraw_BIAS6_Positions = @[].mutableCopy;
        _needDraw_BIAS12_Positions = @[].mutableCopy;
        _needDraw_BIAS24_Positions = @[].mutableCopy;
        
    
        
    }
    return self;
}


- (void)p_convertKLineModelsToPositionModels {
    //移除旧的数据
    [_needDrawBarPositionModels removeAllObjects];
    [_needDraw_Volume_MA5_Positions removeAllObjects];
    [_needDraw_Volume_MA10_Positions removeAllObjects];
    [_needDraw_KDJ_K_Positions removeAllObjects];
    [_needDraw_KDJ_D_Positions removeAllObjects];
    [_needDraw_KDJ_J_Positions removeAllObjects];
    [_needDraw_MACD_Positions removeAllObjects];
    [_needDraw_DIF_Positions removeAllObjects];
    [_needDraw_DEA_Positions removeAllObjects];
    
    //移除BOOL线相关坐标
    [_needDraw_DN_Positions removeAllObjects];
    [_needDraw_UP_Positions removeAllObjects];
    [_needDraw_MB_Positions removeAllObjects];
    [_needDraw_AMLine_Positions removeAllObjects];
    
    //移除RSI线相关坐标
    [_needDraw_RSI6_Positions removeAllObjects];
    [_needDraw_RSI12_Positions removeAllObjects];
    [_needDraw_RSI24_Positions removeAllObjects];
    
    //移除DMA(平行线差指标)坐标
    [_needDraw_DMA_Positions removeAllObjects];
    [_needDraw_AMA_Positions removeAllObjects];
    
    //乘离率 (BIAS)
    [_needDraw_BIAS6_Positions removeAllObjects];
    [_needDraw_BIAS12_Positions removeAllObjects];
    [_needDraw_BIAS24_Positions removeAllObjects];
    
    NSArray *kLineModels = self.needDrawKLineModels;
    JT_KLineModel *lastModel = self.needDrawKLineModels.lastObject;
    
    if ([JT_KLineConfig kLineIndicatorType] == JT_Volume) {
        self.screenMinValue = 0;
        self.screenMaxValue = lastModel.tradeVolume;
    } else if ([JT_KLineConfig kLineIndicatorType] == JT_KDJ) {
        self.screenMinValue = lastModel.KDJ_K;
        self.screenMaxValue = lastModel.KDJ_K;
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_MACD) {
        self.screenMinValue = lastModel.MACD;
        self.screenMaxValue = lastModel.MACD;
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_BOLL) {
        self.screenMaxValue = lastModel.highPrice.floatValue;
        self.screenMinValue = lastModel.lowPrice.floatValue;
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_RSI) {
        self.screenMaxValue = lastModel.RSI6;
        self.screenMinValue = lastModel.RSI6;
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_DMA) {
        self.screenMinValue = lastModel.DMA;
        self.screenMaxValue = lastModel.DMA;
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_DMI) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_BIAS) {
        self.screenMaxValue = lastModel.BIAS6;
        self.screenMinValue = lastModel.BIAS6;
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_CCI) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_WR) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_VR) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_CR) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_OBV) {
        
    }
    
    [kLineModels enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([JT_KLineConfig kLineIndicatorType] == JT_Volume) { // 计算屏幕上成交量的最大值
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.tradeVolume);
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.volumeMA5);
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.volumeMA10);
            self.screenMinValue = 0;
        } else if ([JT_KLineConfig kLineIndicatorType] == JT_KDJ) { // 计算屏幕上KDJ的最大值及最小值
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.KDJ_K);
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.KDJ_D);
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.KDJ_J);
            
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.KDJ_K);
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.KDJ_D);
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.KDJ_J);
        } else if ([JT_KLineConfig kLineIndicatorType] == JT_MACD) {
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.MACD);
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.DIF);
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.DEA);
            
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.MACD);
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.DIF);
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.DEA);
        } else if ([JT_KLineConfig kLineIndicatorType] == JT_BOLL) {
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.lowPrice.floatValue);
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.DN);
            
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.highPrice.floatValue);
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.UP);
        } else if ([JT_KLineConfig kLineIndicatorType] == JT_RSI) {
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.RSI6);
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.RSI12);
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.RSI24);
            
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.RSI6);
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.RSI12);
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.RSI24);
        } else if ([JT_KLineConfig kLineIndicatorType] == JT_DMA) {
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.DMA);
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.AMA);
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.DMA);
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.AMA);
        }else if ([JT_KLineConfig kLineIndicatorType] == JT_DMI) {
            
        }else if ([JT_KLineConfig kLineIndicatorType] == JT_BIAS) {
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.BIAS6);
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.BIAS12);
            self.screenMaxValue = MAX(self.screenMaxValue, kLineModel.BIAS24);
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.BIAS6);
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.BIAS12);
            self.screenMinValue = MIN(self.screenMinValue, kLineModel.BIAS24);
        }
    }];
    
    //计算最小单位
    float unitValue = (self.screenMaxValue - self.screenMinValue) / self.maxY;
    
    [kLineModels enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        float xPosition = self.startXPosition + idx * ([JT_KLineConfig kLineWidth] + [JT_KLineConfig kLineGap]);
        //如果选中的是成交量

        if ([JT_KLineConfig kLineIndicatorType] == JT_Volume) {
            JT_KLineBarPositionModel *barModel = [JT_KLineBarPositionModel new];
            barModel.beginPoint = CGPointMake(xPosition, self.maxY);
            barModel.endPoint = CGPointMake(xPosition, ABS(self.maxY - (kLineModel.tradeVolume - self.screenMinValue) / unitValue ));
            [self.needDrawBarPositionModels addObject:barModel];
            
            [self.needDraw_Volume_MA5_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.volumeMA5 - self.screenMinValue) / unitValue ))]];
            
            [self.needDraw_Volume_MA10_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.volumeMA10 - self.screenMinValue) / unitValue ))]];
        } else if ([JT_KLineConfig kLineIndicatorType] == JT_KDJ) { // 计算屏幕上KDJ坐标
            
            [self.needDraw_KDJ_K_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.KDJ_K - self.screenMinValue) / unitValue ))]];
            [self.needDraw_KDJ_D_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.KDJ_D - self.screenMinValue) / unitValue ))]];
            [self.needDraw_KDJ_J_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.KDJ_J - self.screenMinValue) / unitValue ))]];
            
        } else if ([JT_KLineConfig kLineIndicatorType] == JT_MACD) { // 计算屏幕上MACD坐标
            JT_KLineBarPositionModel *barModel = [JT_KLineBarPositionModel new];
            barModel.beginPoint = CGPointMake(xPosition, ABS(self.maxY - (0 - self.screenMinValue)/ unitValue ));
            barModel.endPoint = CGPointMake(xPosition, ABS(self.maxY - (kLineModel.MACD - self.screenMinValue) / unitValue ));
            [self.needDrawBarPositionModels addObject:barModel];
            [self.needDraw_DEA_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition,  ABS(self.maxY - (kLineModel.DEA - self.screenMinValue) / unitValue ))]];
            [self.needDraw_DIF_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition,  ABS(self.maxY - (kLineModel.DIF - self.screenMinValue) / unitValue ))]];
        } else if ([JT_KLineConfig kLineIndicatorType] == JT_BOLL) {
            JT_KLineCandlePositionModel *amModel = [JT_KLineCandlePositionModel new];
            amModel.highPoint = CGPointMake(xPosition, ABS(self.maxY - (kLineModel.highPrice.floatValue - self.screenMinValue) / unitValue ));
            amModel.lowPoint = CGPointMake(xPosition, ABS(self.maxY - (kLineModel.lowPrice.floatValue - self.screenMinValue) / unitValue ));
            amModel.openPoint = CGPointMake(xPosition, ABS(self.maxY - (kLineModel.openPrice.floatValue - self.screenMinValue) / unitValue ));
            amModel.closePoint = CGPointMake(xPosition, ABS(self.maxY - (kLineModel.closePrice.floatValue - self.screenMinValue) / unitValue ));
            [self.needDraw_AMLine_Positions addObject:amModel];
            
            [self.needDraw_MB_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.MB - self.screenMinValue) / unitValue ))]];
            [self.needDraw_UP_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.UP - self.screenMinValue) / unitValue ))]];
            [self.needDraw_DN_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.DN - self.screenMinValue) / unitValue ))]];
        } else if ([JT_KLineConfig kLineIndicatorType] == JT_RSI) {
            [self.needDraw_RSI6_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.RSI6 - self.screenMinValue) / unitValue ))]];
            [self.needDraw_RSI12_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.RSI12 - self.screenMinValue) / unitValue ))]];
            [self.needDraw_RSI24_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.RSI24 - self.screenMinValue) / unitValue ))]];
        } else if ([JT_KLineConfig kLineIndicatorType] == JT_DMA) {
            [self.needDraw_DMA_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.DMA - self.screenMinValue) / unitValue ))]];
            [self.needDraw_AMA_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.AMA - self.screenMinValue) / unitValue ))]];
        }else if ([JT_KLineConfig kLineIndicatorType] == JT_DMI) {
            
        }else if ([JT_KLineConfig kLineIndicatorType] == JT_BIAS) {
            [self.needDraw_BIAS6_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.BIAS6 - self.screenMinValue) / unitValue ))]];
            [self.needDraw_BIAS12_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.BIAS12 - self.screenMinValue) / unitValue ))]];
            [self.needDraw_BIAS24_Positions addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, ABS(self.maxY - (kLineModel.BIAS24 - self.screenMinValue) / unitValue ))]];
        }
    }];
}

#pragma mark Setter

- (void)setNeedDrawKLineModels:(NSMutableArray<JT_KLineModel *> *)needDrawKLineModels {
    _needDrawKLineModels = needDrawKLineModels;
    [self p_convertKLineModelsToPositionModels];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
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
    //画中间的1条横线
    float gap = rect.size.height / 2.f;
    CGContextSetLineWidth(context, JT_KLineViewGridLineWidth);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + gap);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + gap);
    CGContextStrokePath(context);
    
    _drawBarUtil = [[JT_DrawCandleLine alloc] initWithContext:context];
    
    _drawLineUtil = [[JT_DrawMALine alloc] initWithContext:context];
    
    //画成交量
    if ([JT_KLineConfig kLineIndicatorType] == JT_Volume) {
        //画成交量柱状图
        [self.needDrawBarPositionModels enumerateObjectsUsingBlock:^(JT_KLineBarPositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JT_KLineModel *kLineModel = self.needDrawKLineModels[idx];
            UIColor *color = kLineModel.closePrice.floatValue > kLineModel.openPrice.floatValue ? JT_KLineIncreaseColor : JT_KLineDecreaseColor;
            [self.drawBarUtil drawBarWithColor:color width:[JT_KLineConfig kLineWidth] begin:obj.beginPoint end:obj.endPoint];
        }];
        
        //画成交量均线
        [_drawLineUtil drawLineWithColor:JT_KLineMA5Color positions:self.needDraw_Volume_MA5_Positions];
        [_drawLineUtil drawLineWithColor:JT_KLineMA10Color positions:self.needDraw_Volume_MA10_Positions];
        
    } else if ([JT_KLineConfig kLineIndicatorType] == JT_KDJ) { // 画KDJ

        [_drawLineUtil drawLineWithColor:JT_KLine_KDJ_K_Color positions:self.needDraw_KDJ_K_Positions];
        [_drawLineUtil drawLineWithColor:JT_KLine_KDJ_D_Color positions:self.needDraw_KDJ_D_Positions];
        [_drawLineUtil drawLineWithColor:JT_KLine_KDJ_J_Color positions:self.needDraw_KDJ_J_Positions];
        
    } else if ([JT_KLineConfig kLineIndicatorType] == JT_MACD) { // 画MACD
        
        //画MACD Bar
        [self.needDrawBarPositionModels enumerateObjectsUsingBlock:^(JT_KLineBarPositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JT_KLineModel *kLineModel = self.needDrawKLineModels[idx];
            UIColor *color = kLineModel.MACD > 0 ? JT_KLineIncreaseColor : JT_KLineDecreaseColor;
            [self.drawBarUtil drawBarWithColor:color width:[JT_KLineConfig kLineShadeLineWidth] begin:obj.beginPoint end:obj.endPoint];
        }];
        
        //画 DIF 与 DEA
        [_drawLineUtil drawLineWithColor:JT_KLine_MACD_DEA_Color positions:self.needDraw_DEA_Positions];
        [_drawLineUtil drawLineWithColor:JT_KLine_MACD_DIF_Color positions:self.needDraw_DIF_Positions];
    
    } else if ([JT_KLineConfig kLineIndicatorType] == JT_BOLL) {
        [_drawLineUtil drawLineWithColor:JT_KLine_BOLL_UP_Color positions:self.needDraw_UP_Positions];
        [_drawLineUtil drawLineWithColor:JT_KLine_BOLL_MID_Color positions:self.needDraw_MB_Positions];
        [_drawLineUtil drawLineWithColor:JT_KLine_BOLL_LOW_Color positions:self.needDraw_DN_Positions];
        
        //画美国线
        [self.needDraw_AMLine_Positions enumerateObjectsUsingBlock:^(JT_KLineCandlePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JT_KLineModel *kLineModel = self.needDrawKLineModels[idx];
            UIColor *color = kLineModel.closePrice.floatValue > kLineModel.openPrice.floatValue ? JT_KLineIncreaseColor : JT_KLineDecreaseColor;
            [self.drawBarUtil drawBarWithColor:color width:[JT_KLineConfig kLineShadeLineWidth] begin:obj.lowPoint end:obj.highPoint];
            [self.drawBarUtil drawAMLineWithColor:color width:[JT_KLineConfig kLineShadeLineWidth] left:obj.openPoint right:obj.closePoint];
        }];

    } else if ([JT_KLineConfig kLineIndicatorType] == JT_RSI) {
        [_drawLineUtil drawLineWithColor:JT_KLine_RSI_6_Color positions:self.needDraw_RSI6_Positions];
        [_drawLineUtil drawLineWithColor:JT_KLine_RSI_12_Color positions:self.needDraw_RSI12_Positions];
        [_drawLineUtil drawLineWithColor:JT_KLine_RSI_24_Color positions:self.needDraw_RSI24_Positions];
    } else if ([JT_KLineConfig kLineIndicatorType] == JT_DMA) {
        [_drawLineUtil drawLineWithColor:JT_KLine_DMA_DMA_Color positions:self.needDraw_DMA_Positions];
        [_drawLineUtil drawLineWithColor:JT_KLine_DMA_AMA_Color positions:self.needDraw_AMA_Positions];
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_DMI) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_BIAS) {
        [_drawLineUtil drawLineWithColor:JT_KLine_BIAS_6_Color positions:self.needDraw_BIAS6_Positions];
        [_drawLineUtil drawLineWithColor:JT_KLine_BIAS_12_Color positions:self.needDraw_BIAS12_Positions];
        [_drawLineUtil drawLineWithColor:JT_KLine_BIAS_24_Color positions:self.needDraw_BIAS24_Positions];
    }
    
    //画最大值与最小值
    NSString *max = [NSString stringWithFormat:@"%.2f",self.screenMaxValue];
    NSString *min = [NSString stringWithFormat:@"%.2f",self.screenMinValue];
    if ([JT_KLineConfig kLineIndicatorType] == JT_Volume) {
        max = formatVolume(self.screenMaxValue);
        min = @"";
    }
    [self drawMaxValue:max andMin:min rect:rect];
}

- (void)drawMaxValue:(NSString *)maxValue andMin:(NSString *)minValue rect:(CGRect)rect {
    UIColor *maxValueColor = JT_ColorDayOrNight(@"858C9E", @"E6678");
    if (maxValue.length) {
        [maxValue drawAtPoint:CGPointMake(2, 2) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineMAFontSize],NSForegroundColorAttributeName : maxValueColor}];
    }
    if (minValue.length) {
        [minValue drawAtPoint:CGPointMake(2, rect.size.height - 12) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:JT_KLineMAFontSize],NSForegroundColorAttributeName : maxValueColor}];
    }
    
}

@end
