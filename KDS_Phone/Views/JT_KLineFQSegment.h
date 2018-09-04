//
//  JT_KLineFQSegment.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/4.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JT_KLineEnum.h"
@protocol JT_KLineFQSegmentDelegate <NSObject>
- (void)JT_KLineFQSegmentSelectedType:(JT_KLineFQType)type;
@end
@interface JT_KLineFQSegment : UIView
- (void)update;
@property (nonatomic ,weak) id <JT_KLineFQSegmentDelegate> delegate;
@end

