//
//  JT_PriceMarkModel.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/5.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_PriceMarkModel.h"
#import "JT_KLineModel.h"
@implementation JT_PriceMarkModel
- (NSMutableArray *)points {
    if (!_points) {
        _points = @[].mutableCopy;
    }
    return _points;
}
@end
