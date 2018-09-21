//
//  JT_KLineBuySellModel.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/21.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_KLineBuySellModel.h"

@implementation JT_KLineBuySellModel
- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _bsflag = dic[@"bsflag"];
        _matchamt = dic[@"matchamt"];
        _matchdate = dic[@"matchdate"];
        _matchnum = dic[@"matchnum"];
        _matchprice = dic[@"matchprice"];
        _matchtime = dic[@"matchtime"];
    }
    return self;
}
@end
