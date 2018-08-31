//
//  ViewController.m
//  QuotationTest
//
//  Created by chuangao.feng on 2018/8/21.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "ViewController.h"
#import <MApi.h>
#import <MBProgressHUD.h>
#import "DetailViewController.h"
#import <YYKit.h>
#import <NSObject+YYModel.h>
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *codes;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_mainTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellItem"];
    _titles = @[@"行情列表",@" k 线",@"分时",@"5日分时",@"分类排行",@"板块排行",@"两市港股通数据"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_codes resignFirstResponder];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self requstPanKouData:nil];
            break;
        case 1:
            [self requestKLineData:nil];
            break;
        case 2:
            [self requestFSData:nil];
            break;
        case 3:
            [self requestFiveDayData:nil];
            break;
        case 4:
            [self requestCategorySortData:nil];
            break;
        case 5:
            [self requestSectionSortData:nil];
            break;
        case 6:
            [self requestMHKMarketInfo:nil];
            break;
        default:
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellItem" forIndexPath:indexPath];
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}
- (IBAction)requstPanKouData:(id)sender {
    [_codes resignFirstResponder];
    if (!_codes.text.length) {
        [self showHUD:@"请输入股票代码"];
        return;
    }
    MQuoteRequest *request = [[MQuoteRequest alloc] init];
    request.code = _codes.text;
    [MApi  sendRequest:request completionHandler:^(MResponse *resp) {
        MQuoteResponse *response = (MQuoteResponse *)resp;
        if (response.status == MResponseStatusSuccess) {
            NSArray *items = response.stockItems;
            NSString *result = items.modelToJSONString;
            [self pushToDetailViewController:result];
        } else {
            [self showHUD:response.message];
        }
    }];
}
- (void)pushToDetailViewController:(NSString *)text{
    DetailViewController *vc = [DetailViewController new];
    vc.content = text;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)requestKLineData:(id)sender {
    [_codes resignFirstResponder];
    if (!_codes.text.length) {
        [self showHUD:@"请输入股票代码"];
        return;
    }
    MOHLCRequest *r = [[MOHLCRequest alloc] init];
    r.code = _codes.text;
    r.period = MOHLCPeriodMin5;
    r.subtype = @"1400";
    r.priceAdjustedMode = MOHLCPriceAdjustedModeForward;
    [MApi sendRequest:r completionHandler:^(MResponse *resp) {
        MOHLCResponse *response = (MOHLCResponse *)resp;
        if (response.status == MResponseStatusSuccess) {
            NSArray *items = response.OHLCItems;
            NSString *result = items.modelToJSONString;
            [self pushToDetailViewController:result];
        } else {
            [self showHUD:response.message];
        }
    }];
}
- (IBAction)requestFSData:(id)sender {
    [_codes resignFirstResponder];
    if (!_codes.text.length) {
        [self showHUD:@"请输入股票代码"];
        return;
    }
    MChartRequest *r = [[MChartRequest alloc] init];
    r.code = _codes.text;
    r.subtype = @"1400";
    r.chartType = MChartTypeOneDay;
    [MApi sendRequest:r completionHandler:^(MResponse *resp) {
        MChartResponse *response = (MChartResponse *)resp;
        if (response.status == MResponseStatusSuccess) {
            NSArray *items = response.OHLCItems;
            NSString *result = items.modelToJSONString;
            [self pushToDetailViewController:result];
        } else {
            [self showHUD:response.message];
        }
    }];
}
- (IBAction)requestFiveDayData:(id)sender {
    [_codes resignFirstResponder];
    if (!_codes.text.length) {
        [self showHUD:@"请输入股票代码"];
        return;
    }
    MChartRequest *r = [[MChartRequest alloc] init];
    r.code = _codes.text;
    r.subtype = @"1400";
    r.chartType = MChartTypeFiveDays;
    [MApi sendRequest:r completionHandler:^(MResponse *resp) {
        MChartResponse *response = (MChartResponse *)resp;
        if (response.status == MResponseStatusSuccess) {
            NSArray *items = response.OHLCItems;
            NSString *result = items.modelToJSONString;
            [self pushToDetailViewController:result];
        } else {
            [self showHUD:response.message];
        }
    }];
}

- (IBAction)requestCategorySortData:(id)sender {
    [_codes resignFirstResponder];
    if (!_codes.text.length) {
        [self showHUD:@"请输入股票代码"];
        return;
    }
    MCategorySortingRequest *request =[[MCategorySortingRequest alloc] init];
    request.code = _codes.text;
    request.pageIndex = 0;
    request.pageSize = 10;
    request.field = MCategorySortingFieldChangeRate;
    request.ascending = NO;
    request.includeSuspension = NO;
    
    [MApi sendRequest:request completionHandler:^(MResponse *resp) {
        
        MCategorySortingResponse *response = (MCategorySortingResponse *)resp;
        if (response.status == MResponseStatusSuccess) {
            NSArray *items = response.stockItems;
            NSString *result = items.modelToJSONString;
            [self pushToDetailViewController:result];
        } else {
            [self showHUD:response.message];
        }
    }];
}

- (IBAction)requestSectionSortData:(id)sender {
    [_codes resignFirstResponder];
    if (!_codes.text.length) {
        [self showHUD:@"请输入股票代码"];
        return;
    }
    MSectionSortingRequest *r = [[MSectionSortingRequest alloc] init];
    r.code = _codes.text;
    r.pageSize = 6;
    r.field = MSectionSortingFieldAverageChange;
    r.ascending = NO;
    [MApi sendRequest:r completionHandler:^(MResponse *resp) {
        MSectionSortingResponse *response = (MSectionSortingResponse *)resp;
        if (response.status == MResponseStatusSuccess) {
            NSArray *items = response.sectionSortingItems;
            NSString *result = items.modelToJSONString;
            [self pushToDetailViewController:result];
        } else {
            [self showHUD:response.message];
        }
    }];
}
- (IBAction)requestMHKMarketInfo:(id)sender {
    [_codes resignFirstResponder];
    //获取两市港股通 每日初始额度 日中剩余额度和额度状态
    MHKMarketInfoRequest *r = [[MHKMarketInfoRequest alloc] init];
    
    //发送请求
    [MApi sendRequest:r completionHandler:^(MResponse *resp) {
        MHKMarketInfoResponse* response = (MHKMarketInfoResponse *)resp;
        if(response.status == MResponseStatusSuccess) {
            //应答无误，处理数据
            NSString *result = response.modelToJSONString;
            [self pushToDetailViewController:result];
            
        } else {
            [self showHUD:response.message];
        }
    }];
}


- (void)showHUD:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:2];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
