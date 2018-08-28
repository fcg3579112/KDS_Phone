//
//  JT_ColorManager.h
//  ZhongXinJianTou_Phone
//
//  Created by chuangao.feng on 2018/8/23.
//  Copyright © 2018年 kds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JT_ColorManager : NSObject

BOOL isDayTheme(void);


/**
 设置颜色，分为白模颜色和夜模颜色，白模颜色是必须传的。如果夜模颜色不传或为空，就默认设置和白模一样的颜色。

 @param dayHexString 白模对应的颜色
 @param nightHexString 夜模对应的颜色
 @return 控件当前的颜色
 */
UIColor *JT_ColorDayOrNight(NSString*dayHexString, NSString*nightHexString);

UIColor *JT_ColorWithHex(NSString *color);

//股票红色
UIColor *JT_ColorStockRed(void);
//股票绿色
UIColor *JT_ColorStockGreen(void);
//股票灰色
UIColor *JT_ColorStockGray(void);

//股票灰色背景
UIColor *JT_ColorStockBgGray(void);

@end
