//
//  JT_TimelineAccessoryView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/18.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_TimelineAccessoryView.h"
#import "UIFont+KDS_FontHandle.h"
#import "JT_ColorManager.h"
#import <MApi.h>
#import <Masonry.h>
@interface JT_TimelineAccessoryView ()
@property (nonatomic ,strong) UILabel *lastPrice;//现价
@property (nonatomic ,strong) UILabel *datetime;//时间
@property (nonatomic ,strong) UILabel *changeRate;//涨幅
@property (nonatomic ,strong) UILabel *tradeVolume;//成交量
@property (nonatomic ,strong) UILabel *averagePrice;//均价
@property (nonatomic ,strong) MStockItem *stockModel;
@property (nonatomic ,assign)JT_DeviceOrientation orientation;
@property (nonatomic ,strong) NSMutableArray <UILabel *>*items;
@end
@implementation JT_TimelineAccessoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithType:(JT_DeviceOrientation)orientation {
    self = [super init];
    if (self) {
        _items = @[].mutableCopy;
        _orientation = orientation;
        [self newSubviews];
    }
    return self;
}
- (void)newSubviews {
    
    UIColor *blackColor = JT_ColorDayOrNight(@"3E4554", @"FFFFFF");
    UIColor *darkColor = JT_ColorDayOrNight(@"5E6678", @"B1B6C0");
    UIFont *boldFont13 = [UIFont kds_fontWithName:@"FontName_Four" size:13];
    UIFont *font13 = [UIFont kds_fontWithName:@"FontName_Two" size:13];
    NSArray *titles;
    if (_orientation == JT_DeviceOrientationVertical) {
        titles = @[@"时间",@"价",@"幅",@"量",@"均",];
    } else {
        titles = @[@"时间",@"价格",@"涨幅",@"成交量",@"均价",];
    }
    for (int i = 0; i < 10; i ++) {
        UILabel *label = [UILabel new];
        [self addSubview:label];
        [_items addObject:label];
        if (i % 2 == 0) {
            label.font = font13;
            label.textColor = darkColor;
            label.text = titles[i / 2];
        } else {
            label.font = boldFont13;
            label.textColor = blackColor;
            
            switch (i / 2) {
                case 1:
                    _datetime = label;
                    break;
                case 2:
                    _lastPrice = label;
                    break;
                case 3:
                    _changeRate = label;
                    break;
                case 4:
                    _tradeVolume = label;
                    break;
                case 5:
                    _averagePrice = label;
                    break;
                    
                default:
                    break;
            }
        }
    }
}
//更新布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    __block UILabel *preLabel;
    CGFloat offset;
    CGFloat originX;
    if (self.orientation == JT_DeviceOrientationVertical) { //竖屏布局
        offset = 2;
        originX = 10;
    } else { // 横屏布局
        offset = 4;
        originX = 25;
    }
    [_items enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {

        if (idx % 2 == 0) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.mas_equalTo(self.frame.size.width / 6.5 * idx + originX);
            }];
            preLabel = label;
        } else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(preLabel.mas_right).offset(offset);
            }];
        }
    }];
}
- (void)updateWithModel:(MStockItem *)model {
    _stockModel = model;
}
- (UIColor *)getColorWithPrice:(NSString *)price {
    
    if (price.floatValue > _stockModel.preClosePrice.floatValue) {
        return JT_ColorDayOrNight(@"FF3D00", @"FF3D00");
    } else if (price.floatValue < _stockModel.preClosePrice.floatValue) {
        return JT_ColorDayOrNight(@"333333", @"666666");
    } else {
        return JT_ColorDayOrNight(@"858C9E", @"858C9E");
    }
}
@end
