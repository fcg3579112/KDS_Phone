//
//  MStockItem+Addition.m
//  ZhongXinJianTou_Phone
//
//  Created by chuangao.feng on 2018/8/23.
//  Copyright © 2018年 kds. All rights reserved.
//


#define OpenPrice_GrayColor                 JT_ColorDayOrNight(@"333333", @"666666")
#define OpenPrice_RedColor                  JT_ColorDayOrNight(@"FF3D00", @"FF3D00")
#define OpenPrice_GreenColor                JT_ColorDayOrNight(@"0DB14B", @"0DB14B")


#import "MStockItem+Addition.h"
#import "JT_ColorManager.h"
//sh,sz,hk,hh,hz,bj 分别是沪股，深股，港股，沪港通，深港通，新三板市场

@implementation MStockItem (Addition)
BOOL isEmpty(NSString *string) {
    return [string isEqualToString:@""];
}
- (NSString *)code_JT{
    NSArray *components = [self.code componentsSeparatedByString:@"."];
    return components.firstObject;
}

- (NSString *)changeRate_JT{
    if (isEmpty(self.changeRate)) {
        return @"--";
    }
    NSString *changeRate = @"0.00%";
    if (self.changeState == MChangeStateDrop) {
        changeRate = [NSString stringWithFormat:@"-%@%%",self.changeRate];
    } else if (self.changeState == MChangeStateRise) {
        changeRate = [NSString stringWithFormat:@"+%@%%",self.changeRate];
    } else {
        changeRate = [NSString stringWithFormat:@"%@%%",self.changeRate];
    }
    return changeRate;
}
- (NSString *)changeRate_OptionalStock {
    if (self.status == MStockStatusUnmarket) {
        return @"退市";
    }
    if (self.status == MStockStatusSuspend) {
        return @"停牌";
    }
    if (isEmpty(self.changeRate)) {
        return @"--";
    }
    NSString *changeRate = @"0.00%";
    if (self.changeState == MChangeStateDrop) {
        changeRate = [NSString stringWithFormat:@"-%@%%",self.changeRate];
    } else if (self.changeState == MChangeStateRise) {
        changeRate = [NSString stringWithFormat:@"+%@%%",self.changeRate];
    } else {
        changeRate = [NSString stringWithFormat:@"%@%%",self.changeRate];
    }
    return changeRate;
}
- (NSString *)change_JT{
    if (self.status == MStockStatusSuspend || self.status == MStockStatusUnmarket || isEmpty(self.change)) {
        return @"--";
    }
    NSString *change = @"0.00";
    if (self.changeState == MChangeStateDrop) {
        change = [NSString stringWithFormat:@"-%@",self.change];
    } else {
        change = [NSString stringWithFormat:@"+%@",self.change];
    }
    return change;
}
- (NSString *)processString:(NSString *)string {
    //停牌或退市
    if (self.status == MStockStatusSuspend || self.status == MStockStatusUnmarket || isEmpty(string) || !string) {
        return @"--";
    } else {
        return string;
    }
}
- (NSString *)lastPrice_JT{
    return [self processString:self.lastPrice];
}
- (NSString *)preClosePrice_JT{
   return [self processString:self.preClosePrice];
}
- (NSString *)volume_JT{
    return [self processString:self.volume];
}
- (NSString *)amount_JT{
    float amount = self.amount.floatValue;
    if (amount > 0) {
        if (amount > 100000000) {
            return [NSString stringWithFormat:@"%.2f亿",amount / 100000000.0];
        }else if (amount > 10000) {
            return [NSString stringWithFormat:@"%.2f万",amount / 10000.0];
        } else {
            return [NSString stringWithFormat:@"%.2f",amount];
        }
    } else {
        return @"--";
    }
}
- (NSString *)openPrice_JT{
    return [self processString:self.openPrice];
}
- (NSString *)highPrice_JT{
    return [self processString:self.highPrice];
}
- (NSString *)lowPrice_JT{
    return [self processString:self.lowPrice];
}
- (NSString *)PE_JT{
    return [self processString:self.PE];
}
- (NSString *)turnoverRate_JT{
    if (self.status != MStockStatusNormal || isEmpty(self.turnoverRate) || !self.turnoverRate) {
        return @"--";
    }
    return [NSString stringWithFormat:@"%@%%",self.turnoverRate];
}
- (NSString *)stockStage_JT {
//    MStockStageUnopen        = 0,  // 未开市
//    MStockStageVirtual       = 1,  // 盘前集合竞价
//    MStockStageAuction       = 2,  // 收盘集合竞价
//    MStockStageOpen          = 3,  // 连续竞价
//    MStockStageTempSuspensed = 4,  // 临时停市 已弃用
//    MStockStageClosed        = 5,  // 已收盘
//    MStockStageLunchBreak    = 6,  // 休市
//    MStockStageOnTrading     = 7   // 交易中 已弃用
    NSString *stockStage = @"";
    switch (self.stage) {
        case 0:
            stockStage = @"未开市";
            break;
        case 1:
            stockStage = @"盘前集合竞价";
            break;
        case 2:
            stockStage = @"收盘集合竞价";
            break;
        case 3:
            stockStage = @"连续竞价";
            break;
        case 4:
            stockStage = @"临时停市";
            break;
        case 5:
            stockStage = @"已收盘";
            break;
        case 6:
            stockStage = @"休市";
            break;
        case 7:
            stockStage = @"交易中";
            break;
            
        default:
            stockStage = @"未知";
            break;
    }
    return stockStage;
}
- (UIColor *)lastPriceColor {
    if (self.changeState == MChangeStateDrop) {
        return OpenPrice_GreenColor;
    } else if (self.changeState == MChangeStateRise) {
        return OpenPrice_RedColor;
    } else {
        return OpenPrice_GreenColor;
    }
}
- (UIColor *)changeRateBgColor{
    if (self.status == MStockStatusSuspend || self.status == MStockStatusUnmarket || isEmpty(self.changeRate)) {
        return JT_ColorDayOrNight(@"", @"");
    } else {
        if (self.changeState == MChangeStateDrop) {
            return JT_ColorStockRed();
        } else if (self.changeState == MChangeStateRise) {
            return JT_ColorStockGreen();
        } else {
            return JT_ColorStockGray();
        }
    }
}
- (UIColor *)changeRateColor{
    return JT_ColorDayOrNight(@"FFFFFF", @"FFFFFF");
}

@end
