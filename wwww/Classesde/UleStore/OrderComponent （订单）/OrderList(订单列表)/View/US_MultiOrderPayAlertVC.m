//
//  US_ MultiOrderPayAlertVC.m
//  UleStoreApp
//
//  Created by 李泽萌 on 2020/4/13.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_MultiOrderPayAlertVC.h"
#import "UIView+ShowAnimation.h"
#import "US_MyOrderApi.h"
#import "MultiOrderPayAlertTableViewCell.h"

@interface US_MultiOrderPayAlertVC ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UILabel * titleView;
@property (nonatomic, strong) UIButton * topCloseBtn;

@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * toPayBtn;

@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UILabel * totalOrderAmountLab;
@property (nonatomic, strong) UILabel * totalNumLab;

@property (nonatomic, strong) US_MultiOrderDetails * detail;
@end

@implementation US_MultiOrderPayAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.uleCustemNavigationBar.hidden=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    self.view.layer.masksToBounds = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
    UIView * lineView=[UIView new];
    lineView.backgroundColor=[UIColor convertHexToRGB:@"e4e5e4"];
    [self.view sd_addSubviews:@[self.titleView,self.topCloseBtn,self.tableView,self.cancelBtn,self.toPayBtn]];
    self.titleView.sd_layout
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,40)
    .topSpaceToView(self.view,3)
    .heightIs(45);
    self.cancelBtn.sd_layout
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .widthIs(__MainScreen_Width/2)
    .heightIs(kIphoneX?69:45);
    self.toPayBtn.sd_layout
    .leftSpaceToView(self.cancelBtn, 0)
    .bottomSpaceToView(self.view, 0)
    .widthIs(__MainScreen_Width/2)
    .heightIs(kIphoneX?69:45);
    [self.cancelBtn addSubview:lineView];
    lineView.sd_layout
    .leftSpaceToView(self.cancelBtn, 0)
    .rightSpaceToView(self.cancelBtn, 0)
    .topSpaceToView(self.cancelBtn, 0)
    .heightIs(1);
    
    self.tableView.sd_layout
    .topSpaceToView(self.titleView,0)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.cancelBtn,0);
    
    [self getDifferentStoreOrderInfo];
}

-(void)getDifferentStoreOrderInfo{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@""];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_MyOrderApi buildGetDifferentStoreOrderInfoWithOrderId:self.orderId] success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self.view];
        self.detail=[US_MultiOrderDetails yy_modelWithDictionary:responseObject];
        self.dataArray=self.detail.details;
        [self.tableView reloadData];
        self.titleLab.text=@"合计金额";
        self.totalOrderAmountLab.text=[NSString stringWithFormat:@"¥%.2f", self.detail.orderAmount.doubleValue];
        self.totalNumLab.text=[NSString stringWithFormat:@"共%@件",self.detail.productNumTotal];
    
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

#pragma mark -- tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify=@"MultiOrderPayAlertTableViewCell";

    MultiOrderPayAlertTableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[MultiOrderPayAlertTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    [cell setModel:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - view
- (void)closeView:(id)sender{
  [self.view hiddenView];
}

- (void)titleViewClick{
    [self.view hiddenView];
}

- (void)toPayBtnClick:(id)sender{
    [self.view hiddenView];
    if (self.confirmBlock) {
        self.confirmBlock([self escOrderIds]);
    }
}

- (NSString *)escOrderIds{
    // 组合商品的iteminfo
    NSMutableString *storeStr = [[NSMutableString alloc] init];
    for (US_MultiOrderInfo *orderInfo in self.detail.details) {
        NSString *str = @"";
        str = orderInfo.escOrderIds;
        [storeStr appendString:str];
        if ([storeStr length] != 0) {
            [storeStr appendString:@","];
        }
    }
    NSString *_str = [NSString stringWithString:storeStr];
    if (_str.length > 0) {
        _str = [_str substringToIndex:_str.length - 1];  // 去掉最后一个逗号
    }
    return _str;
}

#pragma mark - setter and getter
- (NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray new];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView=[self createHeaderView];
        _tableView.tableHeaderView.height=55;
    }
    return _tableView;
}

- (UIView *)createHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 55)];
    view.backgroundColor = [UIColor whiteColor];
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
    self.titleLab.backgroundColor = [UIColor whiteColor];
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = [UIFont systemFontOfSize:14];
    [view addSubview:self.titleLab];
    self.totalOrderAmountLab = [[UILabel alloc]initWithFrame:CGRectMake(__MainScreen_Width-130, 5, 120, 20)];
    self.totalOrderAmountLab.backgroundColor = [UIColor whiteColor];
    self.totalOrderAmountLab.textColor = [UIColor convertHexToRGB:@"ef3c3a"];
    self.totalOrderAmountLab.textAlignment = NSTextAlignmentRight;
    self.totalOrderAmountLab.font = [UIFont systemFontOfSize:14];
    [view addSubview:self.totalOrderAmountLab];
    self.totalNumLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, __MainScreen_Width-20, 20)];
    self.totalNumLab.backgroundColor = [UIColor whiteColor];
    self.totalNumLab.textColor = [UIColor darkGrayColor];
    self.totalNumLab.textAlignment = NSTextAlignmentLeft;
    self.totalNumLab.font = [UIFont systemFontOfSize:14];
    [view addSubview:self.totalNumLab];
    UIView * lineView=[UIView new];
    lineView.backgroundColor=[UIColor convertHexToRGB:@"e4e5e4"];
    [lineView setFrame:CGRectMake(10, 54, __MainScreen_Width-20, 1)];
    [view addSubview:lineView];
    return view;
}

- (UILabel *)titleView{
    if (_titleView==nil) {
        _titleView=[[UILabel alloc] init];
        _titleView.textAlignment=NSTextAlignmentLeft;
        _titleView.text=@"由于以下订单共享优惠，需要一起支付";
        _titleView.font=[UIFont systemFontOfSize:15];
        _titleView.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewClick)];
        [_titleView addGestureRecognizer:labelTapGestureRecognizer];
        _titleView.userInteractionEnabled = YES;
        
        
    }
    return _titleView;
}
- (UIButton*)topCloseBtn{
    if (_topCloseBtn == nil) {
        _topCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topCloseBtn.frame = CGRectMake(__MainScreen_Width - 35,3+(45 - 15)/2, 15, 15);
        [_topCloseBtn setBackgroundImage:[UIImage imageNamed:@"closeAlertIcon"] forState:UIControlStateNormal];
        [_topCloseBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topCloseBtn;
}

- (UIButton*)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"再想想" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:18];
        _cancelBtn.backgroundColor=[UIColor whiteColor];
        [_cancelBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton*)toPayBtn{
    if (_toPayBtn == nil) {
        _toPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toPayBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [_toPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _toPayBtn.titleLabel.font=[UIFont systemFontOfSize:18];
        _toPayBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3c3a"];
        [_toPayBtn addTarget:self action:@selector(toPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toPayBtn;
}

@end
