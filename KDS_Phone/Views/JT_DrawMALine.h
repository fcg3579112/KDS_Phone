//
//  JT_DrawMALine.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/4.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JT_KLinePositionModel;
@interface JT_DrawMALine : NSObject

/**
 *  K线的位置model
 */
@property (nonatomic, strong) NSMutableArray<JT_KLinePositionModel *> *kLinePositionModels;

/**
 *  根据context初始化
 */
- (instancetype)initWithContext:(CGContextRef)context;

//画收盘价均线
- (void)drawMA5;
- (void)drawMA10;
- (void)drawMA20;
- (void)drawMA30;
- (void)drawMA60;


//画成交量均线
- (void)drawVolumeMA5;
- (void)drawVolumeMA10;
@end
