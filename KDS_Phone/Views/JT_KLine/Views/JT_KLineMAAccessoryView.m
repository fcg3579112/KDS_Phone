//
//  JT_KLineMAView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineMAAccessoryView.h"
#import <Masonry.h>
#import "JT_KLineConfig.h"
#import "JT_KLineModel.h"
@interface JT_KLineMAAccessoryView ()
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *MA5_label;
@property (nonatomic ,strong) UILabel *MA10_label;
@property (nonatomic ,strong) UILabel *MA20_label;
@property (nonatomic ,strong) UILabel *MA30_label;
@property (nonatomic ,strong) UILabel *MA60_label;
@property (nonatomic ,assign) CGFloat offset;
@end
@implementation JT_KLineMAAccessoryView

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
        _offset = 8;
        self.backgroundColor = JT_KLineMABackgroundColor;
        self.clipsToBounds = YES;
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:JT_KLineMAFontSize];
        _titleLabel.textColor = JT_KLineMATitleColor;
        _titleLabel.text = @"日线 MA";
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(3);
            make.top.equalTo(self);
            make.height.equalTo(self);
        }];
    }
    return _titleLabel;
}
- (UILabel *)MA5_label {
    if (!_MA5_label) {
        _MA5_label = [UILabel new];
        _MA5_label.textColor = JT_KLineMA5Color;
        _MA5_label.font = self.titleLabel.font;
        [self addSubview:_MA5_label];
        [_MA5_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(self.offset);
            make.top.equalTo(self);
            make.height.equalTo(self);
        }];
    }
    return _MA5_label;
}
- (UILabel *)MA10_label {
    if (!_MA10_label) {
        _MA10_label = [UILabel new];
        _MA10_label.textColor = JT_KLineMA10Color;
        _MA10_label.font = self.titleLabel.font;
        [self addSubview:_MA10_label];
        [_MA10_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.MA5_label.mas_right).offset(self.offset);
            make.top.equalTo(self);
            make.height.equalTo(self);
        }];
    }
    return _MA10_label;
}
- (UILabel *)MA20_label {
    if (!_MA20_label) {
        _MA20_label = [UILabel new];
        _MA20_label.textColor = JT_KLineMA20Color;
        _MA20_label.font = self.titleLabel.font;
        [self addSubview:_MA20_label];
        [_MA20_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.MA10_label.mas_right).offset(self.offset);
            make.top.equalTo(self);
            make.height.equalTo(self);
        }];
    }
    return _MA20_label;
}
- (UILabel *)MA30_label {
    if (!_MA30_label) {
        _MA30_label = [UILabel new];
        _MA30_label.textColor = JT_KLineMA30Color;
        _MA30_label.font = self.titleLabel.font;
        [self addSubview:_MA30_label];
        [_MA30_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.MA20_label.mas_right).offset(self.offset);
            make.top.equalTo(self);
            make.height.equalTo(self);
        }];
    }
    return _MA30_label;
}
- (UILabel *)MA60_label {
    if (!_MA60_label) {
        _MA60_label = [UILabel new];
        _MA60_label.textColor = JT_KLineMA60Color;
        _MA60_label.font = self.titleLabel.font;
        [self addSubview:_MA60_label];
        [_MA60_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.MA30_label.mas_right).offset(self.offset);
            make.top.equalTo(self);
            make.height.equalTo(self);
        }];
    }
    return _MA60_label;
}
- (void)updateMAWith:(JT_KLineModel *)model {
    [self updateMA5:model.MA5 MA10:model.MA10 MA20:model.MA20 MA30:model.MA30 MA60:model.MA60];
}
- (void)updateMA5:(NSString *)MA5 MA10:(NSString *)MA10 MA20:(NSString *)MA20 MA30:(NSString *)MA30 MA60:(NSString *)MA60 {
    if ([JT_KLineConfig MA5]) {
        self.MA5_label.text = [NSString stringWithFormat:@"%lu:%@",(unsigned long)[JT_KLineConfig MA5],MA5];
    } else {
        self.MA5_label.text = @"";
    }
    if ([JT_KLineConfig MA10]) {
        self.MA10_label.text = [NSString stringWithFormat:@"%lu:%@",(unsigned long)[JT_KLineConfig MA10],MA10];
    } else {
        self.MA10_label.text = @"";
    }
    if ([JT_KLineConfig MA20]) {
        self.MA20_label.text = [NSString stringWithFormat:@"%lu:%@",(unsigned long)[JT_KLineConfig MA20],MA20];
    } else {
        self.MA20_label.text = @"";
    }
    if ([JT_KLineConfig MA30]) {
        self.MA30_label.text = [NSString stringWithFormat:@"%lu:%@",(unsigned long)[JT_KLineConfig MA30],MA30];
    } else {
        self.MA30_label.text = @"";
    }
    if ([JT_KLineConfig MA60]) {
        self.MA60_label.text = [NSString stringWithFormat:@"%lu:%@",(unsigned long)[JT_KLineConfig MA60],MA60];
    } else {
        self.MA60_label.text = @"";
    }
}

@end
