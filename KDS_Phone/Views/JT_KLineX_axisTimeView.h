//
//  JT_KLineX_axisTimeView.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/31.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MOHLCItem,JT_KLinePositionModel;
@interface JT_KLineX_axisTimeView : UIView

/**
 *  需要绘制的model数组
 */
@property (nonatomic, strong) NSArray <MOHLCItem *> *needDrawKLineModels;

/**
 *  需要绘制的model位置数组
 */
@property (nonatomic, strong) NSArray <JT_KLinePositionModel *>*needDrawKLinePositionModels;

@end