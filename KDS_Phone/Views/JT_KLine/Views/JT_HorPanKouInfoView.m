//
//  JT_HorPanKouInfoView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/18.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_HorPanKouInfoView.h"
#import "JT_ColorManager.h"
#import <Masonry.h>
#import <MApi.h>
#import "MStockItem+Addition.h"
#import "UIFont+KDS_FontHandle.h"
@interface JT_HorPanKouInfoView ()
@property (nonatomic ,strong) UILabel *name;            //名称
@property (nonatomic ,strong) UILabel *code;            //code
@property (nonatomic ,strong) UILabel *stockStage;      //状态
@property (nonatomic ,strong) UILabel *dateTime;        //时间
@property (nonatomic ,strong) UILabel *lastPrice;           //现价
@property (nonatomic ,strong) UILabel *change;          //涨跌
@property (nonatomic ,strong) UILabel *changeRate;      //涨跌幅

@property (nonatomic ,strong) UILabel *title;  //今开
@property (nonatomic ,strong) UILabel *title1; //昨收
@property (nonatomic ,strong) UILabel *title2; //成交额
@property (nonatomic ,strong) UILabel *title3; //换手率

@property (nonatomic ,strong) UILabel *openPrice; //今开
@property (nonatomic ,strong) UILabel *preClosePrice; //昨收
@property (nonatomic ,strong) UILabel *amount;  //成交额
@property (nonatomic ,strong) UILabel *turnoverRate; //换手率
@end

#define PanKou_BlackColor                JT_ColorDayOrNight(@"3E4554", @"FFFFFF")
#define PanKou_LightBlackColor           JT_ColorDayOrNight(@"5E6678", @"B1B6C0")
#define PanKou_GrayColor                 JT_ColorDayOrNight(@"858C9E", @"858C9E")
#define PanKou_RedColor                  JT_ColorDayOrNight(@"FF3D00", @"FF3D00")
#define PanKou_GreenColor                JT_ColorDayOrNight(@"0DB14B", @"0DB14B")

@implementation JT_HorPanKouInfoView

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
        self.backgroundColor = JT_ColorDayOrNight(@"FFFFFF", @"101419");
        [self newSubviews];
    }
    return self;
}

- (void)newSubviews {
    
    UIFont *boldFont15 = [UIFont kds_fontWithName:@"FontName_Four" size:15];
    UIFont *boldFont12 = [UIFont kds_fontWithName:@"FontName_Four" size:12];
    UIFont *font11 = [UIFont kds_fontWithName:@"FontName_Two" size:11];
    UIFont *font13 = [UIFont kds_fontWithName:@"FontName_Two" size:13];
    UIFont *boldFont13 = [UIFont kds_fontWithName:@"FontName_Four" size:13];
    for (int i = 0; i < 15; i ++) {
        UILabel *label = [UILabel new];
        [self addSubview:label];
        switch (i) {
            case 0:
                _name = label;
                _name.textColor = PanKou_BlackColor;
                _name.font = boldFont15;
                break;
            case 1:
                _code = label;
                _code.textColor = PanKou_BlackColor;
                _code.font = boldFont15;
                break;
            case 2:
                _stockStage = label;
                _stockStage.textColor = PanKou_GrayColor;
                _stockStage.font = font11;
                break;
            case 3:
                _dateTime = label;
                _dateTime.textColor = PanKou_GrayColor;
                _dateTime.font = font11;
                break;
            case 4:
                _lastPrice = label;
                _lastPrice.textColor = PanKou_GrayColor;
                _lastPrice.font = boldFont15;
                break;
            case 5:
                _change = label;
                _change.textColor = PanKou_GrayColor;
                _change.font = boldFont12;
                break;
            case 6:
                _changeRate = label;
                _changeRate.textColor = PanKou_GrayColor;
                _changeRate.font = boldFont12;
                break;
            case 7:
                _title = label;
                _title.textColor = PanKou_LightBlackColor;
                _title.font = font13;
                _title.text = @"今开";
                break;
            case 8:
                _title1 = label;
                _title1.textColor = PanKou_LightBlackColor;
                _title1.font = font13;
                _title1.text = @"昨收";
                break;
            case 9:
                _title2 = label;
                _title2.textColor = PanKou_LightBlackColor;
                _title2.font = font13;
                _title2.text = @"成交额";
                break;
            case 10:
                _title3 = label;
                _title3.textColor = PanKou_LightBlackColor;
                _title3.font = font13;
                _title3.text = @"换手率";
                break;
            case 11:
                _openPrice = label;
                _openPrice.textColor = PanKou_BlackColor;
                _openPrice.font = boldFont13;
                break;
            case 12:
                _preClosePrice = label;
                _preClosePrice.textColor = PanKou_BlackColor;
                _preClosePrice.font = boldFont13;
                break;
            case 13:
                _amount = label;
                _amount.textColor = PanKou_BlackColor;
                _amount.font = boldFont13;
                break;
            case 14:
                _turnoverRate = label;
                _turnoverRate.textColor = PanKou_BlackColor;
                _turnoverRate.font = boldFont13;
                break;
                
            default:
                break;
        }
    }
    
    //布局
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@3);
    }];
    [_code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(5);
        make.top.equalTo(self.name);
    }];
    
    [_stockStage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.top.equalTo(self.name.mas_bottom).offset(2);
    }];
    [_dateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stockStage.mas_right).offset(10);
        make.top.equalTo(self.stockStage);
    }];
    
    [_lastPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@175);
        make.top.equalTo(self.name);
    }];
    
    [_change mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lastPrice);
        make.top.equalTo(self.lastPrice.mas_bottom).offset(2);
    }];
    [_changeRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.change);
        make.left.equalTo(self.change.mas_right).offset(5);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name);
        make.left.equalTo(@270);
    }];
    [_openPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.top.equalTo(self.title.mas_bottom).offset(2);
    }];
    
    
    [_title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name);
        make.left.equalTo(self.title.mas_right).offset(30);
    }];
    [_preClosePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openPrice);
        make.left.equalTo(self.title1);
    }];
    
    
    [_title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name);
        make.left.equalTo(self.title1.mas_right).offset(30);
    }];
    [_amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title2);
        make.top.equalTo(self.openPrice);
    }];
    
    
    [_title3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name);
        make.left.equalTo(self.title2.mas_right).offset(30);
    }];
    
    [_turnoverRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title3);
        make.top.equalTo(self.openPrice);
    }];
}

- (void)updateWithModel:(MStockItem *)model {
    _name.text = model.name;
    _code.text = model.code_JT;
    _stockStage.text = model.stockStage_JT;
    _dateTime.text = [self formateDateTime:model.datetime];
    _lastPrice.text = model.lastPrice_JT;
    _change.text = model.change_JT;
    _changeRate.text = model.changeRate_JT;
    _openPrice.text = model.openPrice_JT;
    _preClosePrice.text = model.preClosePrice_JT;
    _amount.text = model.amount_JT;
    _turnoverRate.text = model.turnoverRate_JT;
    _changeRate.textColor = model.lastPriceColor;
    _change.textColor = model.lastPriceColor;
    _lastPrice.textColor = model.lastPriceColor;
}
- (NSString *)formateDateTime:(NSString *)dateTimeString {
    NSString *dateTime = @"";
    if (dateTimeString.length >= 8 ) {
        dateTime = [NSString stringWithFormat:@"%@/%@",[dateTimeString substringWithRange:NSMakeRange(4, 2)],[dateTimeString substringWithRange:NSMakeRange(6, 2)]];
    }
    if (dateTimeString.length >= 12) {
        dateTime = [NSString stringWithFormat:@"%@  %@:%@",dateTime,[dateTimeString substringWithRange:NSMakeRange(8, 2)],[dateTimeString substringWithRange:NSMakeRange(10, 2)]];
    }
    return dateTime;
}
@end
