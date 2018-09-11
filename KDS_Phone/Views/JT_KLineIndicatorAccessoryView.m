//
//  JT_KLineIndicatorAccessoryView.m
//  KDS_Phone
//
//  Created by feng on 2018/9/4.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineIndicatorAccessoryView.h"
#import <Masonry.h>
#import "JT_KLineConfig.h"
#import "JT_KLineModel.h"

@interface JT_KLineVolumeButton : UIView
- (void)draw:(BOOL)showTriangle;
@end
@implementation JT_KLineVolumeButton
- (void)draw:(BOOL)showTriangle {
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    NSString *title = [JT_KLineConfig currentIndicatorTitle];
    UIFont *font = [UIFont boldSystemFontOfSize:JT_KLineVolumeButtonFontSize];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName : font}];
    CGFloat Gap = 3;
    CGFloat triangleWidth = 7;
    CGFloat totalWidth = titleSize.width + Gap + triangleWidth;
    CGPoint titleDrawPoint = CGPointMake((rect.size.width - totalWidth) / 2, (rect.size.height - titleSize.height) / 2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画背景色
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, JT_KLineVolumeButtonBackgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    //画title
    [title drawAtPoint:titleDrawPoint withAttributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName : JT_KLineVolumeButtonTitleColor}];
    //画三角
    
    CGFloat originX = titleDrawPoint.x + titleSize.width + Gap;
    CGFloat orginY =  (rect.size.height - 7) / 2 + 1;
    CGPoint triangle[3];//坐标数组
    triangle[0] = CGPointMake(originX, orginY);
    triangle[1] = CGPointMake(originX + 7, orginY);
    triangle[2] = CGPointMake(originX + 7 / 2.f, rect.size.height - orginY);
    CGContextSetStrokeColorWithColor(context,JT_KLineVolumeButtonTriangleColor.CGColor);
    CGContextAddLines(context, triangle, 3);//添加线
    CGContextClosePath(context);//封闭路径
    CGContextSetFillColorWithColor(context, JT_KLineVolumeButtonTriangleColor.CGColor);//填充色
    CGContextDrawPath(context, kCGPathFillStroke);//根据坐标绘制路径并填充
    
}
@end
@interface JT_KLineIndicatorAccessoryView ()
@property (nonatomic ,strong) JT_KLineVolumeButton *titleButton;
@property (nonatomic ,strong) NSMutableArray <UILabel *>*items;
@property (nonatomic ,assign) CGFloat offset;
@end
@implementation JT_KLineIndicatorAccessoryView

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
        self.backgroundColor = JT_KLineMABackgroundColor;
        _offset = 4;
    }
    return self;
}
- (JT_KLineVolumeButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [JT_KLineVolumeButton new];
        if (self.volumeButtonEnable) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popPicker:)];
            [_titleButton addGestureRecognizer:tap];
        }
        _titleButton.backgroundColor = JT_KLineVolumeButtonBackgroundColor;
        [self addSubview:_titleButton];
        CGFloat buttonWidth = 40;
        if (self.volumeButtonEnable) {
            buttonWidth = 50;
        }
        [_titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.equalTo(@(buttonWidth));
        }];
    }
    return _titleButton;
}

//弹窗指标切换视图
- (void)popPicker:(id)sender {
    
}
- (void)titleButtonClick:(UIButton *)sender {
    
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}
- (NSMutableArray<UILabel *> *)items {
    if (!_items) {
        _items = @[].mutableCopy;
        //创建 5 label ,因为页面上数据最多的指标有 5 项数据
        for (int i = 0 ; i < 5; i ++) {
            UILabel *label = [UILabel new];
            label.tag = i;
            label.font = [UIFont systemFontOfSize:JT_KLineMAFontSize];
            [self addSubview:label];
            [_items addObject:label];
            if (i == 0) {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.titleButton.mas_right).offset(self.offset);
                    make.top.equalTo(self);
                    make.height.equalTo(self);
                }];
            } else {
                UILabel *preLabel = _items[i - 1];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(preLabel.mas_right).offset(self.offset);
                    make.top.equalTo(self);
                    make.height.equalTo(self);
                }];
            }
        }
    }
    return _items;
}
- (void)updateWith:(JT_KLineModel *)model {
    //更新标题
    [self.titleButton draw:self.volumeButtonEnable];
    
    [self.items enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.text = @"";
    }];
    ((UILabel *)_items[0]).textColor = JT_KLineIndexTitleColor;
    
    JT_KLineIndicatorType type = [JT_KLineConfig kLineIndicatorType];
    switch (type) {
        case JT_Volume:
        {
            ((UILabel *)_items[0]).text = [NSString stringWithFormat:@"VOL(5,10):%@",formatVolume(model.tradeVolume)];
            
            ((UILabel *)_items[1]).text = [NSString stringWithFormat:@"MA5:%@",formatVolume(model.volumeMA5)];
            ((UILabel *)_items[1]).textColor = JT_KLineMA5Color;
            ((UILabel *)_items[2]).text = [NSString stringWithFormat:@"MA10:%@",formatVolume(model.volumeMA10)];
            ((UILabel *)_items[2]).textColor = JT_KLineMA10Color;
        }
            break;
        case JT_KDJ:
        {
            ((UILabel *)_items[0]).text = [NSString stringWithFormat:@"KDJ(9,3,3)"];
            
            ((UILabel *)_items[1]).text = [NSString stringWithFormat:@"K:%.2f",model.KDJ_K];
            ((UILabel *)_items[1]).textColor = JT_KLine_KDJ_K_Color;
            ((UILabel *)_items[2]).text = [NSString stringWithFormat:@"D:%.2f",model.KDJ_D];
            ((UILabel *)_items[2]).textColor = JT_KLine_KDJ_D_Color;
            ((UILabel *)_items[3]).text = [NSString stringWithFormat:@"J:%.2f",model.KDJ_J];
            ((UILabel *)_items[3]).textColor = JT_KLine_KDJ_J_Color;
        }
            break;
        case JT_MACD:
        {
            ((UILabel *)_items[0]).text = [NSString stringWithFormat:@"MACD(12,26,9):%.2f",model.MACD];
            
            ((UILabel *)_items[1]).text = [NSString stringWithFormat:@"DIF:%.2f",model.DIF];
            ((UILabel *)_items[1]).textColor = JT_KLine_MACD_DIF_Color;
            ((UILabel *)_items[2]).text = [NSString stringWithFormat:@"DEA:%.2f",model.DEA];
            ((UILabel *)_items[2]).textColor = JT_KLine_MACD_DEA_Color;
        }
            break;
        case JT_BOLL:
        {
            ((UILabel *)_items[0]).text = @"BOOL(20,2)";
            ((UILabel *)_items[1]).text = [NSString stringWithFormat:@"MID:%.2f",model.MB];
            ((UILabel *)_items[1]).textColor = JT_KLine_BOLL_MID_Color;
            ((UILabel *)_items[2]).text = [NSString stringWithFormat:@"UP:%.2f",model.UP];
            ((UILabel *)_items[2]).textColor = JT_KLine_BOLL_UP_Color;
            ((UILabel *)_items[3]).text = [NSString stringWithFormat:@"LOW:%.2f",model.DN];
            ((UILabel *)_items[3]).textColor = JT_KLine_BOLL_LOW_Color;
        }
            break;
        case JT_RSI:
        {
            ((UILabel *)_items[0]).text = @"RSI(6,12,24)";
            ((UILabel *)_items[1]).text = [NSString stringWithFormat:@"6:%.2f",model.RSI6];
            ((UILabel *)_items[1]).textColor = JT_KLine_RSI_6_Color;
            ((UILabel *)_items[2]).text = [NSString stringWithFormat:@"12:%.2f",model.RSI12];
            ((UILabel *)_items[2]).textColor = JT_KLine_RSI_12_Color;
            ((UILabel *)_items[3]).text = [NSString stringWithFormat:@"24:%.2f",model.RSI24];
            ((UILabel *)_items[3]).textColor = JT_KLine_RSI_24_Color;
        }
            break;
        case JT_DMA:
        {
            ((UILabel *)_items[0]).text = @"DMA(10,50,10)";
            ((UILabel *)_items[1]).text = [NSString stringWithFormat:@"DMA:%.2f",model.DMA];
            ((UILabel *)_items[1]).textColor = JT_KLine_DMA_DMA_Color;
            ((UILabel *)_items[2]).text = [NSString stringWithFormat:@"AMA:%.2f",model.AMA];
            ((UILabel *)_items[2]).textColor = JT_KLine_DMA_AMA_Color;
        }
            break;
        case JT_DMI:
        {
            ((UILabel *)_items[0]).text = [NSString stringWithFormat:@"PDI:%.2f",model.PDI_14];
            ((UILabel *)_items[0]).textColor = JT_KLine_DMI_PDI_Color;
            ((UILabel *)_items[1]).text = [NSString stringWithFormat:@"MDI:%.2f",model.MDI_14];
            ((UILabel *)_items[1]).textColor = JT_KLine_DMI_MDI_Color;
            ((UILabel *)_items[2]).text = [NSString stringWithFormat:@"ADX:%.2f",model.ADX];
            ((UILabel *)_items[2]).textColor = JT_KLine_DMI_ADX_Color;
            ((UILabel *)_items[3]).text = [NSString stringWithFormat:@"ADXR:%.2f",model.ADXR];
            ((UILabel *)_items[3]).textColor = JT_KLine_DMI_ADXR_Color;
        }
            break;
        case JT_BIAS:
        {
            ((UILabel *)_items[0]).text = @"BIAS(6,12,24)";
            ((UILabel *)_items[1]).text = [NSString stringWithFormat:@"6:%.2f",model.BIAS6];
            ((UILabel *)_items[1]).textColor = JT_KLine_BIAS_6_Color;
            ((UILabel *)_items[2]).text = [NSString stringWithFormat:@"12:%.2f",model.BIAS12];
            ((UILabel *)_items[2]).textColor = JT_KLine_BIAS_12_Color;
            ((UILabel *)_items[3]).text = [NSString stringWithFormat:@"24:%.2f",model.BIAS24];
            ((UILabel *)_items[3]).textColor = JT_KLine_BIAS_24_Color;
        }
            break;
        case JT_CCI:
        {
            ((UILabel *)_items[0]).text = [NSString stringWithFormat:@"CCI(14):%.2f",model.CCI];
        }
            break;
        case JT_WR:
        {
            ((UILabel *)_items[0]).text = @"WR(10,6)";
            ((UILabel *)_items[1]).text = [NSString stringWithFormat:@"10:%.2f",model.WR10];
            ((UILabel *)_items[1]).textColor = JT_KLine_WR_10_Color;
            ((UILabel *)_items[2]).text = [NSString stringWithFormat:@"6:%.2f",model.WR6];
            ((UILabel *)_items[2]).textColor = JT_KLine_WR_6_Color;
        }
            break;
        case JT_VR:
        {
            ((UILabel *)_items[0]).text = @"VR(26)";
            ((UILabel *)_items[1]).text = [NSString stringWithFormat:@"VR:%.2f",model.VR];
            ((UILabel *)_items[1]).textColor = JT_KLine_VR_VR_Color;
            ((UILabel *)_items[2]).text = [NSString stringWithFormat:@"MAVR:%.2f",model.MAVR];
            ((UILabel *)_items[2]).textColor = JT_KLine_VR_MAVR_Color;
        }
            break;
        case JT_CR:
        {
            
        }
            break;
        case JT_OBV:
        {
            
        }
            break;
        default:
            break;
    }

}

@end
