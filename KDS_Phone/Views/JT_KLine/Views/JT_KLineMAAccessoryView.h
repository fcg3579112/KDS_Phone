//
//  JT_KLineMAView.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/29.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JT_KLineModel;
@interface JT_KLineMAAccessoryView : UIView

- (void)updateMAWith:(JT_KLineModel *)model;

@end