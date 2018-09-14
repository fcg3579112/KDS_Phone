//
//  JT_PriceMarkModel.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/5.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 存储最高点，最低点价格及坐标信息信息
 */
@class JT_KLineModel;
@interface JT_PriceMarkModel : NSObject
@property (nonatomic ,strong) JT_KLineModel *kLineModel;
@property (nonatomic ,strong) NSMutableArray *points; //斜线上的2个点
@property (nonatomic ,assign) CGRect priceRect;
//在屏幕上的索引，用于判断该标识是遍左还偏右
@property (nonatomic ,assign) NSInteger index;
@end

