//
//  JT_DrawMALine.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/4.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_DrawMALine.h"
#import "JT_KLineConfig.h"
#import "JT_KLinePositionModel.h"
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
- (void)drawMA5 {
    if ([JT_KLineConfig MA5]) {
        CGContextSetLineWidth(_context, JT_KLineMALineWith);
        CGContextSetStrokeColorWithColor(_context, JT_KLineMA5Color.CGColor);
        @weakify(self)
        [self.kLinePositionModels enumerateObjectsUsingBlock:^(JT_KLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            if (idx == 0) {
                CGContextMoveToPoint(self.context, obj.MA5.x, obj.MA5.y);
            } else {
                CGContextAddLineToPoint(self.context, obj.MA5.x, obj.MA5.y);
            }
        }];
        CGContextStrokePath(self.context);
    }
}
- (void)drawMA10 {
    if ([JT_KLineConfig MA10]) {
        CGContextSetLineWidth(_context, JT_KLineMALineWith);
        CGContextSetStrokeColorWithColor(_context, JT_KLineMA10Color.CGColor);
        @weakify(self)
        [self.kLinePositionModels enumerateObjectsUsingBlock:^(JT_KLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            if (idx == 0) {
                CGContextMoveToPoint(self.context, obj.MA10.x, obj.MA10.y);
            } else {
                CGContextAddLineToPoint(self.context, obj.MA10.x, obj.MA10.y);
            }
        }];
        CGContextStrokePath(self.context);
    }
}
- (void)drawMA20 {
    if ([JT_KLineConfig MA20]) {
        CGContextSetLineWidth(_context, JT_KLineMALineWith);
        CGContextSetStrokeColorWithColor(_context, JT_KLineMA20Color.CGColor);
        @weakify(self)
        [self.kLinePositionModels enumerateObjectsUsingBlock:^(JT_KLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            if (idx == 0) {
                CGContextMoveToPoint(self.context, obj.MA20.x, obj.MA20.y);
            } else {
                CGContextAddLineToPoint(self.context, obj.MA20.x, obj.MA20.y);
            }
        }];
        CGContextStrokePath(self.context);
    }
}
- (void)drawMA30 {
    if ([JT_KLineConfig MA30]) {
        CGContextSetLineWidth(_context, JT_KLineMALineWith);
        CGContextSetStrokeColorWithColor(_context, JT_KLineMA30Color.CGColor);
        @weakify(self)
        [self.kLinePositionModels enumerateObjectsUsingBlock:^(JT_KLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            if (idx == 0) {
                CGContextMoveToPoint(self.context, obj.MA30.x, obj.MA30.y);
            } else {
                CGContextAddLineToPoint(self.context, obj.MA30.x, obj.MA30.y);
            }
        }];
        CGContextStrokePath(self.context);
    }
}
- (void)drawMA60 {
    if ([JT_KLineConfig MA60]) {
        CGContextSetLineWidth(_context, JT_KLineMALineWith);
        CGContextSetStrokeColorWithColor(_context, JT_KLineMA60Color.CGColor);
        @weakify(self)
        [self.kLinePositionModels enumerateObjectsUsingBlock:^(JT_KLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            if (idx == 0) {
                CGContextMoveToPoint(self.context, obj.MA60.x, obj.MA60.y);
            } else {
                CGContextAddLineToPoint(self.context, obj.MA60.x, obj.MA60.y);
            }
        }];
        CGContextStrokePath(self.context);
    }
}

- (void)drawVolumeMA5 {
    CGContextSetLineWidth(_context, JT_KLineMALineWith);
    CGContextSetStrokeColorWithColor(_context, JT_KLineMA5Color.CGColor);
    @weakify(self)
    [self.kLinePositionModels enumerateObjectsUsingBlock:^(JT_KLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        if (idx == 0) {
            CGContextMoveToPoint(self.context, obj.volumeMA5.x, obj.volumeMA5.y);
        } else {
            CGContextAddLineToPoint(self.context, obj.volumeMA5.x, obj.volumeMA5.y);
        }
    }];
    CGContextStrokePath(self.context);
}
- (void)drawVolumeMA10 {
    CGContextSetLineWidth(_context, JT_KLineMALineWith);
    CGContextSetStrokeColorWithColor(_context, JT_KLineMA10Color.CGColor);
    @weakify(self)
    [self.kLinePositionModels enumerateObjectsUsingBlock:^(JT_KLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        if (idx == 0) {
            CGContextMoveToPoint(self.context, obj.volumeMA10.x, obj.volumeMA10.y);
        } else {
            CGContextAddLineToPoint(self.context, obj.volumeMA10.x, obj.volumeMA10.y);
        }
    }];
    CGContextStrokePath(self.context);
}
@end
