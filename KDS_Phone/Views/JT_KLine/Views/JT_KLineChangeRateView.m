//
//  JT_KLineZDFView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/13.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineChangeRateView.h"
#import <Masonry.h>
#import "JT_KLineConfig.h"
@interface JT_KLineChangeRateView ()
@property (nonatomic ,strong) NSMutableArray <UILabel *>*items;
@end
@implementation JT_KLineChangeRateView

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
- (void)setKLineChartViewHeight:(float)kLineChartViewHeight {
    _kLineChartViewHeight = kLineChartViewHeight;
    _items = @[].mutableCopy;
    float labelHeight = 11;
    float labelGap = (_kLineChartViewHeight - labelHeight) / 4;
    for (int i = 0; i < 5; i ++) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:JT_KLineY_AxisPriceFontSize];
        label.textColor = JT_KLineY_AxisPriceColor;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@(labelGap * i + self.kLineMAAccessoryViewHeight));
        }];
        [_items addObject:label];
    }
}
- (void)updateChangeRate:(float)maxValue min:(float)minValue {
    float item = (maxValue - minValue) / 4;
    [_items enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.text = [NSString stringWithFormat:@"%.2f%%",maxValue - item * idx];
    }];
}
@end
