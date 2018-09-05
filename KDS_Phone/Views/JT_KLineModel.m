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
- (NSString *)MA5 {
    if ([JT_KLineConfig MA5]) {
        return [self calculateMAValue:[JT_KLineConfig MA5]];
    } else {
        return nil;
    }
}

- (NSString *)MA10 {
    if ([JT_KLineConfig MA10]) {
        return [self calculateMAValue:[JT_KLineConfig MA10]];
    } else {
        return nil;
    }
}

- (NSString *)MA20 {
    if ([JT_KLineConfig MA20]) {
        return [self calculateMAValue:[JT_KLineConfig MA20]];
    } else {
        return nil;
    }
}

- (NSString *)MA30 {
    if ([JT_KLineConfig MA30]) {
        return [self calculateMAValue:[JT_KLineConfig MA30]];
    } else {
        return nil;
    }
}

- (NSString *)MA60 {
    if ([JT_KLineConfig MA60]) {
        return [self calculateMAValue:[JT_KLineConfig MA60]];
    } else {
        return nil;
    }
}
//- (JT_KLineModel *)PreModel {
//    if (self.index > 0) {
//        return self.allKLineModel[self.index -1];
//    }
//    return nil;
//}
- (BOOL)needShowTime {
    if (self.index % 30 == 0) {
        return YES;
    }
    return NO;
}
- (NSString *)calculateMAValue:(NSUInteger)days {
    if (self.index + 1 >= days) {
        __block CGFloat total = 0;
        NSArray <JT_KLineModel *>*subArray = [self.allKLineModel subarrayWithRange:NSMakeRange(self.index - days + 1, days)];
        [subArray enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            total += [obj.closePrice floatValue];
        }];
        return [NSString stringWithFormat:@"%.2f",total / days];
    } else {
        __block CGFloat total = 0;
        NSArray <JT_KLineModel *>*subArray = [self.allKLineModel subarrayWithRange:NSMakeRange(0, self.index + 1)];
        [subArray enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            total += [obj.closePrice floatValue];
        }];
        return [NSString stringWithFormat:@"%.2f",total / (self.index + 1)];
    }
}

- (NSUInteger)volumeMA5 {
    return [self calculateVolumeMAValue:5];
}
- (NSUInteger)volumeMA10 {
    return [self calculateVolumeMAValue:10];
}
- (NSUInteger)calculateVolumeMAValue:(NSUInteger)days {
    if (self.index + 1 >= days) {
        __block NSUInteger total = 0;
        NSArray <JT_KLineModel *>*subArray = [self.allKLineModel subarrayWithRange:NSMakeRange(self.index - days + 1, days)];
        [subArray enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            total += obj.tradeVolume;
        }];
        return total / days;
    } else {
        __block NSUInteger total = 0;
        NSArray <JT_KLineModel *>*subArray = [self.allKLineModel subarrayWithRange:NSMakeRange(0, self.index + 1)];
        [subArray enumerateObjectsUsingBlock:^(JT_KLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            total += obj.tradeVolume;
        }];
        return total / (self.index + 1);
    }
}
@end
