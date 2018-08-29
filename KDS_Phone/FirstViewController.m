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
@interface FirstViewController () <JT_TimelineAndKlineSegmentDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    JT_TimelineAndKlineSegment *sg = [JT_TimelineAndKlineSegment segmentWithType:JT_DeviceOrientationVertical delegte:self];
    sg.frame = CGRectMake(0, kStatusBarHeight + kNavigationBarHeight, kScreen_Width, 33);
    sg.seletedItemType = JT_SegmentItemTypeKline15Min;
    sg.supportedSimilarKline = YES;
    [self.view addSubview:sg];
}
- (void)JT_TimelineAndKlineSegmentItemClick:(JT_TimelineAndKlineItemType)itemType{
    
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
