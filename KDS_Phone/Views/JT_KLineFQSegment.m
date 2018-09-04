//
//  JT_KLineFQSegment.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/4.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineFQSegment.h"
#import <Masonry.h>
#import "JT_ColorManager.h"
#import "JT_KLineConfig.h"
#import "JT_KLineConfig.h"

@interface JT_KLineFQSegment ()
@property (nonatomic ,strong) NSArray <NSString *>*titles;
@property (nonatomic ,strong) NSMutableArray <UIButton *>*items;
@end
@implementation JT_KLineFQSegment

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
        self.backgroundColor = JT_KLineSegmentBackgroundColor;
        _titles = @[@"不复权",@"前复权",@"后复权"];
        _items = @[].mutableCopy;
        self.clipsToBounds = YES;
        [self newSubviews];
    }
    return self;
}
- (void)newSubviews {
    [_titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = idx;
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.items addObject:btn];
        [btn setTitle:self.titles[idx] forState:UIControlStateNormal];
        [btn setTitleColor:JT_KLineFQSegmentUnSelectedColor forState:UIControlStateNormal];
        [btn setTitleColor:JT_KLineFQSegmentSelectedColor forState:UIControlStateDisabled];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.superview);
            make.width.equalTo(btn.superview);
            make.height.equalTo(btn.superview).multipliedBy(1.0 / self.titles.count);
            if (idx == 0) {
                make.top.equalTo(self);
            } else {
                UIButton *preBtn = self.items[idx -1];
                make.top.equalTo(preBtn.mas_bottom);
            }
        }];
    }];
    
    //设置选中的 按钮的样式
    [self update];
}
- (void)itemClick:(UIButton *)sender {
    [JT_KLineConfig setkLineFQType:sender.tag];
    [self update];
    if (self.delegate && [self.delegate respondsToSelector:@selector(JT_KLineFQSegmentSelectedType:)]) {
        [self.delegate JT_KLineFQSegmentSelectedType:sender.tag];
    }
}
- (void)update {
    JT_KLineFQType type = [JT_KLineConfig kLineFQType];
    [self.items enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == type) {
            obj.enabled = NO;
            obj.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        } else {
            obj.enabled = YES;
            obj.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }];
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIColor *lineColor = JT_ColorDayOrNight(@"FDFEFF", @"141519");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context,8, rect.size.height - 1);
    CGContextAddLineToPoint(context, rect.size.width - 8, rect.size.height - 1);
    CGContextStrokePath(context);
}
@end
