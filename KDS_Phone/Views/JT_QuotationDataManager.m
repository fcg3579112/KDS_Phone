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
@implementation JT_QuotationDataManager

/**
 请求 k 线数据
 
 @param code 股票代码
 @param completed 返回结果
 */
+ (void)requestKLineDataWithCode:(NSString *)code completed:(void(^)(BOOL successed,NSArray <MOHLCItem *>*items))completed {
    MOHLCRequest *request = [[MOHLCRequest alloc] init];
    request.code = code;
    request.period = [self getMOHLCPeriod];
    request.subtype = @"1400";
    request.priceAdjustedMode = [JT_KLineConfig kLineFQType];
    [MApi sendRequest:request completionHandler:^(MResponse *resp) {
        MOHLCResponse *response = (MOHLCResponse *)resp;
        if (response.status == MResponseStatusSuccess) {
            completed(YES ,response.OHLCItems);
        } else {
            completed(NO,nil);
        }
    }];
}

/**
 请求某个时间之前的数据
 
 @param code 股票代码
 @param datetime 时间
 @param completed 返回结果
 */
+ (void)requestKLineOlderDataWithCode:(NSString *)code datetime:(NSString *)datetime completed:(void(^)(BOOL successed,NSArray <MOHLCItem *>*items))completed {
    MOHLCRequestV2 *request = [[MOHLCRequestV2 alloc]init];
    request.code = code;
    request.subtype = @"1001";
    request.period = [self getMOHLCPeriod];
    request.date = datetime;
    request.requestType = MRequestTypeOlder;
    request.priceAdjustedMode = [JT_KLineConfig kLineFQType];
    [MApi sendRequest:request completionHandler:^(MResponse *resp) {
        MOHLCResponse *response = (MOHLCResponse *)resp;
        if (response.status == MResponseStatusSuccess) {
            completed(YES ,response.OHLCItems);
        } else {
            completed(NO,nil);
        }
    }];
}

/**
 请求某个时间之后的数据
 
 @param code 股票代码
 @param datetime 时间
 @param completed 返回结果
 */
+ (void)requestKLineNewerDataWithCode:(NSString *)code datetime:(NSString *)datetime completed:(void(^)(BOOL successed,NSArray <MOHLCItem *>*items))completed {
    MOHLCRequestV2 *request = [[MOHLCRequestV2 alloc]init];
    request.code = code;
    request.subtype = @"1001";
    request.period = [self getMOHLCPeriod];
    request.date = datetime;
    request.requestType = MRequestTypeNewer;
    request.priceAdjustedMode = [JT_KLineConfig kLineFQType];
    [MApi sendRequest:request completionHandler:^(MResponse *resp) {
        MOHLCResponse *response = (MOHLCResponse *)resp;
        if (response.status == MResponseStatusSuccess) {
            completed(YES ,response.OHLCItems);
        } else {
            completed(NO,nil);
        }
    }];
}

/**
 获取 k 线的周期

 */
+ (MOHLCPeriod)getMOHLCPeriod {
    MOHLCPeriod kLineType = (MOHLCPeriod)([JT_KLineConfig kLineType] - 2);
    return kLineType;
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
