//
//  JT_TimelineAccessoryView.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/18.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JT_KLineEnum.h"
@class MStockItem;
@interface JT_TimelineAccessoryView : UIView
- (instancetype)initWithType:(JT_DeviceOrientation)orientation;
- (void)updateWithModel:(MStockItem *)model;
@end
