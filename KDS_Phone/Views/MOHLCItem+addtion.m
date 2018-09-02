//
//  MOHLCItem+addtion.m
//  KDS_Phone
//
//  Created by feng on 2018/9/2.
//  Copyright © 2018年 com.csc. All rights reserved.
//
#import "MOHLCItem+addtion.h"
#import  <objc/runtime.h>
@implementation MOHLCItem (addtion)
static const char JT_needShowTimeKeyValuesKey = '\0';
- (BOOL)needShowTime {
   id boolValue = objc_getAssociatedObject(self, &JT_needShowTimeKeyValuesKey);
    if (boolValue) {
        return ((NSNumber *)boolValue).boolValue;
    }
    return NO;
}
- (void)setNeedShowTime:(BOOL)needShowTime {
    objc_setAssociatedObject(self, &JT_needShowTimeKeyValuesKey, @(needShowTime), OBJC_ASSOCIATION_RETAIN);
}
@end
