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

- (void)updateCrossLine:(CGPoint)point kLineModel:(JT_KLineModel *)kLineModel {
    _crossLineCenterPoint = point;
    _kLineModel = kLineModel;
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
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context,1);
    //横线坐标
    CGPoint horizontalPoints[] = {CGPointMake(0, _crossLineCenterPoint.y), CGPointMake(rect.size.width, _crossLineCenterPoint.y)};
    CGContextStrokeLineSegments(context, horizontalPoints, 2);
    //竖线上部分
    CGPoint verticalLineUpPoints[] = {CGPointMake(_crossLineCenterPoint.x, 0), CGPointMake(_crossLineCenterPoint.x, self.timeViewTopMargin)};
    CGContextStrokeLineSegments(context, verticalLineUpPoints, 2);
    //竖线下部分
    CGPoint verticalLineDownPoints[] = {CGPointMake(_crossLineCenterPoint.x, self.timeViewTopMargin + self.timeViewHeight), CGPointMake(_crossLineCenterPoint.x,rect.size.height )};
    CGContextStrokeLineSegments(context, verticalLineDownPoints, 2);
    
    NSString *time = [_kLineModel.datetime substringToIndex:8];
    UIFont *font = [UIFont systemFontOfSize:JT_KLineMAFontSize - 1];
    CGFloat textWidth = [time sizeWithAttributes:@{NSFontAttributeName : font}].width;
    CGFloat originX = _crossLineCenterPoint.x - textWidth / 2;
    if (originX < 0) {
        originX = 0;
    }
    if (originX > rect.size.width - textWidth) {
        originX = rect.size.width - textWidth;
    }
    [time drawAtPoint:CGPointMake(originX, self.timeViewTopMargin) withAttributes:@{NSFontAttributeName : font,NSBackgroundColorAttributeName : [UIColor  orangeColor] ,NSStrokeWidthAttributeName : @(2) ,NSStrokeColorAttributeName : [UIColor blackColor] }];
    
    //画时间
}
@end
