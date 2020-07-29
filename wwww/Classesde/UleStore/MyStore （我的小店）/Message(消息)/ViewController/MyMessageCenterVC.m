//
//  MyMessageCenterVC.m
//  u_store
//
//  Created by MickyChiang on 2019/5/16.
//  Copyright © 2019 yushengyang. All rights reserved.
//

#import "MyMessageCenterVC.h"
#import "MyMessageCenterCell.h"

@interface MyMessageCenterVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *messages;
@end

@implementation MyMessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = [self.m_Params objectForKey:@"title"];
    if (title && title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    } else [self.uleCustemNavigationBar customTitleLabel:@"消息中心"];
    [self.view addSubview:self.tableview];
    self.tableview.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.tableview.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyMessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMessageCenterCell"];
    if (cell==nil) {
        cell = [[MyMessageCenterCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MyMessageCenterCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.message = self.messages[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"消息中心" moduledesc:self.messages[indexPath.row][@"title"] networkdetail:@""];
    
    if ([[self.messages[indexPath.row] objectForKey:@"title"] isEqualToString:@"订单消息"]) {
        [self pushNewViewController:@"US_OrderMessageListVC" isNibPage:NO withData:[[NSMutableDictionary alloc] initWithDictionary:self.messages[indexPath.row]]];
    } else {
        [self pushNewViewController:@"US_MessageListVC" isNibPage:NO withData:[[NSMutableDictionary alloc] initWithDictionary:self.messages[indexPath.row]]];
    }
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
        _tableview.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}

- (NSArray *)messages {
    if (_messages==nil) {
        NSArray *array = @[
                           @{@"title":@"系统消息",
                             @"image":@"message_system",
                             @"category":@""},
                           @{@"title":@"活动消息",
                             @"image":@"message_activity",
                             @"category":@"1089"},
                           @{@"title":@"我的物流",
                             @"image":@"message_logistics",
                             @"category":@"1029"},
                           @{@"title":@"我的钱包",
                             @"image":@"message_wallet",
                             @"category":@"1081"},
                           @{@"title":@"订单消息",
                             @"image":@"message_myOrder",
                             @"category":@"1011"}
                           ];
        _messages = [[NSArray alloc] initWithArray:array];
    }
    return _messages;
}

@end
