//
//  JT_KLineModel.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/3.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MOHLCItem;
@interface JT_KLineModel : NSObject
/** 时间 */
@property (nonatomic, copy) NSString *datetime;
/** 开盘价 */
@property (nonatomic, copy) NSString *openPrice;
/** 最高价 */
@property (nonatomic, copy) NSString *highPrice;
/** 最低价 */
@property (nonatomic, copy) NSString *lowPrice;
/** 收盘价 */
@property (nonatomic, copy) NSString *closePrice;
/** 交易量 */
@property (nonatomic, assign) NSUInteger tradeVolume;
/** 均价 */
@property (nonatomic, copy) NSString *averagePrice;
/** 昨收价 */
@property (nonatomic, copy) NSString *referencePrice;
/** 成交金额 */
@property (nonatomic, copy) NSString *amount;
/** 涨跌 */
@property (nonatomic ,copy) NSString *change;
/** 涨跌幅 */
@property (nonatomic ,copy) NSString *changeRate;

@property (nonatomic, assign) BOOL needShowTime;

@property (nonatomic ,assign) NSUInteger index;

//指该Model前面一个Model
@property (nonatomic ,weak) JT_KLineModel *preModel;

/**
 *  该Model及其之前所有收盘价之和
 */
@property (nonatomic, assign) float sumOfLastClose;

/**
 *  该Model及其之前所有成交量之和
 */
@property (nonatomic, assign) NSInteger sumOfLastVolume;

/**
 为了计算均值，这个属性值是必须要设置的
 */
@property (nonatomic ,weak)  NSMutableArray <JT_KLineModel *>*allKLineModel;

//收盘价均线
@property (nonatomic ,strong)NSString *MA5;
//10日均线
@property (nonatomic ,strong)NSString *MA10;
//20日均线
@property (nonatomic ,strong)NSString *MA20;
//30日均线
@property (nonatomic ,strong)NSString *MA30;
//60日均线
@property (nonatomic ,strong)NSString *MA60;

//成交量均线
@property (nonatomic ,assign)NSUInteger volumeMA5;
@property (nonatomic ,assign)NSUInteger volumeMA10;

//KDJ

//9日内最高价
@property (nonatomic, assign) float nineClocksMaxPrice;
//9日内最低价
@property (nonatomic, assign) float nineClocksMinPrice;

@property (nonatomic, assign) float RSV_9;

@property (nonatomic, assign) float KDJ_K;

@property (nonatomic, assign) float KDJ_D;

@property (nonatomic, assign) float KDJ_J;


//上证 k 线model 转 JT_KLineModel

- (instancetype)initWithModel:(MOHLCItem *)model;

- (void)initData;

@end
