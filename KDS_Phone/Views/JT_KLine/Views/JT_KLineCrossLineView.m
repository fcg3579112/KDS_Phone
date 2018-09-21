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
#import <Masonry.h>
@interface JT_KLineCrossLineView ()
@property (nonatomic ,assign) CGPoint crossLineCenterPoint;
@property (nonatomic ,strong) JT_KLineModel *kLineModel;
@property (nonatomic ,strong) NSString *dateTime;
@property (nonatomic ,strong) NSString *valueY;
@property (nonatomic ,strong) NSString *changeRate;
@property (nonatomic ,assign) float costLineY;


@property (nonatomic ,strong) UIView *horizontalLine;
@property (nonatomic ,strong) UIView *verticalLineUp;
@property (nonatomic ,strong) UIView *verticalLineDown;

@property (nonatomic ,strong) UILabel *costLineLabel;//成本线标记
@property (nonatomic ,strong) UILabel *datetimeLabel;//时间
@property (nonatomic ,strong) UILabel *priceLabel;//时间
@property (nonatomic ,strong) UILabel *changeRateLabel;//时间
@property (nonatomic ,strong) UIFont *font;
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
        self.font = [UIFont systemFontOfSize:JT_KLineCrossLineTextFontSize];
    }
    return self;
}
- (void)updateCrossLine:(CGPoint)point valueY:(NSString *)value costLineY:(float)costLineY changeRate:(NSString *)changeRate kLineModel:(JT_KLineModel *)kLineModel {
    _valueY = value;
    _changeRate = changeRate;
    _crossLineCenterPoint = point;
    _kLineModel = kLineModel;
    _costLineY = costLineY;
    _dateTime = formateDateFromString(kLineModel.datetime);
    
    [self updateSubviews];
}

- (void)updateSubviews {
    
    if (_costLineY == 0) {
        self.costLineLabel.hidden = YES;
    } else {
        NSString *text = [NSString stringWithFormat:@"成本\n%@",self.costLinePrice];
        self.costLineLabel.text = text;
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName : self.font}];
        self.costLineLabel.hidden = NO;
        [self.costLineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.costLineY - textSize.height / 2);
        }];
    }
    
    self.datetimeLabel.text = self.dateTime;
    self.changeRateLabel.text = self.changeRate;
    self.priceLabel.text = self.valueY;
    
    
    float kLineChartMaxY = self.timeViewTopMargin - self.kLineChartSafeAreaHeight;
    float kLineChartMinY = self.kLineChartSafeAreaHeight;
    float volumeMaxY = self.frame.size.height;
    float volumeMinY = self.timeViewTopMargin + self.timeViewHeight + self.indexAccessoryViewHeight;
    
    [self.verticalLineUp mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.crossLineCenterPoint.x);
    }];
    [self.verticalLineDown mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.crossLineCenterPoint.x);
    }];

    CGSize datetimeSize = [self.dateTime sizeWithAttributes:@{NSFontAttributeName : self.font}];
    CGFloat originX = _crossLineCenterPoint.x - datetimeSize.width / 2;
    originX = originX < 0 ? 0 : originX;
    originX = originX + datetimeSize.width > self.frame.size.width - self.rightMargin ? self.frame.size.width - datetimeSize.width - self.rightMargin : originX;
    [self.datetimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(originX);
    }];

    float centerY = _crossLineCenterPoint.y;
    CGSize valueYSize = [self.valueY sizeWithAttributes:@{NSFontAttributeName : self.font}];
    CGFloat originY = _crossLineCenterPoint.y - valueYSize.height / 2.f;
    
    if (centerY >= kLineChartMinY && centerY <= kLineChartMaxY) {// k线蜡烛线区间
        self.priceLabel.hidden = NO;
        self.changeRateLabel.hidden = NO;
        self.horizontalLine.hidden = NO;
        if (originY < kLineChartMinY) {
            originY = kLineChartMinY;
        } else if (originY >  kLineChartMaxY - valueYSize.height) {
            originY = kLineChartMaxY - valueYSize.height;
        }
    } else if (centerY >= volumeMinY && centerY <= volumeMaxY) {// 成交量区间
        self.priceLabel.hidden = NO;
        self.changeRateLabel.hidden = YES;
        self.horizontalLine.hidden = NO;
        if (originY < volumeMinY) {
            originY = volumeMinY;
        } else if (originY >  volumeMaxY - valueYSize.height) {
            originY = volumeMaxY - valueYSize.height;
        }
    } else {
        self.priceLabel.hidden = YES;
        self.changeRateLabel.hidden = YES;
        self.horizontalLine.hidden = YES;
    }
    
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(originY);
    }];
    
    [self.changeRateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(originY);
    }];
    
    [self.horizontalLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.crossLineCenterPoint.y);
    }];
}

#pragma mark Getter
//竖线上部分

- (UIView *)horizontalLine {
    if (!_horizontalLine) {
        _horizontalLine = [UIView new];
        [self addSubview:_horizontalLine];
        _horizontalLine.backgroundColor = JT_KLineCrossLineColor;
        [_horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(- self.rightMargin);
            make.height.mas_equalTo(JT_KLineCrossLineWidth);
            make.top.mas_equalTo(self.crossLineCenterPoint.y);
            make.left.equalTo(self.priceLabel.mas_right);
        }];
    }
    return _horizontalLine;
}

- (UIView *)verticalLineUp {
    if (!_verticalLineUp) {
        _verticalLineUp = [UIView new];
        [self addSubview:_verticalLineUp];
        _verticalLineUp.backgroundColor = JT_KLineCrossLineColor;
        [_verticalLineUp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(JT_KLineCrossLineWidth);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(self.timeViewTopMargin);
        }];
    }
    return _verticalLineUp;
}

- (UIView *)verticalLineDown {
    if (!_verticalLineDown) {
        _verticalLineDown = [UIView new];
        [self addSubview:_verticalLineDown];
        _verticalLineDown.backgroundColor = JT_KLineCrossLineColor;
        [_verticalLineDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(JT_KLineCrossLineWidth);
            make.top.mas_equalTo(self.timeViewTopMargin + self.timeViewHeight);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _verticalLineDown;
}

- (UILabel *)datetimeLabel {
    if (!_datetimeLabel) {
        _datetimeLabel = [UILabel new];
        _datetimeLabel.font = self.font;
        _datetimeLabel.textColor = JT_KLineCrossLineTextColor;
        _datetimeLabel.backgroundColor = JT_KLineCrossLineTextBackgroundColor;
        _datetimeLabel.layer.borderColor = JT_KLineCrossLineTextBordeColor.CGColor;
        _datetimeLabel.layer.borderWidth = 1;
        _datetimeLabel.numberOfLines = 1;
        [self addSubview:_datetimeLabel];
        [_datetimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.verticalLineUp.mas_bottom);
            make.bottom.equalTo(self.verticalLineDown.mas_top);
            make.left.equalTo(@0);
        }];
    }
    return _datetimeLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = self.font;
        _priceLabel.textColor = JT_KLineCrossLineTextColor;
        _priceLabel.backgroundColor = JT_KLineCrossLineTextBackgroundColor;
        _priceLabel.layer.borderColor = JT_KLineCrossLineTextBordeColor.CGColor;
        _priceLabel.layer.borderWidth = 1;
        _priceLabel.numberOfLines = 1;
        [self addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
        }];
    }
    return _priceLabel;
}

- (UILabel *)changeRateLabel {
    if (!_changeRateLabel) {
        _changeRateLabel = [UILabel new];
        _changeRateLabel.font = self.font;
        _changeRateLabel.textColor = JT_KLineCrossLineTextColor;
        _changeRateLabel.backgroundColor = JT_KLineCrossLineTextBackgroundColor;
        _changeRateLabel.layer.borderColor = JT_KLineCrossLineTextBordeColor.CGColor;
        _changeRateLabel.layer.borderWidth = 1;
        _changeRateLabel.numberOfLines = 1;
        [self addSubview:_changeRateLabel];
        [_changeRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_right).offset( -self.rightMargin);
            make.top.equalTo(@0);
        }];
    }
    return _changeRateLabel;
}

- (UILabel *)costLineLabel {
    if (!_costLineLabel) {
        _costLineLabel = [UILabel new];
        _costLineLabel.numberOfLines = 2;
        _costLineLabel.textColor = [UIColor whiteColor];
        _costLineLabel.font = self.font;
        _costLineLabel.backgroundColor = JT_ColorDayOrNight(@"FF6E33", @"8D4429");
        [self addSubview:_costLineLabel];
        _costLineLabel.textAlignment = NSTextAlignmentCenter;
        [_costLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
        }];
        _costLineLabel.hidden = YES;
    }
    return _costLineLabel;
}
@end
