//
//  MStockItem+Addition.h
//  ZhongXinJianTou_Phone
//
//  Created by chuangao.feng on 2018/8/23.
//  Copyright © 2018年 kds. All rights reserved.
//

#import "MApiObject.h"
#import <UIKit/UIKit.h>
@interface MStockItem (Addition)
@property (nonatomic ,strong ,readonly) NSString *code_JT;
@property (nonatomic ,strong ,readonly) NSString *lastPrice_JT;
@property (nonatomic ,strong ,readonly) NSString *changeRate_JT;
@property (nonatomic ,strong ,readonly) NSString *changeRate_OptionalStock;//用于自选股页面
@property (nonatomic ,strong ,readonly) NSString *change_JT;
@property (nonatomic ,strong ,readonly) NSString *preClosePrice_JT;
@property (nonatomic ,strong ,readonly) NSString *volume_JT;
@property (nonatomic ,strong ,readonly) NSString *amount_JT;
@property (nonatomic ,strong ,readonly) NSString *openPrice_JT;
@property (nonatomic ,strong ,readonly) NSString *highPrice_JT;
@property (nonatomic ,strong ,readonly) NSString *lowPrice_JT;
@property (nonatomic ,strong ,readonly) NSString *PE_JT;
@property (nonatomic ,strong ,readonly) NSString *turnoverRate_JT;
@property (nonatomic ,strong ,readonly) NSString *stockStage_JT;

//今开价格的颜色
@property (nonatomic ,strong ,readonly) UIColor *lastPriceColor;

//用于自选股类似列表页面
@property (nonatomic ,strong ,readonly) UIColor *changeRateBgColor;
@property (nonatomic ,strong ,readonly) UIColor *changeRateColor;

@end
