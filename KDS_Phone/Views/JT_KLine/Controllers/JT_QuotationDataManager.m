//
//  JT_QuotationDataManager.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/14.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_QuotationDataManager.h"
#import "JT_KLineConfig.h"
#import <MApi.h>
#import <MApiObject.h>
@implementation JT_QuotationDataManager

/**
 请求 k 线数据
 
 @param code 股票代码
 @param completed 返回结果
 */
+ (void)requestKLineDataWithCode:(NSString *)code subtype:(NSString *)subtype completed:(void(^)(BOOL successed,NSArray <MOHLCItem *>*items))completed {
    if ([JT_KLineConfig kLineType] == JT_KLineTypeUnKnow) {
        completed(NO,nil);
    } else {
        MOHLCRequest *request = [[MOHLCRequest alloc] init];
        request.code = code;
        request.period = [self getMOHLCPeriod];
        request.subtype = subtype;
        request.priceAdjustedMode = [JT_KLineConfig kLineFQType];
        [MApi sendRequest:request completionHandler:^(MResponse *resp) {
            MOHLCResponse *response = (MOHLCResponse *)resp;
            if (response.status == MResponseStatusSuccess) {
                MOHLCRequest *request = (MOHLCRequest *)response.request;
                if ([self getMOHLCPeriod] != request.period) {
                    completed(NO,nil);
                } else {
                    completed(YES ,response.OHLCItems);
                }
            } else {
                completed(NO,nil);
            }
        }];
    }
}

/**
 请求某个时间之前的数据
 
 @param code 股票代码
 @param datetime 时间
 @param completed 返回结果
 */
+ (void)requestKLineOlderDataWithCode:(NSString *)code subtype:(NSString *)subtype datetime:(NSString *)datetime completed:(void(^)(BOOL successed,NSArray <MOHLCItem *>*items))completed {
    if ([JT_KLineConfig kLineType] == JT_KLineTypeUnKnow) {
        completed(NO,nil);
    } else {
        MOHLCRequestV2 *request = [[MOHLCRequestV2 alloc]init];
        request.code = code;
        request.subtype = subtype;
        request.period = [self getMOHLCPeriod];
        request.date = datetime;
        request.requestType = MRequestTypeOlder;
        request.priceAdjustedMode = [JT_KLineConfig kLineFQType];
        [MApi sendRequest:request completionHandler:^(MResponse *resp) {
            MOHLCResponse *response = (MOHLCResponse *)resp;
            if (response.status == MResponseStatusSuccess) {
                MOHLCRequestV2 *request = (MOHLCRequestV2 *)response.request;
                if ([self getMOHLCPeriod] != request.period) {
                    completed(NO,nil);
                } else {
                    completed(YES ,response.OHLCItems);
                }
            } else {
                completed(NO,nil);
            }
        }];
    }
}

/**
 请求某个时间之后的数据
 
 @param code 股票代码
 @param datetime 时间
 @param completed 返回结果
 */
+ (void)requestKLineNewerDataWithCode:(NSString *)code subtype:(NSString *)subtype datetime:(NSString *)datetime completed:(void(^)(BOOL successed,NSArray <MOHLCItem *>*items))completed {
    if ([JT_KLineConfig kLineType] == JT_KLineTypeUnKnow) {
        completed(NO,nil);
    } else {
        MOHLCRequestV2 *request = [[MOHLCRequestV2 alloc]init];
        request.code = code;
        request.subtype = subtype;
        request.period = [self getMOHLCPeriod];
        request.date = datetime;
        request.requestType = MRequestTypeNewer;
        request.priceAdjustedMode = [JT_KLineConfig kLineFQType];
        [MApi sendRequest:request completionHandler:^(MResponse *resp) {
            MOHLCResponse *response = (MOHLCResponse *)resp;
            if (response.status == MResponseStatusSuccess) {
                MOHLCRequestV2 *request = (MOHLCRequestV2 *)response.request;
                if ([self getMOHLCPeriod] != request.period) {
                    completed(NO,nil);
                } else {
                    completed(YES ,response.OHLCItems);
                }
            } else {
                completed(NO,nil);
            }
        }];
    }
}

/**
 获取 k 线的周期

 */

+ (MOHLCPeriod)getMOHLCPeriod {
    switch ([JT_KLineConfig kLineType]) {
        case JT_KLineTypeDay:
            return MOHLCPeriodDay;
            break;
        case JT_KLineTypeWeek:
            return MOHLCPeriodWeek;
            break;
        case JT_KLineTypeMonth:
            return MOHLCPeriodMonth;
            break;
        case JT_KLineType5Min:
            return MOHLCPeriodMin5;
            break;
        case JT_KLineType15Min:
            return MOHLCPeriodMin15;
            break;
        case JT_KLineType30Min:
            return MOHLCPeriodMin30;
            break;
        case JT_KLineType60Min:
            return MOHLCPeriodMin60;
            break;
        default:
            return MOHLCPeriodDay;
            break;
    }
}

// sh,sz,hk,hh,hz,bj 分别是沪股，深股，港股，沪港通，深港通，新三板市场
+ (NSString *)getSubtype:(NSString *)code {
    
    NSString *subType =@"";
    if ([code hasSuffix:@"sh"]) {
        subType = @"";
    } else if ([code hasSuffix:@"sz"]) {
        
    } else if ([code hasSuffix:@"sz"]) {
        
    } else if ([code hasSuffix:@"hk"]) {
        
    } else if ([code hasSuffix:@"hh"]) {
        
    } else if ([code hasSuffix:@"hz"]) {
        
    } else if ([code hasSuffix:@"bj"]) {
        
    }
    return subType;
}
@end
