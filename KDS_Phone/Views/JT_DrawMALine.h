//
//  JT_DrawMALine.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/4.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JT_DrawMALine : NSObject


/**
 *  根据context初始化
 */
- (instancetype)initWithContext:(CGContextRef)context;



/**
 画线

 @param color 线颜色
 @param postions 画线的点
 */
- (void)drawLineWith:(UIColor *)color positions:(NSArray <NSValue*>*)postions;

@end
