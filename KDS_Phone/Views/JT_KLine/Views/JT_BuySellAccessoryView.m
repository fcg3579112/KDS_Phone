//
//  JT_BuySellAccessoryView.m
//  KDS_Phone
//
//  Created by chuangao.feng on 2018/9/21.
//  Copyright © 2018年 com.csc. All rights reserved.
//

#import "JT_BuySellAccessoryView.h"
#import "JT_KLineBuySellModel.h"
#import <Masonry.h>
#import "JT_ColorManager.h"



#define JT_BuySellTextLeftMargin   8
#define JT_BuySellTextRightMargin  5
@interface JT_BuySellCell : UITableViewCell
@end
@implementation JT_BuySellCell

@end
@interface JT_BuySellAccessoryView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *mainTable;
@property (nonatomic ,strong)NSArray <JT_KLineBuySellModel *>*items;
@property (nonatomic ,strong) UIView *header;
@property (nonatomic ,strong) UIView *footer;
@property (nonatomic ,strong) UILabel *datetime;
@end
@implementation JT_BuySellAccessoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self mainTable];
    }
    return self;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count > 3 ? 3 : _items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JT_BuySellCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JT_BuySellCell" forIndexPath:indexPath];
    return cell;
}

- (void)updateWith:(NSArray<JT_KLineBuySellModel *> *)items {
    _items = items;
    [_mainTable reloadData];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_items.count > 3) {
        return self.footer;
    } else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 23;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_items.count > 3) {
        return 26;
    }
    return 0;
}
#pragma Getter
- (UITableView *)mainTable {
    if (!_mainTable) {
        _mainTable = [UITableView new];
        _mainTable.delegate = self;
        _mainTable.scrollEnabled = NO;
        _mainTable.dataSource = self;
        [self addSubview:_mainTable];
        [_mainTable registerClass:[JT_BuySellCell class] forCellReuseIdentifier:@"JT_BuySellCell"];
        [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _mainTable;
}
- (UIView *)header {
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 23)];
        CGRect rect = _header.frame;
        rect.origin.x = JT_BuySellTextLeftMargin;
        _datetime = [[UILabel alloc] initWithFrame:rect];
        [_header addSubview:_datetime];
        _datetime.font = [UIFont systemFontOfSize:10];
        _datetime.textColor = JT_ColorDayOrNight(@"858C9E", @"858C9E");
    }
    return _header;
}
- (UIView *)footer {
    if (!_footer) {
        _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 26)];
        UILabel *label = [[UILabel alloc] initWithFrame:_footer.frame];
        label.text = @"查看更多 >";
        label.textColor = JT_ColorDayOrNight(@"FF5A00", @"FF5A00 ");
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [_footer addSubview:label];
    }
    return _footer;
}
@end
