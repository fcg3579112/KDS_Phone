//
//  JT_KLineCandlePositionModel.h
//  KDS_Phone
//
//  Created by feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JT_KLineCandlePositionModel : NSObject
@property (nonatomic ,assign) CGPoint openPoint;
@property (nonatomic ,assign) CGPoint closePoint;
@property (nonatomic ,assign) CGPoint lowPoint;
@property (nonatomic ,assign) CGPoint highPoint;

@property (nonatomic ,assign) CGPoint buySellPoint;
@end
