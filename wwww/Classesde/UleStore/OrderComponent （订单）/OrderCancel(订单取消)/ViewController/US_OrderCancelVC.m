//
//  US_OrderCancelVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderCancelVC.h"
#import <UIView+SDAutoLayout.h>
//#import "UITableView+SDAutoTableViewCellHeight.h"
#import "OrderCancelCell.h"
#import <UIView+ShowAnimation.h>
#import "US_MyOrderApi.h"
#import "CancelOrderInfo.h"
#import "UleBaseViewModel.h"
#import "US_PresentAnimaiton.h"
#import "US_CancelOrderModel.h"
#import <YYLabel.h>

@interface US_OrderCancelVC ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UITableView * cancelTableView;
@property (nonatomic, strong) YYLabel * topRemindLabel;
@property (nonatomic, strong) YYLabel * remindLabel;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) NSMutableArray<OrderCancelCellModel *> * dataArray;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) US_PresentAnimaiton * animation;
@property (nonatomic, strong) OrderCancelCellModel * selectedCellModel;
@property (nonatomic, strong) NSString * esc_orderid;
@end

@implementation US_OrderCancelVC
#pragma mark - <Life cycle>
- (instancetype)init {
    self = [super init];
    if (self) {
        _animation = [[US_PresentAnimaiton alloc] initWithAnimationType:AniamtionSheetType targetViewSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-0, 450)];
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate=self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.esc_orderid=self.m_Params[@"esc_orderid"];
    [self setUI];
    [self startRequestCancelReason];
}

- (void)setUI{
    self.view.backgroundColor=[UIColor whiteColor];
    [self.uleCustemNavigationBar ule_setBackgroudColor:[UIColor whiteColor]];
    [self.uleCustemNavigationBar ule_setTintColor:[UIColor blackColor]];
    [self.uleCustemNavigationBar customTitleLabel:@"请选择取消原因"];
    self.uleCustemNavigationBar.height_sd=50;
    self.uleCustemNavigationBar.leftBarButtonItems=nil;
    [self.uleCustemNavigationBar ule_setBottomLineHidden:YES];
    self.view.layer.masksToBounds = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
    
    UIButton * topRightCloseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [topRightCloseButton setFrame:CGRectMake(__MainScreen_Width-35, 12, 30, 30)];
    [topRightCloseButton setImage:[UIImage imageNamed:@"closeAlertIcon"] forState:UIControlStateNormal];
    [topRightCloseButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.uleCustemNavigationBar addSubview:topRightCloseButton];
    UILabel * titleLabel=[self.uleCustemNavigationBar valueForKeyPath:@"titleLabel"];
    titleLabel.font=[UIFont systemFontOfSize:16];
    UIView * lineView=[UIView new];
    lineView.backgroundColor=[UIColor convertHexToRGB:@"e4e5e4"];
    [self.view sd_addSubviews:@[self.topRemindLabel,self.cancelTableView,self.remindLabel,self.sureBtn,self.cancelBtn]];
    
    self.topRemindLabel.sd_layout
    .leftSpaceToView(self.view, 10)
    .topSpaceToView(self.uleCustemNavigationBar, 0)
    .rightSpaceToView(self.view, 10)
    .heightIs(50);
    
    self.sureBtn.sd_layout
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .widthIs(__MainScreen_Width/2)
    .heightIs(kIphoneX?69:45);
    self.cancelBtn.sd_layout
    .leftSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .widthIs(__MainScreen_Width/2)
    .heightIs(kIphoneX?69:45);
    [self.cancelBtn addSubview:lineView];
    lineView.sd_layout
    .leftSpaceToView(self.cancelBtn, 0)
    .rightSpaceToView(self.cancelBtn, 0)
    .topSpaceToView(self.cancelBtn, 0)
    .heightIs(1);
    
    
    self.remindLabel.sd_layout
    .leftSpaceToView(self.view,0)
    .bottomSpaceToView(self.cancelBtn,0)
    .rightSpaceToView(self.view,0)
    .heightIs(50);
    
    self.cancelTableView.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(self.topRemindLabel,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.remindLabel,0);
}

- (void)startRequestCancelReason{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在请求"];
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_MyOrderApi buildGetCancelOrderReason] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self frechReasonInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)startCancelOrder{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在请求"];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyOrderApi buildCancelOrderWithId:NonEmpty(self.esc_orderid) andCancelReason:self.selectedCellModel.cancelReason] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        US_CancelOrderModel *cancelModel=[US_CancelOrderModel yy_modelWithDictionary:responseObject];
        NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
        if (cancelModel!=nil&&cancelModel.data.length>0) {
            [dic setObject:cancelModel.data forKey:@"toHtml5URL"];
        }
        [dic setObject:@"1" forKey:@"orderStatus"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateOrderList object:nil userInfo:dic];
        [self dismissViewControllerAnimated:YES completion:nil];

    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];

}

- (void)frechReasonInfo:(NSDictionary *)dic{
    CancelOrderInfo * cancelOrder=[CancelOrderInfo yy_modelWithJSON:(NSDictionary *)dic];
    UleSectionBaseModel * sectionModel=[[UleSectionBaseModel alloc] init];
    for (int i=0; i<cancelOrder.indexInfo.count; i++) {
        CoItemData * item=cancelOrder.indexInfo[i];
        OrderCancelCellModel * model=[[OrderCancelCellModel alloc] initWithCellName:@"OrderCancelCell"];
        model.cancelReason=item.attribute1;
        model.isSelected=NO;
        @weakify(self);
        model.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            [self didSelectedTableView:tableView IndexPath:indexPath];
        };
        [sectionModel.cellArray addObject:model];
    }
    [self.mViewModel.mDataArray addObject:sectionModel];
    [self.cancelTableView reloadData];
}

- (void)didSelectedTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    UleSectionBaseModel * sectionMode =self.mViewModel.mDataArray[indexPath.section];
    OrderCancelCellModel * model=sectionMode.cellArray[indexPath.row];
    if (![self.selectedCellModel isEqual:model]) {
        self.selectedCellModel.isSelected=NO;
    }
    model.isSelected=!model.isSelected;
    self.selectedCellModel=model;
    [self.cancelTableView reloadData];
}

#pragma mark - <UIViewControllerTransitioningDelegate>
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _animation;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return  _animation;
}

#pragma mark - <button click>
- (void)cancelClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureClick:(id)sender{
    if (self.selectedCellModel&&self.selectedCellModel.isSelected) {
        [self startCancelOrder];
    }else {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择取消原因" afterDelay:showDelayTime];
    }
}

#pragma mark - setter and getter
- (UITableView *)cancelTableView{
    if (_cancelTableView==nil) {
        _cancelTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _cancelTableView.dataSource=self.mViewModel;
        _cancelTableView.delegate=self.mViewModel;
        _cancelTableView.separatorStyle = UITableViewCellEditingStyleNone;
    }
    return _cancelTableView;
}

- (YYLabel *)topRemindLabel{
    if (_topRemindLabel==nil) {
        _topRemindLabel=[[YYLabel alloc] initWithFrame:CGRectZero];
        _topRemindLabel.text = @"订单取消，无法恢复，特价、优惠一并取消；参与共享优惠的订单如未支付，将会一起取消";
        _topRemindLabel.font = [UIFont systemFontOfSize:13];
        _topRemindLabel.textColor=[UIColor convertHexToRGB:@"6f6f70"];
        _topRemindLabel.backgroundColor=[UIColor convertHexToRGB:@"f4f5f4"];
        _topRemindLabel.numberOfLines=0;
        _topRemindLabel.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10);
        _topRemindLabel.layer.cornerRadius = 5;
    }
    return _topRemindLabel;
}

- (YYLabel *)remindLabel{
    if (_remindLabel==nil) {
        _remindLabel=[[YYLabel alloc] initWithFrame:CGRectZero];
        _remindLabel.text = @"提醒：订单状态变为待配货且超过5分钟时，取消订单需商家审核。";
        _remindLabel.font = [UIFont systemFontOfSize:13];
        _remindLabel.textColor=[UIColor convertHexToRGB:@"fd8510"];
        _remindLabel.backgroundColor=[UIColor convertHexToRGB:@"fef2e6"];
        _remindLabel.numberOfLines=0;
        _remindLabel.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10);
    }
    return _remindLabel;
}

- (UIButton *)cancelBtn{
    if (_cancelBtn==nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:18];
        _cancelBtn.backgroundColor=[UIColor whiteColor];
        [_cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn{
    if (_sureBtn==nil) {
        _sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font=[UIFont systemFontOfSize:18];
        _sureBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3c3a"];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc] init];
    }
    return _mViewModel;
}

@end
