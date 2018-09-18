//
//  PanKouViewController.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/18.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "PanKouViewController.h"
#import <MApi.h>
#import <Masonry.h>
#import "JT_HorPanKouInfoView.h"
#import "JT_KLineAccessoryView.h"
#import "JT_TimelineAccessoryView.h"
#import "JT_TimelineAndKlineSegment.h"
@interface PanKouViewController () <JT_TimelineAndKlineSegmentDelegate>
@property (nonatomic ,strong) UIView *contentView;
@property (nonatomic ,strong) JT_HorPanKouInfoView *panKouView;
@property (nonatomic ,strong) JT_KLineAccessoryView *kLineAccessoryView;
@property (nonatomic ,strong) JT_TimelineAccessoryView *timelineAccessoryView;
@property (nonatomic ,strong) JT_TimelineAndKlineSegment *timelineAndKlineSegment;
@end

@implementation PanKouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    _contentView = [[UIView alloc] init];
    [self.view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self panKouView];
    [self timelineAndKlineSegment];
    
    [self requestTimeline];
}
- (void)requestTimeline {
    MSnapQuoteRequest *request = [[MSnapQuoteRequest alloc] init];
    request.code = @"399001.sz";
    [MApi sendRequest:request completionHandler:^(MResponse *resp) {
        MSnapQuoteResponse *response = (MSnapQuoteResponse *)resp;
        //增值指标数据
        response.stockItem.addValueItem;
        [self.panKouView updateWithModel:response.stockItem];
    }];
}
- (void)requestKLineData {
    MOHLCRequest *r = [[MOHLCRequest alloc] init];
    r.code = @"000001.sh";
    r.period = MOHLCPeriodDay;
    r.subtype = @"1400";
    r.priceAdjustedMode = MOHLCPriceAdjustedModeForward;
    [MApi sendRequest:r completionHandler:^(MResponse *resp) {
        MOHLCResponse *response = (MOHLCResponse *)resp;
        if (response.status == MResponseStatusSuccess) {
            NSArray *items = response.OHLCItems;
        }
    }];
}
#pragma Getter
- (JT_TimelineAndKlineSegment *)timelineAndKlineSegment {
    if (!_timelineAndKlineSegment) {
        _timelineAndKlineSegment = [JT_TimelineAndKlineSegment segmentWithType:JT_DeviceOrientationHorizontal delegte:self];
        [_contentView addSubview:_timelineAndKlineSegment];
        [_timelineAndKlineSegment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(self.panKouView.mas_bottom);
            make.height.equalTo(@30);
        }];
    }
    return _timelineAndKlineSegment;
}
- (JT_HorPanKouInfoView *)panKouView {
    if (!_panKouView) {
        _panKouView = [JT_HorPanKouInfoView new];
        [_contentView addSubview:_panKouView];
        [_panKouView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@0);
            make.height.equalTo(@40);
        }];
    }
    return _panKouView;
}
- (JT_KLineAccessoryView *)kLineAccessoryView {
    if (!_kLineAccessoryView) {
        _kLineAccessoryView = [JT_KLineAccessoryView new];
        _kLineAccessoryView.hidden = YES;
        [_contentView addSubview:_kLineAccessoryView];
        [_kLineAccessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.timelineAndKlineSegment);
        }];
    }
    return _kLineAccessoryView;
}
- (JT_TimelineAccessoryView *)timelineAccessoryView {
    if (!_timelineAccessoryView) {
        _timelineAccessoryView = [JT_TimelineAccessoryView new];
        _timelineAccessoryView.hidden = YES;
        [_contentView addSubview:_timelineAccessoryView];
        [_timelineAndKlineSegment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.timelineAndKlineSegment);
        }];
    }
    return _timelineAccessoryView;
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

@end
