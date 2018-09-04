//
//  JT_KLineVolumeSegment.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/4.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineIndicatorSegment.h"
#import <Masonry.h>
#import "JT_KLineConfig.h"
@interface  JT_KLineIndicatorSegment ()
@property (nonatomic ,strong) NSArray <NSString *>*titles;
@property (nonatomic ,strong) NSMutableArray <UIButton *>*items;
@property (nonatomic ,strong) UIScrollView *scrollView;
@end
@implementation JT_KLineIndicatorSegment

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
        _titles = @[@"成交量",@"KDJ",@"MACD",@"BOLL",@"RSI",@"DMA",@"BIAS",@"CCI",@"WR",@"CR",@"OBV"];
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
        [self.scrollView addSubview:btn];
        [self.items addObject:btn];
        [btn setTitle:self.titles[idx] forState:UIControlStateNormal];
        [btn setTitleColor:JT_KLineFQSegmentUnSelectedColor forState:UIControlStateNormal];
        [btn setTitleColor:JT_KLineFQSegmentSelectedColor forState:UIControlStateDisabled];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.superview);
            make.width.equalTo(btn.superview);
            make.height.equalTo(@(JT_KLineFQSegmentItemHight));
            if (idx == 0) {
                make.top.equalTo(btn.superview);
            } else {
                UIButton *preBtn = self.items[idx -1];
                make.top.equalTo(preBtn.mas_bottom);
            }
        }];
    }];
    [self.scrollView setContentSize:CGSizeMake(self.frame.size.width, JT_KLineFQSegmentItemHight * _titles.count)];
    //设置选中的 按钮的样式
    [self update];
}
- (void)itemClick:(UIButton *)sender {
    [JT_KLineConfig setkLineIndicatorType:sender.tag];
    [self update];
    if (self.delegate && [self.delegate respondsToSelector:@selector(JT_KLineIndicatorSegmentSelectedType:)]) {
        [self.delegate JT_KLineIndicatorSegmentSelectedType:sender.tag];
    }
}
- (void)update {
    JT_KLineIndicatorType type = [JT_KLineConfig kLineIndicatorType];
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
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(@(0));
        }];
    }
    return _scrollView;
}
@end
