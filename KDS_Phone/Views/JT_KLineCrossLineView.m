//
//  JT_KLineCrossLineView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/12.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineCrossLineView.h"
#import "JT_KLineModel.h"
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
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context,1);
    //竖线坐标
    CGPoint verticalPoints[] = {CGPointMake(_crossLineCenterPoint.x, 0), CGPointMake(_crossLineCenterPoint.x, rect.size.height)};
    CGContextStrokeLineSegments(context, verticalPoints, 2);
    //横线坐标
    CGPoint horizontalPoints[] = {CGPointMake(0, _crossLineCenterPoint.y), CGPointMake(rect.size.width, _crossLineCenterPoint.y)};
    CGContextStrokeLineSegments(context, horizontalPoints, 2);
}
@end
