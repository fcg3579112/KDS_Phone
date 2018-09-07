//
//  JT_KLineVolumeView.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JT_KLineEnum.h"
@class JT_KLineModel;
@interface JT_KLineVolumeView : UIView

/**
 *  需要绘制的model数组
 */
@property (nonatomic, strong) NSMutableArray <JT_KLineModel *> *needDrawKLineModels;
@property (nonatomic, assign) float maxY;
@property (nonatomic, assign) float startXPosition;

@end
