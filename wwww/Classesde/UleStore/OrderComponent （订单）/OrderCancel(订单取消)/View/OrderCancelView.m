//
//  OrderCancelView.m
//  UleApp
//
//  Created by chenzhuqing on 2017/1/6.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "OrderCancelView.h"
#import <UIView+SDAutoLayout.h>
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "OrderCancelCell.h"
#import <UIView+ShowAnimation.h>

#define H_table_cell            40

@interface OrderCancelView ()<UITableViewDelegate,UITableViewDataSource,OrderCancelCellDelegate>

@property (nonatomic, strong) UITableView * cancelTableView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * remindLabel;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) NSMutableArray<OrderCancelCellModel *> * dataArray;

@property (nonatomic, weak) id<OrderCancelViewDelegate>delgate;
@property (nonatomic, strong) OrderCancelCellModel * selectedCellModel;
@property (nonatomic, strong) OrderCancelSelectBlock selectBlock;
@end

@implementation OrderCancelView

- (id)initWithData:(NSMutableArray<OrderCancelCellModel *> *)mArray delegate:(id<OrderCancelViewDelegate>)delegate{
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 450)];
    if (self) {
        self.delgate=delegate;
        self.dataArray=mArray;
        self.backgroundColor=[UIColor whiteColor];
        [self setupView];
    }
    return self;
}

- (id)initWithData:(NSMutableArray<OrderCancelCellModel *>  *)mArray selectReason:(OrderCancelSelectBlock) select{
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 450)];
    if (self) {
        self.selectBlock =[select copy];
        self.dataArray=mArray;
        self.backgroundColor=[UIColor whiteColor];
        [self setupView];
    }
    return self;
}

- (void)setupView{

    [self sd_addSubviews:@[self.titleLabel,self.cancelTableView,self.remindLabel,self.sureBtn,self.cancelBtn]];
    self.titleLabel.sd_layout
    .topSpaceToView(self,0)
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .heightIs(50);
    
    self.sureBtn.sd_layout
    .rightSpaceToView(self,15)
    .bottomSpaceToView(self,kStatusBarHeight==20?10:34)
    .widthIs((__MainScreen_Width-40)/2)
    .heightIs(35);
    
    self.cancelBtn.sd_layout
    .leftSpaceToView(self,15)
    .bottomSpaceToView(self,kStatusBarHeight==20?10:34)
    .widthIs((__MainScreen_Width-40)/2)
    .heightIs(35);
    
    self.remindLabel.sd_layout
    .leftSpaceToView(self,10)
    .bottomSpaceToView(self.sureBtn,0)
    .rightSpaceToView(self,10)
    .heightIs(50);
    
    self.cancelTableView.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(self.titleLabel,0)
    .rightSpaceToView(self,0)
    .bottomSpaceToView(self.remindLabel,0);

    
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(context, 0.4);
    CGContextMoveToPoint(context,  0,self.titleLabel.height-0.5);
    CGContextAddLineToPoint(context,rect.size.width,self.titleLabel.height-0.5);
    CGContextStrokePath(context);
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[OrderCancelCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellName=@"OrderCancelCell";
    OrderCancelCell * cell=[tableView dequeueReusableCellWithIdentifier:@"OrderCancelCell"];
    Class cellClass=NSClassFromString(cellName);
    if (cell==nil) {
        cell=[[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.delegate=self;
    [cell setModel:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCancelCellModel * model=self.dataArray[indexPath.row];
    if (![self.selectedCellModel isEqual:model]) {
        self.selectedCellModel.isSelected=NO;
    }
    model.isSelected=!model.isSelected;
    self.selectedCellModel=model;
    [self.cancelTableView reloadData];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"=========");
}

#pragma mark - cell delegate
- (void)didSelectedResonModel:(OrderCancelCellModel *)model{
    if (![self.selectedCellModel isEqual:model]) {
        self.selectedCellModel.isSelected=NO;
    }
    self.selectedCellModel=model;
    [self.cancelTableView reloadData];
}

- (void)cancelClick:(id)sender{
    [self hiddenView];
}

- (void)sureClick:(id)sender{
    if (self.selectedCellModel&&self.selectedCellModel.isSelected) {
        [self hiddenView];
        if (self.delgate && [self.delgate respondsToSelector:@selector(didSelectedCancelOrderReason:)]) {
            [self.delgate didSelectedCancelOrderReason:self.selectedCellModel.cancelReason];
        }
        if (self.selectBlock) {
            self.selectBlock(self.selectedCellModel.cancelReason);
        }
    }else {
        [UleMBProgressHUD showHUDWithText:@"请选择取消原因" afterDelay:showDelayTime];
    }
    
}
#pragma mark - setter and getter
- (UITableView *)cancelTableView{
    if (_cancelTableView==nil) {
        _cancelTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _cancelTableView.dataSource=self;
        _cancelTableView.delegate=self;
    }
    return _cancelTableView;
}

- (UILabel *)titleLabel{
    if (_titleLabel==nil) {
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"选择取消订单的理由";
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)remindLabel{
    if (_remindLabel==nil) {
        _remindLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _remindLabel.text = @"提醒：订单状态变为待配货且超过5分钟时，取消订单需商家审核！";
        _remindLabel.font = [UIFont systemFontOfSize:13];
        _remindLabel.textColor=[UIColor redColor];
        _remindLabel.numberOfLines=0;
    }
    return _remindLabel;
}

- (UIButton *)cancelBtn{
    if (_cancelBtn==nil) {
        _cancelBtn=[[UIButton alloc] init];
        _cancelBtn.layer.borderColor=[UIColor blackColor].CGColor;
        _cancelBtn.layer.borderWidth=0.8;
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn{
    if (_sureBtn==nil) {
        _sureBtn=[[UIButton alloc] init];
        _sureBtn.layer.borderColor=[UIColor redColor].CGColor;
        _sureBtn.layer.borderWidth=0.8;
        [_sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
@end
