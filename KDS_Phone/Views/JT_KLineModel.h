//
//  JT_KLineModel.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/3.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <Foundation/Foundation.h>
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
@property (nonatomic, copy) NSString *tradeVolume;
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


/**
 为了计算均值，这个属性值是必须要设置的
 */
@property (nonatomic ,weak)  NSMutableArray <JT_KLineModel *>*allKLineModel;

//5日均线 ,MA5 只是默认设置计算5天，对应位置可以设置为 7 日、15日均线等，下同
@property (nonatomic ,strong)NSString *MA5;
//10日均线
@property (nonatomic ,strong)NSString *MA10;
//20日均线
@property (nonatomic ,strong)NSString *MA20;
//30日均线
@property (nonatomic ,strong)NSString *MA30;
//60日均线
@property (nonatomic ,strong)NSString *MA60;

//上证 k 线model 转 JT_KLineModel

- (instancetype)initWithModel:(MOHLCItem *)model;

@end
