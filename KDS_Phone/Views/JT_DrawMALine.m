//
//  JT_DrawMALine.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/4.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_DrawMALine.h"
#import "JT_KLineConfig.h"
#import "KDS_UtilsMacro.h"
@interface JT_DrawMALine ()
@property (nonatomic, assign) CGContextRef context;
@end
@implementation JT_DrawMALine
- (instancetype)initWithContext:(CGContextRef)context
{
    self = [super init];
    if (self) {
        _context = context;
    }
    return self;
}

- (void)drawLineWith:(UIColor *)color positions:(NSArray <NSValue*>*)postions {
    CGContextRef context = self.context;
    CGContextSetLineWidth(_context, JT_KLineMALineWith);
    CGContextSetStrokeColorWithColor(_context, color.CGColor);
    [postions enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            CGContextMoveToPoint(context, obj.CGPointValue.x, obj.CGPointValue.y);
        } else {
            CGContextAddLineToPoint(context, obj.CGPointValue.x, obj.CGPointValue.y);
        }
    }];
    CGContextStrokePath(context);
}
@end
