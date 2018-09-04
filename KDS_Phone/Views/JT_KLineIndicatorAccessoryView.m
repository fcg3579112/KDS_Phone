//
//  JT_KLineIndicatorAccessoryView.m
//  KDS_Phone
//
//  Created by feng on 2018/9/4.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineIndicatorAccessoryView.h"

#import "JT_KLineConfig.h"
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
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

@end
