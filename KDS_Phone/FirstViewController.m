//
//  FirstViewController.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/8/27.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "FirstViewController.h"
#import "JT_TimelineAndKlineSegment.h"
#import "KDS_UtilsMacro.h"
#import "JT_KLineView.h"
#import <Masonry.h>
#import <MApi.h>
#import "JT_KLineModel.h"
@interface FirstViewController () <JT_TimelineAndKlineSegmentDelegate,JT_KLineViewDelegate>
@property (nonatomic, strong)JT_KLineView *kLineView;
@property (nonatomic ,strong) NSMutableArray <JT_KLineModel *>*allKLineModel;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    JT_TimelineAndKlineSegment *sg = [JT_TimelineAndKlineSegment segmentWithType:JT_DeviceOrientationVertical delegte:self];
    sg.frame = CGRectMake(0, kStatusBarHeight + kNavigationBarHeight, kScreen_Width, 33);
    sg.seletedItemType = JT_SegmentItemTypeKline15Min;
    sg.supportedSimilarKline = YES;
    [self.view addSubview:sg];
    
    _kLineView = [JT_KLineView new];
    _kLineView.rightSelecterWidth = 55;
    _kLineView.needZoomAndScroll = YES;
    _kLineView.delegate = self;
    _kLineView.bottomMargin = 10;
    _kLineView.volumeButtonEnable = YES;
    
    
    [self.view addSubview:_kLineView];
    [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(sg.frame.origin.y + sg.frame.size.height);
        make.height.mas_equalTo(kScreen_Width * 0.9);
    }];
    [self requestKLineData];
}
- (NSMutableArray *)allKLineModel {
    if (!_allKLineModel) {
        _allKLineModel = @[].mutableCopy;
    }
    return _allKLineModel;
}
- (void)requestKLineData {
    MOHLCRequest *r = [[MOHLCRequest alloc] init];
    r.code = @"000001.sh";
    r.period = MOHLCPeriodMin15;
    r.subtype = @"1400";
    r.priceAdjustedMode = MOHLCPriceAdjustedModeForward;
    [MApi sendRequest:r completionHandler:^(MResponse *resp) {
        MOHLCResponse *response = (MOHLCResponse *)resp;
        if (response.status == MResponseStatusSuccess) {
            NSArray *items = response.OHLCItems;
            // 模型转换
            [items enumerateObjectsUsingBlock:^(MOHLCItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                JT_KLineModel *model = [[JT_KLineModel alloc] initWithModel:obj];
                [self.allKLineModel addObject:model];
                model.allKLineModel = self.allKLineModel;
            }];
            self.kLineView.kLineModels = self.allKLineModel;
        }
    }];
}
- (void)JT_TimelineAndKlineSegmentItemClick:(JT_TimelineAndKlineItemType)itemType{
    
}
- (void)JT_KLineFQSegmentClick:(JT_KLineFQType)type {
    NSLog(@"复权点击了");
}
- (void)JT_KLineIndicatorSegmentClick:(JT_KLineIndicatorType)type {
    NSLog(@"指标点击了");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)dealloc
{
    NSLog(@"dealloc 执行了");
}
@end
