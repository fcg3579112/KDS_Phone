//
//  JT_BuySellAccessoryView.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/21.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JT_KLineBuySellModel;
@interface JT_BuySellAccessoryView : UIView
- (void)updateWith:(NSArray <JT_KLineBuySellModel *>*)items;
@end
