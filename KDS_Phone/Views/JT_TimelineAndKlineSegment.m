//
//  JT_TimelineOrKlineSegment.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/27.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_TimelineAndKlineSegment.h"
#import "JT_ColorManager.h"
#import "KDS_UtilsMacro.h"
#import "UIFont+KDS_FontHandle.h"
#import <Masonry.h>
// iPhoneX  safeAreaInsets  0, 44, 21, 44
#define itemButtonTagOffset           5

@protocol JT_KlineVerticalSegmentDelegate <NSObject>
- (void)JT_KlineVerticalSegmentItemClick:(JT_TimelineAndKlineItemType)itemType;
@end
@interface JT_KlineVerticalSegment : UIView

@property (nonatomic ,assign ,readonly) CGFloat segmentWidth;
@property (nonatomic ,assign ,readonly) CGFloat segmentHeight;
@property (nonatomic ,strong) NSArray *titles;
@property (nonatomic ,strong) NSMutableArray *itemButtons;
@property (nonatomic ,weak) id <JT_KlineVerticalSegmentDelegate> delegate;
+ (instancetype)klineSegmentWithTitles:(NSArray *)array delegate:(id <JT_KlineVerticalSegmentDelegate>)delegate;
- (void)updateButtonTitleColor;
@end
@implementation JT_KlineVerticalSegment
+ (instancetype)klineSegmentWithTitles:(NSArray *)array delegate:(id <JT_KlineVerticalSegmentDelegate>)delegate {
    JT_KlineVerticalSegment *sg = [[JT_KlineVerticalSegment alloc] init];
    sg.titles = array;
    sg.delegate = delegate;
    [sg newSubviews];
    return sg;
}
- (void)newSubviews {
    self.frame = CGRectMake(0, 0, self.segmentWidth, self.segmentHeight);
    self.backgroundColor = JT_ColorDayOrNight(@"FFFFFF", @"202125");
    CGFloat itemHeight = self.segmentHeight / self.titles.count;
    _itemButtons = @[].mutableCopy;
    [_titles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, itemHeight * idx, self.segmentWidth, itemHeight);
        btn.titleLabel.font = [UIFont kds_fontWithName:@"FontName_Two" size:15];
        [btn setTitleColor:JT_ColorDayOrNight(@"FC6435", @"FE3D00") forState:UIControlStateDisabled];
        [btn setTitleColor:JT_ColorDayOrNight(@"7B8291", @"878F95") forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = idx;
        [self addSubview:btn];
        [self.itemButtons addObject:btn];
        
        //三个分割线
        if (idx != 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, itemHeight * idx, self.segmentWidth, 1)];
            [self addSubview:lineView];
            lineView.backgroundColor = JT_ColorDayOrNight(@"E4E7EC", @"101419");
        }
    }];
    
    //设置阴影
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = .2;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(0,2);
    
}
- (void)updateButtonTitleColor {
    [_itemButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.enabled = YES;
    }];
}
- (void)itemButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JT_KlineVerticalSegmentItemClick:)]) {
        [self.delegate JT_KlineVerticalSegmentItemClick:sender.tag + itemButtonTagOffset];
    }
    [_itemButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (sender == item) {
            item.enabled = NO;
        } else {
            item.enabled = YES;
        }
    }];
}
- (CGFloat)segmentWidth {
    return kScreen_Width / 6.f;
}
- (CGFloat)segmentHeight {
    return 44 * self.titles.count;
}
@end
@interface JT_TimelineAndKlineSegment () <JT_KlineVerticalSegmentDelegate>
@property (nonatomic ,assign) JT_DeviceOrientation deviceOrientation;
@property (nonatomic ,strong) UIView *slider;//滑动横线
@property (nonatomic ,assign ,readonly) CGFloat segmentWidth;
@property (nonatomic ,assign ,readonly) CGFloat segmentHeight;
@property (nonatomic ,assign ,readonly) CGFloat similarKlineWidth;
@property (nonatomic ,assign ,readonly) CGFloat verticalLineHeight;
@property (nonatomic ,assign ,readonly) CGFloat sliderWidth;
@property (nonatomic ,assign ,readonly) CGFloat sliderHeight;
@property (nonatomic ,strong) UIButton *minButon; //竖屏时的分钟按钮
@property (nonatomic ,strong) UIButton *similarKlineButton; //相似 k 线按钮
@property (nonatomic ,strong) UIButton *settingButon; //设置按钮
@property (nonatomic ,strong) NSMutableArray *timelineAndKlineButtons;
@property (nonatomic ,weak) id <JT_TimelineAndKlineSegmentDelegate> delegate;
@property (nonatomic ,strong) JT_KlineVerticalSegment *verticalSegment;
@property (nonatomic ,strong) UIView *coverView;//
@end
@implementation JT_TimelineAndKlineSegment

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)segmentWithType:(JT_DeviceOrientation)orientation delegte:(id <JT_TimelineAndKlineSegmentDelegate>)delegate {
    JT_TimelineAndKlineSegment *segment = [[JT_TimelineAndKlineSegment alloc] init];
    segment.deviceOrientation = orientation;
    segment.delegate = delegate;
    [segment newSubviews];
    return segment;
}
- (void)newSubviews {
     _timelineAndKlineButtons = @[].mutableCopy;
    self.frame = CGRectMake(0, 0, self.segmentWidth, self.segmentHeight);
    self.backgroundColor = JT_ColorDayOrNight(@"F2F4F8", @"1B1C20");
    CGFloat rightMargin = 0;
    NSArray *titles;
    if (self.deviceOrientation == JT_DeviceOrientationVertical) {
        titles = @[@"分时",@"5日",@"日K",@"周K",@"分钟",@"设置"];
    } else {
        rightMargin = self.similarKlineWidth; //留出一部分用来放置相似 k 线按钮
        titles = @[@"分时",@"5日",@"日K",@"周K",@"月K",@"5分",@"15分",@"30分",@"60分",@"设置",];
        //添加相似 k 线 按钮
        _similarKlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_similarKlineButton addTarget:self action:@selector(similarKlineButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _similarKlineButton.titleLabel.font = [UIFont kds_fontWithName:@"FontName_Two" size:13];
        [_similarKlineButton setTitle:@"相似k线" forState:UIControlStateNormal];
        [self addSubview:_similarKlineButton];
        [_similarKlineButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(0);
            make.width.mas_equalTo(self.similarKlineWidth);
        }];
    }
    //按钮的宽度
    CGFloat itemButtonWidth = (self.segmentWidth - rightMargin) / titles.count;
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont kds_fontWithName:@"FontName_Two" size:15];
        [btn setTitleColor:JT_ColorDayOrNight(@"FC6435", @"FE3D00") forState:UIControlStateDisabled];
        [btn setTitleColor:JT_ColorDayOrNight(@"7B8291", @"878F95") forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = idx;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(itemButtonWidth);
            make.left.mas_equalTo(itemButtonWidth * idx);
        }];
        if (idx == 0) {
            btn.enabled = NO;
            self.slider = [[UIView alloc] init];
            self.slider.backgroundColor = JT_ColorDayOrNight(@"FF3D00", @"FF3D00");
            [self addSubview:self.slider];
            [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(self.sliderWidth, self.sliderHeight));
                make.centerX.equalTo(btn);
            }];
        }
        //设置按钮左边的竖线
        if (idx == titles.count - 1) {
            UIView *verticalLine = [UIView new];
            verticalLine.backgroundColor = JT_ColorDayOrNight(@"FC6435", @"FE3D00");
            [self addSubview:verticalLine];
//            verticalLine.frame = CGRectMake(btn.frame.origin.x, (self.segmentHeight - self.verticalLineHeight) / 2, 0.5, self.verticalLineHeight);
            [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0.5, self.verticalLineHeight));
                make.left.equalTo(btn);
            }];
        }
        if ([title isEqualToString:@"分钟"]) {
            self.minButon = btn;
        } else if ([title isEqualToString:@"设置"]) {
            self.settingButon = btn;
        }
        //添加到数组里，除了设置 与 分钟 按钮
        if (![title isEqualToString:@"设置"] && ![title isEqualToString:@"分钟"] ) {
            [self.timelineAndKlineButtons addObject:btn];
        }
    }];
    
    //把滑动条放置在视图最上方
    [self bringSubviewToFront:self.slider];
    
}
#pragma mark JT_KlineVerticalSegmentDelegate
- (void)JT_KlineVerticalSegmentItemClick:(JT_TimelineAndKlineItemType)itemType {
    [self resetSeletedButtonTitleColor:self.minButon];
    //选择红线 滑动到分钟按钮
    [self slideToSeletedItem:self.minButon];
    //设置选中 itemType
    [self setSeletedItemType:itemType];
    
    //重设 分钟 按钮的 title
    
    NSArray *titles = @[@"5分",@"15分",@"30分",@"60分",];
    [self.minButon setTitle:titles[itemType - itemButtonTagOffset] forState:UIControlStateNormal];
    
    //隐藏 分钟 k 线 segment
    [self disMissKlineSegment];
    self.minButon.enabled = YES;
    [self.minButon setTitleColor:JT_ColorDayOrNight(@"FC6435", @"FE3D00") forState:UIControlStateNormal];
}
#pragma mark ButtonClick

- (void)similarKlineButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JT_TimelineAndKlineSegmentItemClick:)]) {
        [self.delegate JT_TimelineAndKlineSegmentItemClick:JT_SegmentItemTypeSimilarKline];
    }
}
- (void)itemButtonClick:(UIButton *)sender {
    if (sender == self.settingButon) {
        [self setSeletedItemType:JT_SegmentItemTypeSetting];
    } else if (sender == self.minButon) { //展示竖屏分钟 k 线切换按钮
        [self showKlineVerticalSegmentBelowView:self.minButon];
    } else {
        [self resetSeletedButtonTitleColor:sender];
        [self.minButon setTitleColor:JT_ColorDayOrNight(@"7B8291", @"878F95") forState:UIControlStateNormal];
        [self.minButon setTitle:@"分钟" forState:UIControlStateNormal];
        if (_verticalSegment) {
           [_verticalSegment updateButtonTitleColor];
        }
    }
}
- (void)showKlineVerticalSegmentBelowView:(UIView *)view {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissKlineSegment)];
        [_coverView addGestureRecognizer:tap];
    }
    [UIApplication.sharedApplication.keyWindow addSubview:_coverView];
    if (!_verticalSegment) {
        _verticalSegment = [JT_KlineVerticalSegment klineSegmentWithTitles:@[@"5分",@"15分",@"30分",@"60分",] delegate:self];
        [_coverView addSubview:_verticalSegment];
    }
    CGPoint origin = view.frame.origin;
    origin = [view convertPoint:origin toView:_coverView];
    _verticalSegment.frame = CGRectMake(view.frame.origin.x, origin.y + view.frame.size.height, _verticalSegment.segmentWidth, 0);
    _verticalSegment.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
        self.verticalSegment.alpha = 1;
        self.verticalSegment.frame = CGRectMake(view.frame.origin.x, origin.y + view.frame.size.height, self.verticalSegment.segmentWidth, self.verticalSegment.segmentHeight);
    }];
}
- (void)disMissKlineSegment{
    [_coverView removeFromSuperview];
}
- (void)resetSeletedButtonTitleColor:(UIButton *)sender {
    [_timelineAndKlineButtons enumerateObjectsUsingBlock:^(UIButton  *_Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item == sender) {
            item.enabled = NO;
            [self slideToSeletedItem:item];
        } else {
            item.enabled = YES;
        }
    }];
    if (sender != self.minButon) {
        [self setSeletedItemType:sender.tag];
    }
}
//滑动到选中的 item 下面
- (void)slideToSeletedItem:(UIButton *)button{
    [UIView animateWithDuration:0.15 animations:^{
        CGFloat centerY = self.slider.center.y;
        CGFloat width = [button.titleLabel.text sizeWithAttributes:@{ NSFontAttributeName : button.titleLabel.font}].width;
        CGRect rect = self.slider.frame;
        rect.size.width = width + 15;
        self.slider.frame = rect;
        self.slider.center = CGPointMake(button.center.x, centerY);
    }];
}
#pragma mark Setter


/**
 设置选中的 item 的类型
 调用 该方法，会触发代理方法 JT_TimelineOrKlineSegmentItemClick:

 @param seletedItemType item 类型
 */
- (void)setSeletedItemType:(JT_TimelineAndKlineItemType)seletedItemType {
    _seletedItemType = seletedItemType;
    if (self.delegate && [self.delegate respondsToSelector:@selector(JT_TimelineAndKlineSegmentItemClick:)]) {
        [self.delegate JT_TimelineAndKlineSegmentItemClick:JT_SegmentItemTypeSetting];
    }
    [self setNeedsDisplay];
}
- (void)setSupportedSimilarKline:(BOOL)supportedSimilarKline {
    _supportedSimilarKline = supportedSimilarKline;
    if (_supportedSimilarKline) {
        [_similarKlineButton setTitleColor:JT_ColorDayOrNight(@"FF6C1D", @"E46129") forState:UIControlStateNormal];
    } else {
        [_similarKlineButton setTitleColor:JT_ColorDayOrNight(@"A7ABB4", @"5E6575") forState:UIControlStateNormal];
    }
    [self setNeedsDisplay];
}
#pragma mark Getter

- (CGFloat)segmentWidth {
    if (self.deviceOrientation == JT_DeviceOrientationVertical) {
        return kScreen_Width;
    }
    return kScreen_Width == 812 ? (kScreen_Width - 44 * 2) : kScreen_Width;
}
- (CGFloat)segmentHeight {
    return self.deviceOrientation == JT_DeviceOrientationVertical ? 33 : 30;
}
- (CGFloat)similarKlineWidth {
    return 60;
}
- (CGFloat)sliderWidth {
    return 45;
}
- (CGFloat)sliderHeight {
    return 2;
}

/**
 三角的颜色

 @return 三角的颜色
 */
- (UIColor *)triangleColor {
    if (_seletedItemType == JT_SegmentItemTypeKline5Min
        || _seletedItemType == JT_SegmentItemTypeKline15Min
        || _seletedItemType == JT_SegmentItemTypeKline30Min
        || _seletedItemType == JT_SegmentItemTypeKline60Min) {
        return JT_ColorDayOrNight(@"FC6435", @"FE3D00");
    } else {
        return JT_ColorDayOrNight(@"7B8291", @"878F95");
    }
}
/**
 设置左边分割线的高度

 @return 高度
 */
- (CGFloat)verticalLineHeight {
    return 15;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.deviceOrientation == JT_DeviceOrientationVertical) { //竖屏下画分钟按钮右下角的三角
        CGFloat originBottomX = self.minButon.frame.origin.x + self.minButon.frame.size.width - 7;
        CGFloat orginBottomY = self.minButon.frame.size.height - 8;
        CGPoint triangle[3];//坐标数组
        triangle[0] = CGPointMake(originBottomX, orginBottomY);
        triangle[1] = CGPointMake(originBottomX, orginBottomY - 6);
        triangle[2] = CGPointMake(originBottomX - 6, orginBottomY);
        CGContextSetStrokeColorWithColor(context,self.triangleColor.CGColor);
        CGContextAddLines(context, triangle, 3);//添加线
        CGContextClosePath(context);//封闭路径
        CGContextSetFillColorWithColor(context, self.triangleColor.CGColor);//填充色
        CGContextDrawPath(context, kCGPathFillStroke);//根据坐标绘制路径并填充
    } else {
        //画相似 k 线 背景
        UIColor *bgColor;
        if (self.supportedSimilarKline) {
            bgColor = JT_ColorDayOrNight(@"FFDDCB", @"542F0C");
        } else {
            bgColor = JT_ColorDayOrNight(@"E5E7EC", @"212226");
        }
        CGContextSetStrokeColorWithColor(context,bgColor.CGColor);
        CGContextSetLineWidth(context, 19);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextMoveToPoint(context, self.frame.size.width - self.similarKlineWidth + 19 / 2.f, self.frame.size.height / 2.f);
        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height / 2.f);
        CGContextStrokePath(context);
    }
}
@end
