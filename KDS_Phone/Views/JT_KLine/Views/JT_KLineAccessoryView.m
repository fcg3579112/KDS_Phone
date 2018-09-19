//
//  JT_KLineAccessoryView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/18.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#define KLineAccessory_BlackColor                JT_ColorDayOrNight(@"3E4554", @"FFFFFF")
#define KLineAccessory_LightBlackColor           JT_ColorDayOrNight(@"5E6678", @"B1B6C0")
#define KLineAccessory_GrayColor                 JT_ColorDayOrNight(@"858C9E", @"858C9E")
#define KLineAccessory_RedColor                  JT_ColorDayOrNight(@"FF3D00", @"FF3D00")
#define KLineAccessory_GreenColor                JT_ColorDayOrNight(@"0DB14B", @"0DB14B")

#import "JT_ColorManager.h"
#import "JT_KLineAccessoryView.h"
#import "UIFont+KDS_FontHandle.h"
#import <Masonry.h>
#import "JT_KLineModel.h"
#import "JT_KLineConfig.h"
#import "KDS_UtilsMacro.h"
@interface JT_KLineAccessoryView ()
@property (nonatomic ,strong) UILabel *dateTime;
@property (nonatomic ,strong) UILabel *highPrice;
@property (nonatomic ,strong) UILabel *lowPrice;
@property (nonatomic ,strong) UILabel *openPrice;
@property (nonatomic ,strong) UILabel *closePrice;
@property (nonatomic ,strong) UILabel *volume; //成交量
@property (nonatomic ,strong) UILabel *changeRate; //涨跌幅
@property (nonatomic ,strong) JT_KLineModel *kLineModel;
@property (nonatomic ,strong) NSMutableArray <UILabel *>*items;
@end
@implementation JT_KLineAccessoryView

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
        _items = @[].mutableCopy;
        self.backgroundColor = JT_ColorDayOrNight(@"F2F4F8", @"1B1C20");
        [self newSubviews];
    }
    return self;
}
- (void)newSubviews {
    
    UIFont *boldFont13 = [UIFont kds_fontWithName:@"FontName_Four" size:13];
    UIFont *font13 = [UIFont kds_fontWithName:@"FontName_Two" size:13];
    
    _dateTime = [UILabel new];
    _dateTime.textColor = KLineAccessory_BlackColor;
    _dateTime.font = boldFont13;
    [self addSubview:_dateTime];
    NSArray *titles = @[@"高",@"开",@"低",@"收",@"成交量",@"涨幅",];
    for (int i = 0; i < 12; i ++) {
        UILabel *label = [UILabel new];
        [self addSubview:label];
        [_items addObject:label];
        
        if (i % 2 == 0) {
            label.font = font13;
            label.textColor = KLineAccessory_LightBlackColor;
            label.text = titles[i / 2];
        } else {
            label.font = boldFont13;
            label.textColor = KLineAccessory_BlackColor;
        }
        
        switch (i) {
            case 1:
                _highPrice = label;
                break;
            case 3:
                _openPrice = label;
                break;
            case 5:
                _lowPrice = label;
                break;
            case 7:
                _closePrice = label;
                break;
            case 9:
                _volume = label;
                break;
            case 11:
                _changeRate = label;
                break;
                
            default:
                break;
        }
    }
    
    [_dateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self);
    }];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    //更新布局
    __block UILabel *preLabel;
    [_items enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx % 2 == 0) {
            [label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                if (idx / 2 == 5) {
                    make.left.mas_equalTo( self.frame.size.width / 8 * (idx / 2 ) + 100);
                } else {
                    make.left.mas_equalTo( self.frame.size.width / 8 * (idx / 2 ) + 80);
                }
            }];
            preLabel = label;
        } else {
            
            [label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(preLabel.mas_right).offset(2);
            }];
        }
    }];

}
- (void)updateWithModel:(JT_KLineModel *)model {
    _kLineModel = model;
    if (model.datetime.length >= 8) {
        _dateTime.text = [model.datetime substringToIndex:8];
    }
    _highPrice.text = model.highPrice;
    _openPrice.text = model.openPrice;
    _lowPrice.text = model.lowPrice;
    _closePrice.text = model.closePrice;
    _volume.text = formatVolume(model.tradeVolume);
    _changeRate.text = [NSString stringWithFormat:@"%.2f%%",model.changeRate * 100];
    _changeRate.textColor = model.priceColor;
    _highPrice.textColor = [self getColorWithPrice:model.highPrice];
    _openPrice.textColor = [self getColorWithPrice:model.openPrice];
    _lowPrice.textColor = [self getColorWithPrice:model.lowPrice];
    _closePrice.textColor = [self getColorWithPrice:model.closePrice];
    
}

- (UIColor *)getColorWithPrice:(NSString *)price {
    if (price.floatValue > _kLineModel.referencePrice.floatValue) {
        return JT_ColorDayOrNight(@"FF3D00", @"FF3D00");
    } else if (price.floatValue < _kLineModel.referencePrice.floatValue) {
        return JT_ColorDayOrNight(@"333333", @"666666");
    } else {
        return JT_ColorDayOrNight(@"858C9E", @"858C9E");
    }
}
@end
