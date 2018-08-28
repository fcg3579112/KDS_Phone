//
//  DetailViewController.m
//  QuotationTest
//
//  Created by chuangao.feng on 2018/8/21.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "DetailViewController.h"
#import <Masonry.h>
@interface DetailViewController () <UIWebViewDelegate>
@property (nonatomic ,strong) UIWebView *webView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
     NSURL *path = [[NSBundle mainBundle] URLForResource:@"json" withExtension:@"html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:path]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadJson(%@)",_content]];
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
