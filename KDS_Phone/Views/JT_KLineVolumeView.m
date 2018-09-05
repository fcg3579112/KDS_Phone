//
//  JT_KLineVolumeView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineVolumeView.h"
#import "JT_KLineConfig.h"
#import "JT_KLinePositionModel.h"
#import "JT_DrawCandleLine.h"
#import "JT_DrawMALine.h"
@implementation JT_KLineVolumeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}
- (void)drawView {
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置View的背景颜色
    
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, JT_KLineViewBackgroundColor.CGColor);
    CGContextFillRect(context, rect);
    //画背景方格线
    CGContextSetStrokeColorWithColor(context, JT_KLineViewGridLineColor.CGColor);
    CGContextSetLineWidth(context, JT_KLineViewGridLineWidth * 2);
    // 画边框
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
    //画中间的1条横线
    CGFloat gap = rect.size.height / 2.f;
    CGContextSetLineWidth(context, JT_KLineViewGridLineWidth);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + gap);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + gap);
    CGContextStrokePath(context);
    
    //画成交量
    if ([JT_KLineConfig kLineIndicatorType] == JT_Volume) {
        //画蜡烛线
        JT_DrawCandleLine *kLine = [[JT_DrawCandleLine alloc]initWithContext:context];
        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(JT_KLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            kLine.kLinePositionModel = obj;
            kLine.maxY = rect.size.height;
            [kLine drawVolume];
        }];
        
        //画成交量均线
        [self drawAllVolumeMAline:context];
    }
}

////画成交量均线 5日、10日等
- (void)drawAllVolumeMAline:(CGContextRef)context {
    JT_DrawMALine *drawMALineUtil = [[JT_DrawMALine alloc] initWithContext:context];
    drawMALineUtil.kLinePositionModels = self.needDrawKLinePositionModels;
    [drawMALineUtil drawVolumeMA5];
    [drawMALineUtil drawVolumeMA10];
}

@end
