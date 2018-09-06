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
        do {
            if (index == self.index) {
                _nineClocksMinPrice = self.allKLineModel[index].lowPrice.floatValue;
            } else {
                float lowPrice = self.allKLineModel[index].lowPrice.floatValue;
                if (lowPrice < _nineClocksMinPrice) {
                    _nineClocksMinPrice = lowPrice;
                }
            }
            index --;
            if (index != self.index - 9) {
                break;
            }
        } while (index >= 0);
    }
    return _nineClocksMinPrice;
}
- (float)nineClocksMaxPrice {
    if (!_nineClocksMaxPrice) {
        NSInteger index = self.index;
        do {
            if (index == self.index) {
                _nineClocksMaxPrice = self.allKLineModel[index].highPrice.floatValue;
            } else {
                float highPrice = self.allKLineModel[index].highPrice.floatValue;
                if (highPrice > _nineClocksMinPrice) {
                    _nineClocksMaxPrice = highPrice;
                }
            }
            index --;
            if (index != self.index - 9) {
                break;
            }
        } while (index >= 0);
    }
    return _nineClocksMaxPrice;
}
//9日RSV=（9日的收盘价－9日内的最低价）÷（9日内的最高价－9日内的最低价）×100 
//如果9日内的最高价等于9日内的最低价 RSV = 100
- (float)RSV_9 {
    if (!_RSV_9) {
        if (self.nineClocksMinPrice == self.nineClocksMinPrice) {
            _RSV_9 = 100;
        } else {
            _RSV_9 = (self.closePrice.floatValue - self.nineClocksMinPrice) * 100 / (self.nineClocksMaxPrice - self.nineClocksMinPrice);
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
        if (self.index == 0) {
            _KDJ_K = 50;
        } else {
            _KDJ_K = ( self.RSV_9 + 2 * (self.preModel.KDJ_K ? self.preModel.KDJ_K : 50) ) / 3;
        }
    }
    return _KDJ_K;
}
- (float)KDJ_D {
    if(!_KDJ_D) {
        if (self.index == 0) {
            _KDJ_D = 50;
        } else {
            _KDJ_D = ( self.KDJ_K + 2 * (self.preModel.KDJ_D ? self.preModel.KDJ_D : 50 )) / 3;
        }
    }
    return _KDJ_D;
}
- (float)KDJ_J {
    if(!_KDJ_J) {
        _KDJ_J = 3 * self.KDJ_K - 2 * self.KDJ_D;
    }
    return _KDJ_J;
}
- (void)initData {
    
    [self preModel];
    
    //初始化收盘MA
    [self sumOfLastClose];
    [self MA5];
    [self MA10];
    [self MA20];
    [self MA30];
    [self MA60];
    
    //初始化 Volume
    [self sumOfLastVolume];
    [self volumeMA5];
    [self volumeMA10];
    
    //初始化 KDJ
    [self nineClocksMaxPrice];
    [self nineClocksMinPrice];
    [self RSV_9];
    [self KDJ_K];
    [self KDJ_D];
    [self KDJ_J];
}
@end
