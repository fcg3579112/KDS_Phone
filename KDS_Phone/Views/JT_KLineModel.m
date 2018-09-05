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
        _tradeVolume = model.tradeVolume;
        _averagePrice = model.averagePrice;
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

@end
