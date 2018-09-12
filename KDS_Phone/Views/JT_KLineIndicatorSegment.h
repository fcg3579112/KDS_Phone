//
//  JT_KLineVolumeSegment.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/4.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JT_KLineEnum.h"
@protocol JT_KLineIndicatorSegmentDelegate <NSObject>
- (void)JT_KLineIndicatorSegmentSelectedType:(JT_KLineIndicatorType)type;
@end
@interface JT_KLineIndicatorSegment : UIView

@property (nonatomic ,weak) id <JT_KLineIndicatorSegmentDelegate> delegate;

- (void)update;
@end
