//
//  JT_KLineBuySellModel.h
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/21.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JT_KLineBuySellModel : NSObject
@property (nonatomic ,copy)NSString *bsflag;
@property (nonatomic ,copy)NSString *matchamt;
@property (nonatomic ,copy)NSString *matchdate;
@property (nonatomic ,copy)NSString *matchnum;
@property (nonatomic ,copy)NSString *matchprice;
@property (nonatomic ,copy)NSString *matchtime;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
