//
//  JT_KLineCrossLineView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/12.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineCrossLineView.h"
#import "JT_KLineModel.h"
#import "JT_KLineConfig.h"
@interface JT_KLineCrossLineView ()
@property (nonatomic ,assign) CGPoint crossLineCenterPoint;
@property (nonatomic ,strong) JT_KLineModel *kLineModel;
@property (nonatomic ,strong) NSString *dateTime;
@property (nonatomic ,strong) NSString *valueY;
@end
@implementation JT_KLineCrossLineView

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
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)updateCrossLine:(CGPoint)point valueY:(NSString *)value kLineModel:(JT_KLineModel *)kLineModel {
    _valueY = value;
    _crossLineCenterPoint = point;
    _kLineModel = kLineModel;
    _dateTime = formateDateFromString(kLineModel.datetime);
    [self setNeedsDisplay];
}

/**
 NSString *const NSFontAttributeName;(字体)
 
 NSString *const NSParagraphStyleAttributeName;(段落)
 
 NSString *const NSForegroundColorAttributeName;(字体颜色)
 
 NSString *const NSBackgroundColorAttributeName;(字体背景色)
 
 NSString *const NSLigatureAttributeName;(连字符)
 
 NSString *const NSKernAttributeName;(字间距)
 
 NSString *const NSStrikethroughStyleAttributeName;(删除线)
 
 NSString *const NSUnderlineStyleAttributeName;(下划线)
 
 NSString *const NSStrokeColorAttributeName;(边线颜色)
 
 NSString *const NSStrokeWidthAttributeName;(边线宽度)
 
 NSString *const NSShadowAttributeName;(阴影)(横竖排版)
 
 NSString *const NSVerticalGlyphFormAttributeName;
 
 */
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, JT_KLineCrossLineColor.CGColor);
    CGContextSetLineWidth(context,JT_KLineCrossLineWidth);
    UIFont *font = [UIFont systemFontOfSize:JT_KLineCrossLineTextFontSize];
    
    
    float kLineChartMaxY = self.timeViewTopMargin - self.kLineChartSafeAreaHeight;
    float kLineChartMinY = self.kLineChartSafeAreaHeight;
    float volumeMaxY = rect.size.height;
    float volumeMinY = self.timeViewTopMargin + self.timeViewHeight + self.indexAccessoryViewHeight;
    
    //只有坐标在 蜡烛线与 成交量区间中才需要画横线
    float centerY = _crossLineCenterPoint.y;
    if ( (centerY >= kLineChartMinY && centerY <= kLineChartMaxY)
       || (centerY >= volumeMinY && centerY <= volumeMaxY)) {
        CGSize valueYSize = [_valueY sizeWithAttributes:@{NSFontAttributeName : font}];
        CGRect valueYRect;
        CGPoint horizontalPoints[] = {CGPointMake(valueYSize.width, _crossLineCenterPoint.y), CGPointMake(rect.size.width, _crossLineCenterPoint.y)};
        CGContextStrokeLineSegments(context, horizontalPoints, 2);
        
        //画 Y 轴值
        CGFloat originY = _crossLineCenterPoint.y - valueYSize.height / 2;
        if (centerY >= kLineChartMinY && centerY <= kLineChartMaxY) { // 画上蜡烛线区间Y值
            if (originY < kLineChartMinY) {
                originY = kLineChartMinY;
            }
            if (originY >  kLineChartMaxY - valueYSize.height) {
                originY = kLineChartMaxY - valueYSize.height;
            }
        } else { //画成交量区间Y值
            if (originY < volumeMinY) {
                originY = volumeMinY;
            }
            if (originY >  volumeMaxY - valueYSize.height) {
                originY = volumeMaxY - valueYSize.height;
            }
        }
        valueYRect = CGRectMake(0, originY, valueYSize.width, valueYSize.height);
        [_valueY drawInRect:valueYRect withAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : JT_KLineCrossLineTextColor,NSBackgroundColorAttributeName : JT_KLineCrossLineTextBackgroundColor}];
        //画画 Y 轴值边框
        CGContextSetLineWidth(context,JT_KLineCrossLineWidth * 2);
        CGContextSetStrokeColorWithColor(context, JT_KLineCrossLineTextBordeColor.CGColor);
        CGContextAddRect(context, valueYRect);
        CGContextStrokePath(context);
    }
    
    //竖线上部分
    CGContextSetLineWidth(context,JT_KLineCrossLineWidth);
    CGPoint verticalLineUpPoints[] = {CGPointMake(_crossLineCenterPoint.x, 0), CGPointMake(_crossLineCenterPoint.x, self.timeViewTopMargin)};
    CGContextStrokeLineSegments(context, verticalLineUpPoints, 2);
    //竖线下部分
    CGPoint verticalLineDownPoints[] = {CGPointMake(_crossLineCenterPoint.x, self.timeViewTopMargin + self.timeViewHeight), CGPointMake(_crossLineCenterPoint.x,rect.size.height )};
    CGContextStrokeLineSegments(context, verticalLineDownPoints, 2);
    
    
    CGSize textSize = [_dateTime sizeWithAttributes:@{NSFontAttributeName : font}];
    textSize = CGSizeMake(textSize.width, textSize.height);
    CGFloat originX = _crossLineCenterPoint.x - textSize.width / 2;
    
    originX = originX < 0 ? 0 : originX;
    originX = originX >= rect.size.width - textSize.width ?  originX = rect.size.width - textSize.width : originX;
    
    CGRect textRect = CGRectMake(originX, self.timeViewTopMargin, textSize.width, textSize.height);
    //画时间
    [_dateTime drawInRect:textRect withAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : JT_KLineCrossLineTextColor,NSBackgroundColorAttributeName : JT_KLineCrossLineTextBackgroundColor}];
    //画时间边框
    CGContextSetLineWidth(context,JT_KLineCrossLineWidth * 2);
    CGContextSetStrokeColorWithColor(context, JT_KLineCrossLineTextBordeColor.CGColor);
    CGContextAddRect(context, textRect);
    CGContextStrokePath(context);
}
@end
