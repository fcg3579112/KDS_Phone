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
@property (nonatomic ,assign) float change;
/** 涨跌幅 */
@property (nonatomic ,assign) float changeRate;

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


/* MACD 计算
 1、计算移动平均值（EMA）
 12日EMA的算式为
 EMA（12）=前一日EMA（12）×11/13+今日收盘价×2/13
 26日EMA的算式为
 EMA（26）=前一日EMA（26）×25/27+今日收盘价×2/27
 2、计算离差值（DIF）
 DIF=今日EMA（12）－今日EMA（26）
 3、计算DIF的9日EMA
 根据离差值计算其9日的EMA，即离差平均值，是所求的MACD值。为了不与指标原名相混淆，此值又名
 DEA或DEM。
 今日DEA（MACD）=前一日DEA×8/10+今日DIF×2/10计算出的DIF和DEA的数值均为正值或负值。
 用（DIF-DEA）×2即为MACD柱状图。
*/
@property (nonatomic, assign) float EMA12;

@property (nonatomic, assign) float EMA26;

@property (nonatomic, assign) float DIF;

@property (nonatomic, assign) float DEA;

@property (nonatomic, assign) float MACD;



/**
 BOOL计算方式
 （1）计算MA
 MA=N日内的收盘价之和÷N
 （2）计算标准差MD
 MD=平方根（N-1）日的（C－MA）的两次方之和除以N
 （3）计算MB、UP、DN线
 MB=（N－1）日的MA
 UP=MB+k×MD
 DN=MB－k×MD
 （K为参数，可根据股票的特性来做相应的调整，一般默认为2）
 */
@property (nonatomic, assign) float MA_20;

@property (nonatomic, assign) float MD;
@property (nonatomic, assign) float MB;
@property (nonatomic, assign) float UP;
@property (nonatomic, assign) float DN;


/**
 计算RSI
 方法一：
 SMA(X,N,M)，求X的N日移动平均，M为权重。算法：若Y=SMA(X,N,M) 则 Y=(M*X+(N-M)*Y')/N，其中Y'表示上一周期Y值，N必须大于M。
 
 RSI:= SMA(MAX(Close-LastClose,0),N,1)/SMA(ABS(Close-LastClose),N,1)*100
 
 方法二：
 N日RSI =N日内收盘涨幅的平均值/(N日内收盘涨幅均值+N日内收盘跌幅均值) ×100
 
 两种方式计算结果不一样，大部分 app 都用的是方法一。
 */

@property (nonatomic ,assign) float SMA6;
@property (nonatomic ,assign) float SMA6_A;
@property (nonatomic ,assign) float SMA12;
@property (nonatomic ,assign) float SMA12_A;
@property (nonatomic ,assign) float SMA24;
@property (nonatomic ,assign) float SMA24_A;

@property (nonatomic, assign) float RSI6;
@property (nonatomic, assign) float RSI12;
@property (nonatomic, assign) float RSI24;

/**
 计算DMA
 计算公式编辑
 DMA=股价短期平均值—股价长期平均值
 AMA=DMA短期平均值
 以求10日、50日为基准周期的DMA指标为例，其计算过程具体如下：
 DMA（10）=10日股价平均值—50日股价平均值
 AMA（10）=10日DMA平均值
 */
@property (nonatomic, assign) float MA_10;
@property (nonatomic, assign) float MA_50;
@property (nonatomic, assign) float DMA;
/**
 *  该Model及其之前所有DMA
 */
@property (nonatomic, assign) float sumOfLastDMA;
@property (nonatomic, assign) float AMA;


/**
 乖离率(BIAS)，又称偏离率，简称Y值，是通过计算市场指数或收盘价与某条移动平均线之间的差距百分比，以反映一定时期内价格与其MA偏离程度的指标，
 从而得出价格在剧烈波动时因偏离移动平均趋势而造成回档或反弹的可能性，以及价格在正常波动范围内移动而形成继续原有势的可信度。
 乖离率=[(当日收盘价-N日平均价)/N日平均价]*100%
 */

@property (nonatomic, assign) float MA_6;
@property (nonatomic, assign) float MA_12;
@property (nonatomic, assign) float MA_24;

@property (nonatomic, assign) float BIAS6;
@property (nonatomic, assign) float BIAS12;
@property (nonatomic, assign) float BIAS24;


/**
 动向指标(DMI)
 介绍及计算方法 https://baike.baidu.com/item/DMI%E6%8C%87%E6%A0%87/3423254?fromtitle=DMI&fromid=10910045&fr=aladdin
 */

@property (nonatomic, assign) float ADX;
@property (nonatomic, assign) float ADXR;

/**
 A、当日的最高价减去当日的最低价的价差。
 B、当日的最高价减去前一日的收盘价的价差。
 C、当日的最低价减去前一日的收盘价的价差。
 TR是A、B、C中的数值绝对值最大者
 */
@property (nonatomic, assign) float TR;
@property (nonatomic, assign) float TR_14;

/**
 动向指数的当日动向值分为上升动向、下降动向和无动向等三种情况，每日的当日动向值只能是三种情况的一种。
 A、上升动向（+DM）
 +DM代表正趋向变动值即上升动向值，其数值等于当日的最高价减去前一日的最高价，如果<=0 则+DM=0。
 B、下降动向（-DM）
 ﹣DM代表负趋向变动值即下降动向值，其数值等于前一日的最低价减去当日的最低价，如果<=0 则-DM=0。注意-DM也是非负数。
 再比较+DM和-DM，较大的那个数字保持，较小的数字归0。
 C、无动向
 无动向代表当日动向值为“零”的情况，即当日的+DM和﹣DM同时等于零。有两种股价波动情况下可能出现无动向。一是当当日的最高价低于前一日的最高价并且当日的最低价高于前一日的最低价，二是当上升动向值正好等于下降动向值。
 */
@property (nonatomic, assign) float DM_U_Temp;
@property (nonatomic, assign) float DM_D_Temp;
@property (nonatomic, assign) float DM_U;//上升动向
@property (nonatomic, assign) float DM_D;//下降动向

@property (nonatomic, assign) float DM_U_14;//上升动向14日均值
@property (nonatomic, assign) float DM_D_14;//下降动向14日均值
/**
 *  该Model及其之前所有  TR / DM_U / DM_D / ADX之后
 */
@property (nonatomic, assign) float sumOfLastTR;
@property (nonatomic, assign) float sumOfLastDM_U;
@property (nonatomic, assign) float sumOfLastDM_D;
//多空指标包括(+DI多方、-DI空方) 计算14日均线

@property (nonatomic, assign) float PDI_14;//多方
@property (nonatomic, assign) float MDI_14;//空方

@property (nonatomic, assign) float DX;
/**
 *  该Model及其之前所有DX
 */
@property (nonatomic, assign) float sumOfLastDX;


/**
 顺势指标指标 (CCI)
 方法一：
 * CCI(n) = (TP－ MA) ÷MD ÷0.015
 * TP = (最高价 + 最低价 + 收盘价) ÷ 3
 * MA = 最近n日(TP)价的累计和÷n
 * MD = 最近n日 (MA - 收盘价)的绝对值的累计和 ÷ n
 * 系统默认n为14
 方法二：
 第二种计算方法表述为中价与中价的N日内移动平均的差除以0.015*N日内中价的平均绝对偏差
 其中，中价等于最高价、最低价和收盘价之和除以3
 平均绝对偏差为统计函数
 
 
 */
@property (nonatomic, assign) float CCI;
@property (nonatomic, assign) float TP;
@property (nonatomic, assign) float TP_MA;

@property (nonatomic, assign) float sumOfLastTP;
/**
 平均绝对偏差
 */
@property (nonatomic, assign) float averageAbsoluteTP;


//上证 k 线model 转 JT_KLineModel

- (instancetype)initWithModel:(MOHLCItem *)model;

- (void)initData;

@end
