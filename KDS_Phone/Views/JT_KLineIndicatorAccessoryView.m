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
    if ([JT_KLineConfig kLineIndicatorType] == JT_Volume) {
        ((UILabel *)_items[0]).text = @"VOL(5,10):";
        ((UILabel *)_items[1]).text = [self formateVolume:model.tradeVolume];
        ((UILabel *)_items[2]).text = [NSString stringWithFormat:@"MA5:%@",[self formateVolume:model.volumeMA5]];
        ((UILabel *)_items[3]).text = [NSString stringWithFormat:@"MA10:%@",[self formateVolume:model.volumeMA10]];
    } else if ([JT_KLineConfig kLineIndicatorType] == JT_KDJ) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_MACD) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_BOLL) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_RSI) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_DMA) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_DMI) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_BIAS) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_CCI) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_WR) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_VR) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_CR) {
        
    }else if ([JT_KLineConfig kLineIndicatorType] == JT_OBV) {
        
    }
}
//格式化成交量
- (NSString *)formateVolume:(NSUInteger)volume {
    if (volume > 100000000) {
        return [NSString stringWithFormat:@"%.2f亿",volume / 100000000.0];
    } else if (volume > 10000) {
        return [NSString stringWithFormat:@"%.2f万",volume / 10000.0];
    } else {
        return [NSString stringWithFormat:@"%lu",volume];
    }
}
//func drawRectangleOnImage(image: UIImage) -> UIImage {
//    let imageSize = image.size
//    let scale: CGFloat = 0
//    UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
//    let context = UIGraphicsGetCurrentContext()
//
//    image.drawAtPoint(CGPointZero)
//
//    let rectangle = CGRect(x: 0, y: (imageSize.height/2) - 30, width: imageSize.width, height: 60)
//
//    CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
//    CGContextAddRect(context, rectangle)
//    CGContextDrawPath(context, .Fill)
//
//    let newImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return newImage
//}
@end
