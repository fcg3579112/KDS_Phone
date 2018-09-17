//
//  JT_QuotationDataManager.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/14.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MOHLCItem;
@interface JT_QuotationDataManager : NSObject


/**
 请求 k 线数据

 @param code 股票代码
 @param completed 返回结果
 */
+ (void)requestKLineDataWithCode:(NSString *)code completed:(void(^)(BOOL successed,NSArray <MOHLCItem *>*items))completed;

/**
 请求某个时间之前的数据

 @param code 股票代码
 @param datetime 时间
 @param completed 返回结果
 */
+ (void)requestKLineOlderDataWithCode:(NSString *)code datetime:(NSString *)datetime completed:(void(^)(BOOL successed,NSArray <MOHLCItem *>*items))completed;

/**
 请求某个时间之后的数据
 
 @param code 股票代码
 @param datetime 时间
 @param completed 返回结果
 */
+ (void)requestKLineNewerDataWithCode:(NSString *)code datetime:(NSString *)datetime completed:(void(^)(BOOL successed,NSArray <MOHLCItem *>*items))completed;
@end
