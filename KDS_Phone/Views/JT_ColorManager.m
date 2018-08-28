//
//  JT_ColorManager.m
//  ZhongXinJianTou_Phone
//
//  Created by chuangao.feng on 2018/8/23.
//  Copyright © 2018年 kds. All rights reserved.
//

#import "JT_ColorManager.h"

@implementation JT_ColorManager

UIColor *JT_ColorDayOrNight( NSString*dayHexString, NSString*nightHexString){
    if (!nightHexString.length) {
        return colorWithHex(dayHexString);
    }
    return isDayTheme() ? colorWithHex(dayHexString) : colorWithHex(nightHexString);
}
BOOL isDayTheme(){
    if (3) {
        return YES;
    }
    return NO;
}
// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
UIColor *colorWithHex(NSString *color)
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6) {
        NSLog(@"❌❌❌❌❌❌：颜色设置错误");
        return [UIColor clearColor];
    }
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


UIColor *JT_ColorStockRed(){
    return JT_ColorDayOrNight(@"FF3D00", @"FF3D00");
}
UIColor *JT_ColorStockGreen(){
    return JT_ColorDayOrNight(@"0DB14B", @"0DB14B");
}
UIColor *JT_ColorStockGray(){
    return JT_ColorDayOrNight(@"333333", @"626262");
}
UIColor *JT_ColorStockBgGray(){
    return JT_ColorDayOrNight(@"626262", @"626262");
}
@end
