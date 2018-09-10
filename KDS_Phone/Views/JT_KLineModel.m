//
//  JT_KLineModel.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/3.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineModel.h"
#import <MApi.h>
#import "JT_KLineConfig.h"
@implementation JT_KLineModel



- (instancetype)initWithModel:(MOHLCItem *)model;
{
    self = [super init];
    if (self) {
        _datetime = model.datetime;
        _openPrice = model.openPrice;
        _highPrice = model.highPrice;
        _lowPrice = model.lowPrice;
        _closePrice = model.closePrice;
        _tradeVolume = [model.tradeVolume integerValue];
        _averagePrice = model.averagePrice;
        _referencePrice = model.referencePrice;
        _amount = model.amount;
    }
    return self;
}
- (NSUInteger) index {
    return [self.allKLineModel indexOfObject:self];
}
- (NSMutableArray <JT_KLineModel *>*)allKLineModel {
#if DEBUG
    NSAssert(_allKLineModel != nil, @"JT_KLineModel 未设置 allKLineModel 属性");
#endif
    return _allKLineModel;
}
- (NSString *)referencePrice {
    return _referencePrice ? _referencePrice : [self r_referencePrice];
}
//如果今日数据中的昨收不存在,取前一天数据中的收盘价
- (NSString *)r_referencePrice {
    if (self.index > 0) {
        JT_KLineModel *preModel = self.allKLineModel[self.index - 1];
        return preModel.closePrice;
    }
    return @"";
}
- (float)sumOfLastClose {
    if (!_sumOfLastClose) {
        _sumOfLastClose = self.preModel.sumOfLastClose + self.closePrice.floatValue;
    }
    return _sumOfLastClose;
}
- (NSInteger)sumOfLastVolume {
    if (!_sumOfLastVolume) {
        _sumOfLastVolume = self.preModel.sumOfLastVolume + self.tradeVolume;
    }
    return _sumOfLastVolume;
}
- (NSString *)MA5 {
    if ([JT_KLineConfig MA5]) {
        if (!_MA5) {
            _MA5 = [self calculateMAValue:[JT_KLineConfig MA5]];
        }
        return _MA5;
    } else {
        return nil;
    }
}
- (NSString *)MA10 {
    if ([JT_KLineConfig MA10]) {
        if (!_MA10) {
            _MA10 = [self calculateMAValue:[JT_KLineConfig MA10]];
        }
        return _MA10;
    } else {
        return nil;
    }
}

- (NSString *)MA20 {
    if ([JT_KLineConfig MA20]) {
        if (!_MA20) {
            _MA20 = [self calculateMAValue:[JT_KLineConfig MA20]];
        }
        return _MA20;
    } else {
        return nil;
    }
}

- (NSString *)MA30 {
    if ([JT_KLineConfig MA30]) {
        if (!_MA30) {
            _MA30 = [self calculateMAValue:[JT_KLineConfig MA30]];
        }
        return _MA30;
    } else {
        return nil;
    }
}

- (NSString *)MA60 {
    if ([JT_KLineConfig MA60]) {
        if (!_MA60) {
            _MA60 = [self calculateMAValue:[JT_KLineConfig MA60]];
        }
        return _MA60;
    } else {
        return nil;
    }
}
- (JT_KLineModel *)preModel {
    if (!_preModel) {
        if (self.index > 0) {
            _preModel = self.allKLineModel[self.index -1];
        } else {
            _preModel = nil;
        }
    }
    return _preModel;
}
- (BOOL)needShowTime {
    if (self.index % 30 == 0) {
        return YES;
    }
    return NO;
}
- (NSString *)calculateMAValue:(NSUInteger)days {
    NSString *MAString = @"";
    if (self.index > days - 1) {
        JT_KLineModel *preDaysModel = self.allKLineModel[self.index - days];
        MAString = [NSString stringWithFormat:@"%.2f",(self.sumOfLastClose - preDaysModel.sumOfLastClose) / days];
    } else {
        MAString = [NSString stringWithFormat:@"%.2f",self.sumOfLastClose / (self.index + 1)];
    }
    return MAString;
}

- (NSUInteger)volumeMA5 {
    if (!_volumeMA5) {
        _volumeMA5 = [self calculateVolumeMAValue:5];
    }
    return _volumeMA5;
}
- (NSUInteger)volumeMA10 {
    if (!_volumeMA10) {
        _volumeMA10 = [self calculateVolumeMAValue:10];
    }
    return _volumeMA10;
}
- (NSUInteger)calculateVolumeMAValue:(NSUInteger)days {
    NSUInteger volume;
    if (self.index > days - 1) {
        JT_KLineModel *preDaysModel = self.allKLineModel[self.index - days];
        volume = (self.sumOfLastVolume - preDaysModel.sumOfLastVolume) / days;
    } else {
        volume = self.sumOfLastVolume / (self.index + 1);
    }
    return volume;
}

//KDJ

- (float)nineClocksMinPrice {
    if (!_nineClocksMinPrice) {
        NSInteger index = self.index;
        float min = self.allKLineModel[index].lowPrice.floatValue;
        for (NSInteger i = index - 1; i >= 0; -- i) {
            min = MIN(min, self.allKLineModel[i].lowPrice.floatValue);
            if (index - i > 7) {
                break;
            }
        }
        _nineClocksMinPrice = min;
    }
    return _nineClocksMinPrice;
}
- (float)nineClocksMaxPrice {
    if (!_nineClocksMaxPrice) {
        NSInteger index = self.index;
        float max = self.allKLineModel[index].highPrice.floatValue;
        for (NSInteger i = index - 1; i >= 0; -- i) {
            max = MAX(max, self.allKLineModel[i].highPrice.floatValue);
            if (index - i > 7) {
                break;
            }
        }
        _nineClocksMaxPrice = max;
    }
    return _nineClocksMaxPrice;
}
//9日RSV=（9日的收盘价－9日内的最低价）÷（9日内的最高价－9日内的最低价）×100 
//如果9日内的最高价等于9日内的最低价 RSV = 100
- (float)RSV_9 {
    if (!_RSV_9) {
        if (self.nineClocksMinPrice == self.nineClocksMaxPrice) {
            _RSV_9 = 100;
        } else {
            _RSV_9 = (self.closePrice.floatValue - self.nineClocksMinPrice) / (self.nineClocksMaxPrice - self.nineClocksMinPrice) * 100;
        }
    }
    return _RSV_9;
}

/**
 K值=2/3×第8日K值+1/3×第9日RSV
 D值=2/3×第8日D值+1/3×第9日K值
 J值=3*第9日K值-2*第9日D值
 若无前一日K
 值与D值，则可以分别用50代替。
 */
- (float)KDJ_K {
    if (!_KDJ_K) {
        _KDJ_K = (self.RSV_9 + 2 * (self.preModel.KDJ_K ? self.preModel.KDJ_K : 50) )/3;
    }
    return _KDJ_K;
}
- (float)KDJ_D {
    if(!_KDJ_D) {
        _KDJ_D = (self.KDJ_K + 2 * (self.preModel.KDJ_D ? self.preModel.KDJ_D : 50)) / 3;
    }
    return _KDJ_D;
}
- (float)KDJ_J {
    if(!_KDJ_J) {
        _KDJ_J = 3 * self.KDJ_K - 2 * self.KDJ_D;
    }
    return _KDJ_J;
}

- (float)EMA12
{
    if(!_EMA12) {
        if (self.index == 0) {
            _EMA12 = self.closePrice.floatValue;
        } else {
            _EMA12 = ( 11 * self.preModel.EMA12 + 2 * self.closePrice.floatValue )/13;
        }
    }
    return _EMA12;
}

- (float)EMA26
{
    if (!_EMA26) {
        if (self.index == 0) {
            _EMA26 = self.closePrice.floatValue;
        } else {
            _EMA26 = ( 25 * self.preModel.EMA26 + 2 * self.closePrice.floatValue )/27;
        }
    }
    return _EMA26;
}

- (float)DIF
{
    if(!_DIF) {
        _DIF = self.EMA12 - self.EMA26;
    }
    return _DIF;
}

-(float)DEA
{
    if(!_DEA) {
        _DEA = self.preModel.DEA * 0.8 + 0.2 * self.DIF;
    }
    return _DEA;
}

- (float)MACD
{
    if(!_MACD) {
        _MACD = 2 * (self.DIF - self.DEA);
    }
    return _MACD;
}

- (float)MA_20 {
    if (!_MA_20) {
        _MA_20 = [self calculateMAValue:20].floatValue;
    }
    return _MA_20;
}
- (float)MD {
    if (!_MD) {
        float sum = 0;
        NSInteger index = self.index;
        for (NSInteger i = index; i >= 0; i --) {
            float closePrice = self.allKLineModel[i].closePrice.floatValue;
            sum = (closePrice - self.MA_20) * (closePrice - self.MA_20) + sum;
            if (index - i > 18) {
                break;
            }
        }
        NSUInteger count = self.index > 18 ? 20 : self.index + 2;
        float average = sum / count;
        _MD = sqrtf(average);
    }
    return _MD;
}
- (float)MB {
    if (!_MB) {
        _MB = self.MA_20;
    }
    return _MB;
}
- (float)UP {
    if (!_UP) {
        _UP = self.MB + 2 * self.MD;
    }
    return _UP;
}
- (float)DN {
    if (!_DN) {
        _DN = self.MB - 2 * self.MD;
    }
    return _DN;
}


/**
 计算股票涨跌幅


 */
- (float)change {
    if (!_change) {
        _change = self.closePrice.floatValue - self.referencePrice.floatValue;
    }
    return _change;
}
- (float)changeRate {
    if (!_changeRate) {
        _changeRate = self.change / self.referencePrice.floatValue;
    }
    return _changeRate;
}

/**
 SMA(X,N,M)，求X的N日移动平均，M为权重。算法：若Y=SMA(X,N,M) 则 Y=(M*X+(N-M)*Y')/N，其中Y'表示上一周期Y值，N必须大于M。
 RSI:= SMA(MAX(Close-LastClose,0),N,1)/SMA(ABS(Close-LastClose),N,1)*100
 */
- (float)SMA6 {
    if (!_SMA6) {
        _SMA6 = (MAX(self.closePrice.floatValue - self.referencePrice.floatValue, 0) + 5 * self.preModel.SMA6) / 6;
    }
    return _SMA6;
}
- (float)SMA6_A {
    if (!_SMA6_A) {
        _SMA6_A = (fabsf(self.closePrice.floatValue - self.referencePrice.floatValue) + 5 * self.preModel.SMA6_A) / 6;
    }
    return _SMA6_A;
}
- (float)SMA12 {
    if (!_SMA12) {
        _SMA12 = (MAX(self.closePrice.floatValue - self.referencePrice.floatValue, 0) + 11 * self.preModel.SMA12) / 12;
    }
    return _SMA12;
}
- (float)SMA12_A {
    if (!_SMA12_A) {
        _SMA12_A = (fabsf(self.closePrice.floatValue - self.referencePrice.floatValue) + 11 * self.preModel.SMA12_A) / 12;
    }
    return _SMA12_A;
}
- (float)SMA24 {
    if (!_SMA24) {
        _SMA24 = (MAX(self.closePrice.floatValue - self.referencePrice.floatValue, 0) + 23 * self.preModel.SMA24) / 24;
    }
    return _SMA24;
}
- (float)SMA24_A {
    if (!_SMA24_A) {
        _SMA24_A = (fabsf(self.closePrice.floatValue - self.referencePrice.floatValue) + 23 * self.preModel.SMA24_A) / 24;
    }
    return _SMA24_A;
}
- (float)RSI6 {
    if (!_RSI6) {
        _RSI6 = self.SMA6 / self.SMA6_A * 100;
    }
    return _RSI6;
}
- (float)RSI12 {
    if (!_RSI12) {
        _RSI12 = self.SMA12 / self.SMA12_A * 100;
    }
    return _RSI12;
}
- (float)RSI24 {
    if (!_RSI24) {
        _RSI24 = self.SMA24 / self.SMA24_A * 100;
    }
    return _RSI24;
}

/*
- (float)RSI6 {
    if (!_RSI6) {
        _RSI6 = [self caculateRSI:6];
    }
    return _RSI6;
}
- (float)RSI12 {
    if (!_RSI12) {
        _RSI12 = [self caculateRSI:12];
    }
    return _RSI12;
}
- (float)RSI24 {
    if (!_RSI24) {
        _RSI24 = [self caculateRSI:24];
    }
    return _RSI24;
}
- (float)caculateRSI:(NSUInteger)days {
    NSUInteger index = self.index;
    float sum_z = 0; // 涨
    float sum_all = 0; // 涨 + 跌
    for (NSInteger  i = index; i >=0 ; i --) {
        JT_KLineModel *model = self.allKLineModel[i];
        if (model.change > 0) {
            sum_z += model.change;
        }
        sum_all += fabsf(model.change);
        if (index - i >= days - 1) {
            break;
        }
    }
    return sum_z / sum_all * 100;
}
*/

- (float)MA_10 {
    if (!_MA_10) {
        _MA_10 = [self calculateMAValue:10].floatValue;
    }
    return _MA_10;
}
- (float)MA_50 {
    if (!_MA_50) {
        _MA_50 = [self calculateMAValue:50].floatValue;
    }
    return _MA_50;
}
- (float)DMA {
    if (!_DMA) {
        _DMA = self.MA_10 - self.MA_50;
    }
    return _DMA;
}
- (float)AMA {
    if (!_AMA) {
        if (self.index > 9) {
            JT_KLineModel *preDaysModel = self.allKLineModel[self.index - 10];
            _AMA = (self.sumOfLastDMA - preDaysModel.sumOfLastDMA) / 10;
        } else {
            _AMA = self.sumOfLastDMA / (self.index + 1);
        }
    }
    return _AMA;
}
- (float)sumOfLastDMA {
    if (!_sumOfLastDMA) {
        _sumOfLastDMA = self.preModel.sumOfLastDMA + self.DMA;
    }
    return _sumOfLastDMA;
}


- (void)initData {
    
    [self preModel];
    
    //初始化收盘MA
    
    [self MA5];
    [self MA10];
    [self MA20];
    [self MA30];
    [self MA60];
    
    //初始化 Volume
    [self volumeMA5];
    [self volumeMA10];
    
    //初始化 KDJ
//    [self KDJ_K];
//    [self KDJ_D];
//    [self KDJ_J];
    
    //初始化MACD
//    [self DIF];
//    [self DEA];
//    [self MACD];
    
    //初始化BOOL线
//    [self MB];
//    [self UP];
//    [self DN];
    
    //初始化RSI
    [self RSI6];
    [self RSI12];
    [self RSI24];
    
    //初始化 DMA
//    [self DMA];
//    [self AMA];

}
@end
