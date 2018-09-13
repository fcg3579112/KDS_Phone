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
 
 N日RSI =N日内收盘涨幅的平均值/(N日内收盘涨幅均值+N日内收盘跌幅均值) ×100
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
        if (model.changeRate > 0) {
            sum_z += model.changeRate;
        }
        sum_all += fabsf(model.changeRate);
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

- (float)BIAS6 {
    if (!_BIAS6) {
        float average6 = [self calculateMAValue:6].floatValue;
        _BIAS6 = (self.closePrice.floatValue - average6) / average6 * 100;
    }
    return _BIAS6;
}
- (float)BIAS12 {
    if (!_BIAS12) {
        float average12 = [self calculateMAValue:12].floatValue;
        _BIAS12 = (self.closePrice.floatValue - average12) / average12 * 100;
    }
    return _BIAS12;
}
- (float)BIAS24 {
    if (!_BIAS24) {
        float average24 = [self calculateMAValue:24].floatValue;
        _BIAS24 = (self.closePrice.floatValue - average24) / average24 * 100;
    }
    return _BIAS24;
}

- (float)TR {
    if (!_TR) {
        _TR = MAX(self.highPrice.floatValue - self.lowPrice.floatValue, fabsf(self.highPrice.floatValue - self.referencePrice.floatValue));
        _TR = MAX(_TR, fabsf(self.lowPrice.floatValue - self.referencePrice.floatValue));
    }
    return _TR;
}
//+DM代表正趋向变动值即上升动向值，其数值等于当日的最高价减去前一日的最高价，如果<=0 则+DM=0。
//﹣DM代表负趋向变动值即下降动向值，其数值等于前一日的最低价减去当日的最低价，如果<=0 则-DM=0。注意-DM也是非负数。
//再比较+DM和-DM，较大的那个数字保持，较小的数字归0。
- (float)DM_U {
    if (!_DM_U) {
        _DM_U  = self.DM_U_Temp > self.DM_D_Temp ? self.DM_U_Temp : 0;
    }
    return _DM_U;
}
- (float)DM_D {
    if (!_DM_D) {
        _DM_D  = self.DM_D_Temp > self.DM_U_Temp ? self.DM_D_Temp : 0;
    }
    return _DM_D;
}
- (float)DM_U_Temp {
    if (!_DM_U_Temp) {
        _DM_U_Temp = self.highPrice.floatValue - self.preModel.highPrice.floatValue;
        _DM_U_Temp = _DM_U_Temp > 0 ? _DM_U_Temp : 0;
        if (self.index == 0) {
            _DM_U_Temp = 0;
        }
    }
    return _DM_U_Temp;
}
- (float)DM_D_Temp {
    if (!_DM_D_Temp) {
        _DM_D_Temp = self.preModel.lowPrice.floatValue - self.lowPrice.floatValue;
        _DM_D_Temp = _DM_D_Temp > 0 ? _DM_D_Temp : 0;
        if (self.index == 0) {
            _DM_D_Temp = 0;
        }
    }
    return _DM_D_Temp;
}
- (float)sumOfLastTR {
    if (!_sumOfLastTR) {
        _sumOfLastTR = self.preModel.sumOfLastTR + self.TR;
    }
    return _sumOfLastTR;
}
- (float)sumOfLastDM_D {
    if (!_sumOfLastDM_D) {
        _sumOfLastDM_D = self.preModel.sumOfLastDM_D + self.DM_D;
    }
    return _sumOfLastDM_D;
}
- (float)sumOfLastDM_U {
    if (!_sumOfLastDM_U) {
        _sumOfLastDM_U = self.preModel.sumOfLastDM_U + self.DM_U;
    }
    return _sumOfLastDM_U;
}
- (float)TR_14 {
    if (!_TR_14) {
        if (self.index > 13) {
            JT_KLineModel *preDaysModel = self.allKLineModel[self.index - 14];
            _TR_14 = (self.sumOfLastTR - preDaysModel.sumOfLastTR) / 14;
        } else {
            _TR_14 = self.sumOfLastTR / (self.index + 1);
        }
    }
    return _TR_14;
}
- (float)DM_U_14 {
    if (!_DM_U_14) {
        if (self.index > 13) {
            JT_KLineModel *preDaysModel = self.allKLineModel[self.index - 14];
            _DM_U_14 = (self.sumOfLastDM_U - preDaysModel.sumOfLastDM_U) / 14;
        } else {
            _DM_U_14 = self.sumOfLastDM_U / (self.index + 1);
        }
    }
    return _DM_U_14;
}
- (float)DM_D_14 {
    if (!_DM_D_14) {
        if (self.index > 13) {
            JT_KLineModel *preDaysModel = self.allKLineModel[self.index - 14];
            _DM_D_14 = (self.sumOfLastDM_D - preDaysModel.sumOfLastDM_D) / 14;
        } else {
            _DM_D_14 = self.sumOfLastDM_D / (self.index + 1);
        }
    }
    return _DM_D_14;
}
- (float)PDI_14 {
    if (!_PDI_14) {
        _PDI_14 = (self.DM_U_14 / self.TR_14) * 100;
    }
    return _PDI_14;
}
- (float)MDI_14 {
    if (!_MDI_14) {
        _MDI_14 = (self.DM_D_14 / self.TR_14) * 100;
    }
    return _MDI_14;
}
/**
 DX=(DI DIF÷DI SUM) ×100
 */
- (float)DX {
    if (!_DX) {
        if (self.index == 0) {
            _DX = 0;
        } else {
            if (self.PDI_14 + self.MDI_14 == 0) {
                _DX = 0;
            } else {
                _DX = fabsf(self.PDI_14 - self.MDI_14) / (self.PDI_14 + self.MDI_14) * 100;
            }
        }
    }
    return _DX;
}
- (float)sumOfLastDX {
    if (!_sumOfLastDX) {
        _sumOfLastDX = self.preModel.sumOfLastDX + self.DX;
    }
    return _sumOfLastDX;
}
//ADX就是DX的一定周期n的移动平均值。
- (float)ADX {
    if (!_ADX) {
        if (self.index > 5) {
            JT_KLineModel *preDaysModel = self.allKLineModel[self.index - 6];
            _ADX = (self.sumOfLastDX - preDaysModel.sumOfLastDX) / 6;
        } else {
            _ADX = self.sumOfLastDX / (self.index + 1);
        }
    }
    return _ADX;
}


/**
 ADXR:=(ADX+REF(ADX,M))/2;其中 M = 6 ,
 函数REF(X,N)用于引用N周期前的X值，X是一个变量，N是一个常量，REF(close（）,1)表示计算上一周期的收盘价。REF(c,3) 前三日的收盘价。
 
 REF(ADX,6)，6天前的ADX
 */
- (float)ADXR {
    if (!_ADXR) {
        if (self.index >= 6) {
            JT_KLineModel *preDaysModel = self.allKLineModel[self.index - 6];
            _ADXR = (self.ADX + preDaysModel.ADX) / 2.f;
        } else {
            _ADXR = self.ADX / 2;
        }
    }
    return _ADXR;
}

/**
 顺势指标指标 (CCI)
 */
- (float)TP {
    if (!_TP) {
        _TP = (self.highPrice.floatValue + self.lowPrice.floatValue + self.closePrice.floatValue) / 3;
    }
    return _TP;
}
- (float)sumOfLastTP {
    if (!_sumOfLastTP) {
        _sumOfLastTP = self.preModel.sumOfLastTP + self.TP;
    }
    return _sumOfLastTP;
}
- (float)TP_MA {
    if (!_TP_MA) {
        if (self.index >= 14) {
            JT_KLineModel *preDaysModel = self.allKLineModel[self.index - 14];
            _TP_MA = (self.sumOfLastTP - preDaysModel.sumOfLastTP) / 14;
        } else {
            _TP_MA = self.sumOfLastTP / (self.index + 1);
        }
    }
    return _TP_MA;
}
- (float)averageAbsoluteTP {
    if (!_averageAbsoluteTP) {
        NSInteger index = self.index;
        float sum = 0;
        for (NSInteger i = index; i >= 0 ; i --) {
            JT_KLineModel *model = self.allKLineModel[i];
            sum += fabsf(self.TP_MA - model.TP);
            if (index - i >= 13) {
                break;
            }
        }
        NSUInteger count = self.index >= 13 ? 14 : self.index + 1;
        _averageAbsoluteTP = sum / count;
    }
    return _averageAbsoluteTP;
}
- (float)CCI {
    if (!_CCI) {
        if (self.averageAbsoluteTP == 0) {
            _CCI = 0;
        } else {
            _CCI = (self.TP - self.TP_MA) / (0.015 * self.averageAbsoluteTP);
        }
    }
    return _CCI;
}
- (float)WR10 {
    if (!_WR10) {
        _WR10 = [self calculateWRWithDays:10];
    }
    return _WR10;
}
- (float)WR6 {
    if (!_WR6) {
        _WR6 = [self calculateWRWithDays:6];
    }
    return _WR6;
}
- (float)calculateWRWithDays:(NSInteger)days{
    NSInteger index = self.index;
    float high = self.highPrice.floatValue;
    float low = self.lowPrice.floatValue;
    for (NSInteger i = index; i > 0; -- i) {
        JT_KLineModel *model = self.allKLineModel[i];
        high = MAX(high, model.highPrice.floatValue);
        low = MIN(low, model.lowPrice.floatValue);
        if (index - i >= days - 1) {
            break;
        }
    }
    return 100 * fabsf(high - self.closePrice.floatValue) / fabsf(high - low);
}

/**
 成交量比率
 */


//周期为 26 天
- (float)VR {
    if (!_VR) {
        float avs = 0;
        float bvs = 0;
        float cvs = 0;
        NSUInteger index = self.index;
        for (NSInteger i = index; i >= 0; i --) {
            JT_KLineModel *model = self.allKLineModel[i];
            if (model.closePrice.floatValue > model.referencePrice.floatValue) {
                avs += model.tradeVolume;
            } else if (model.closePrice.floatValue < model.referencePrice.floatValue) {
                bvs += model.tradeVolume;
            } else {
                cvs += model.tradeVolume;
            }
            if (index - i >= 25) {
                break;
            }
        }
        if (cvs == 0 && bvs == 0) {
            _VR = 100;
        } else {
            _VR = (avs + 1/2 * cvs) / (bvs + 1/2 * cvs) * 100;
        }
    }
    return _VR;
}
- (float)sumOfLastVR {
    if (!_sumOfLastVR) {
        _sumOfLastVR = self.preModel.sumOfLastVR + self.VR;
    }
    return _sumOfLastVR;
}
- (float)MAVR {
    if (!_MAVR) {
        if (self.index >= 6) {
            JT_KLineModel *preDaysModel = self.allKLineModel[self.index - 6];
            _MAVR = (self.sumOfLastVR - preDaysModel.sumOfLastVR) / 6;
        } else {
            _MAVR = self.sumOfLastVR / (self.index + 1);
        }
    }
    return _MAVR;
}

- (float)M {
    if (!_M) {
        _M = (self.closePrice.floatValue + self.highPrice.floatValue + self.lowPrice.floatValue + self.openPrice.floatValue) / 4;
    }
    return _M;
}
- (float)H_YM {
    if (!_H_YM) {
        if (self.index == 0) {
            _H_YM = 0;
        } else {
            _H_YM = self.highPrice.floatValue - self.preModel.M;
        }
    }
    
    return _H_YM;
}
- (float)YM_L {
    if (!_YM_L) {
        if (self.index == 0) {
            _YM_L = 0;
        } else {
            _YM_L = self.preModel.M - self.lowPrice.floatValue;
        }
    }
    return _YM_L;
}
- (float)sumOfLastH_YM {
    if (!_sumOfLastH_YM) {
        _sumOfLastH_YM = self.preModel.sumOfLastH_YM + self.H_YM;
    }
    return _sumOfLastH_YM;
}
- (float)sumOfLastYM_L {
    if (!_sumOfLastYM_L) {
        _sumOfLastYM_L = self.preModel.sumOfLastYM_L + self.YM_L;
    }
    return _sumOfLastYM_L;
}

- (float)CR {
    if (!_CR) {
        float p1 = 0;
        float p2 = 0;
        if (self.index >= 26) {
            JT_KLineModel *preDaysModel = self.allKLineModel[self.index - 26];
            p1 = self.sumOfLastH_YM - preDaysModel.sumOfLastH_YM;
            p2 = self.sumOfLastYM_L - preDaysModel.sumOfLastYM_L;
        } else {
            p1 = self.sumOfLastH_YM;
            p2 = self.sumOfLastYM_L;
        }
        if (p2 == 0) {
            _CR = 100;
        } else {
            _CR = p1 / p2 * 100;
        }
    }
    return _CR;
}
- (float)sumOfLastCR {
    if (!_sumOfLastCR) {
        _sumOfLastCR = self.preModel.sumOfLastCR + self.CR;
    }
    return _sumOfLastCR;
}
- (float)CR_MA_10 {
    if (!_CR_MA_10) {
        _CR_MA_10 = [self calculateCR_MA_Days:10];
    }
    return _CR_MA_10;
}
- (float)CR_MA_20 {
    if (!_CR_MA_20) {
        _CR_MA_20 = [self calculateCR_MA_Days:20];
    }
    return _CR_MA_20;
}
- (float)CR_MA_40 {
    if (!_CR_MA_40) {
        _CR_MA_40 = [self calculateCR_MA_Days:40];
    }
    return _CR_MA_40;
}
- (float)CR_MA_62 {
    if (!_CR_MA_62) {
        _CR_MA_62 = [self calculateCR_MA_Days:62];
    }
    return _CR_MA_62;
}
- (float)calculateCR_MA_Days:(NSUInteger)days {
    if (self.index >= days) {
        JT_KLineModel *preDaysModel = self.allKLineModel[self.index - days];
        return (self.sumOfLastCR - preDaysModel.sumOfLastCR) / days;
    }
    return self.sumOfLastCR / (self.index + 1);
}

- (NSInteger)OBV {
    if (!_OBV) {
        if (self.index == 0) {
            _OBV = self.tradeVolume;
        } else {
            _OBV = self.preModel.OBV + self.tradeVolume * (self.closePrice.floatValue > self.referencePrice.floatValue ? 1 : -1);
        }
    }
    return _OBV;
}
- (NSInteger)sumOfLastOBV {
    if (!_sumOfLastOBV) {
        _sumOfLastOBV = self.preModel.sumOfLastOBV + self.OBV;
    }
    return _sumOfLastOBV;
}
- (NSInteger)MAOBV {
    if (!_MAOBV) {
        if (self.index >= 30) {
            JT_KLineModel *preDaysModel = self.allKLineModel[self.index - 30];
            _MAOBV = (self.sumOfLastOBV - preDaysModel.sumOfLastOBV) / 30;
        } else {
            _MAOBV = self.sumOfLastOBV / (self.index + 1);
        }
    }
    return _MAOBV;
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
//    [self RSI6];
//    [self RSI12];
//    [self RSI24];
    
    //初始化 DMA
//    [self DMA];
//    [self AMA];
    
//    [self ADX];
    
    //初始化BIAS
//    [self BIAS6];
//    [self BIAS12];
//    [self BIAS24];
    
    //初始化 DMI指标
//    [self PDI_14];
//    [self MDI_14];

//    [self DX];
//    [self ADX];
//    [self ADXR];
    //CCI顺势指标指标
//      [self CCI];
    
    //强弱指标
//    [self WR6];
    
    //成交量比率
//    [self VR];
//    [self MAVR];
    //能量指标 (CR)
   // [self CR];
    
    //能量潮 (OBV)
    //[self OBV];
}
@end
