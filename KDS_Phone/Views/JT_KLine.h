//
//  JT_KLine.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/30.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JT_KLinePositionModel,MOHLCItem;
@interface JT_KLine : NSObject
/**
 *  K线的位置model
 */
@property (nonatomic, strong) JT_KLinePositionModel *kLinePositionModel;

/**
 *  k线的model
 */
@property (nonatomic, strong) MOHLCItem *kLineModel;

/**
 *  最大的Y
 */
@property (nonatomic, assign) CGFloat maxY;

/**
 *  根据context初始化
 */
- (instancetype)initWithContext:(CGContextRef)context;

/**
 *  绘制K线
 */
- (UIColor *)draw;
@end
