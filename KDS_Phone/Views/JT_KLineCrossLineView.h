//
//  JT_KLineCrossLineView.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/12.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JT_KLineModel;
@interface JT_KLineCrossLineView : UIView
@property (nonatomic ,assign) CGFloat timeViewTopMargin;
@property (nonatomic ,assign) CGFloat timeViewHeight;
- (void)updateCrossLine:(CGPoint)point kLineModel:(JT_KLineModel *)kLineModel;
@end
